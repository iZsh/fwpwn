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
# Common memory address options
# -b, --begin-addr                 Address to start the dump from (default: 0x0)
# -e, --end-addr                   Address to end the dump to (default: 0x80000000)
# -B, --blocksize                  Blocksize to use while reading(default: 0x400000)
require 'rubygems'
require 'optparse'

module MemaddrOptions
  
  class << self
        
    def add_options(opts, options)
      #default values
      options.beginaddr = 0x00000000
      options.endaddr =   0x80000000
      options.blocksize = 1024*1024*4
      # optionts
      opts.define("-b", "--begin-addr", OptionParser::OctalInteger,
          ("Address to start the dump from " +
          "(default: 0x#{options.beginaddr.to_s(16)})"), :REQUIRED) do |addr|
        options.beginaddr = addr
      end
      opts.define("-e", "--end-addr", OptionParser::OctalInteger,
          ("Address to end the dump to " +
          "(default: 0x#{options.endaddr.to_s(16)})"), :REQUIRED) do |addr|
        options.endaddr = addr
      end
      opts.define("-B", "--blocksize", OptionParser::OctalInteger,
          ("Blocksize to use while reading" +
          "(default: 0x#{options.blocksize.to_s(16)})"), :REQUIRED) do |addr|
        options.blocksize = addr
      end
    end

  end

end