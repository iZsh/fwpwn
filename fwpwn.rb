#! /usr/bin/env ruby
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
#
# A set of tools to pwn a computer through FireWire

require 'cmdparser/cmdparser'
require 'general/fwlist'
require 'general/fwosdetect'
require 'general/fwmemdump'
require 'macosx/fwmacosx'

cmdparser = CmdParser.new("fwpwn")
cmdparser.add_command(FWList::COMMAND, FWList::HELP, FWList.method(:parse) )
cmdparser.add_command(FWOSDetect::COMMAND, FWOSDetect::HELP, FWOSDetect.method(:parse) )
cmdparser.add_command(FWMemdump::COMMAND, FWMemdump::HELP, FWMemdump.method(:parse) )
cmdparser.add_command(FWMacOSX::COMMAND, FWMacOSX::HELP, FWMacOSX.method(:parse) )

puts "================================================"
puts "FireWire pwn tool"
puts "Copyright (c) 2009 iZsh - izsh at iphone-dev.com"
puts "================================================"
cmdparser.parse(ARGV)
