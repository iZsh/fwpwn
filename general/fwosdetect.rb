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
# Attempt to detect the OS.
require 'rubygems'
require 'cmdparser/fwselectoptions'
require 'fw'

module FWOSDetect

  COMMAND = "osdetect"
  HELP = "Attempt to detect the OS."

  def self.parse(args)
    # default values
    options = OpenStruct.new
    
    # Build the command line/options
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: fwpwn macosx #{COMMAND} [options]"
      FWSelectOptions::add_options(opts, options)
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
      osdetect(options.device)
    rescue => message
      puts message
      exit
    end
  end

  class << self

    def osdetect(device)
      puts "Using device #{device}"
      # it seems we can't read below 1M on some arch (iMac at least so far)
      # so we'll try to work around this limitation for now.
      blocksize = 1024*1024*15
      puts "-> reading 15M at 0x00100000 ..."
      ret = device.read(0x00100000, blocksize)
      unless ret[:resultcode] == 0
        raise "\nError code #{ret[:resultcode]} while reading " +
          "0x#{blocksize.to_s(16)} bytes at 0x0"
      end
      return if win(device, ret[:buffer])
      return if macosx(device, ret[:buffer])
      return if linux(device, ret[:buffer])
    end
    
    def macosx(device, buffer)
      version = buffer[/Darwin Kernel Version[^\000]+/, 0]
      return unless version
      puts "MacOSX detected:"
      puts " " * 4 + version
    end

    # FIXME: it doesn't seem to be possible against iMac because we can't read
    # address 0x0, but let's keep the code around...
    def macosx_hagfish(device, buffer)
      # hagfish marker should be at #0x5000
      return false unless buffer[0x5000..0x5006] == "Hagfish"
      puts "MacOSX detected..."
      puts "Retrieving version.."
      addr_big = buffer[0x501c..0x501f].unpack("N").first
      addr_little = buffer[0x501c..0x501f].unpack("V").first
      addr = addr_big
      if addr_big > addr_little
        addr = addr_little
        puts " " * 4 + "Target CPU is Little Endian"
      else
        puts " " * 4 + "Target CPU is Big Endian"
      end
      ret = device.read(addr, 1024) # read 1k
      unless ret[:resultcode] == 0
        raise "\nError code #{ret[:resultcode]} while reading " +
          "1K at 0x#{addr.to_s(16)}"
      end
      version = ret[:buffer].unpack("Z*").first
      puts " " * 4 + "Version: " + version
      return true
    end

    def win(device, buffer)
      return false
    end

    def linux(device, buffer)
      return false
    end

  end

end
