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
# Command subset for MacOSX
require 'rubygems'
require 'cmdparser/cmdparser'
require 'macosx/fwmacloginpwd'

module FWMacOSX

  COMMAND = "macosx"
  HELP = "MacOSX subset"

  def self.parse(args)
    cmdparser = CmdParser.new("fwpwn #{COMMAND}")
    cmdparser.add_command(FWMacLoginPwd::COMMAND, FWMacLoginPwd::HELP, FWMacLoginPwd.method(:parse) )
    cmdparser.parse(args)
  end

end
