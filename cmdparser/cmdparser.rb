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
# Utility class for command parsing

class CmdParser

  def initialize(cmdprefix)
    @commands = {}
    @cmdprefix = cmdprefix
  end

  def add_command(command, help, parse)
    @commands[command] = { :help => help, :parse => parse }
  end
  
  def help()
    puts "Usage: #{@cmdprefix} <command> [options]"
    puts ""
    puts "List of commands:"
    @commands.each { |cmd, value| puts "#{cmd.ljust(16)} #{value[:help]}" }
  end
  
  def parse(args)
    info = @commands[args[0]]
    if info
      info[:parse].call(args.slice(1..args.count))
    else
      help()
    end
  end

end
