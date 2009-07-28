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
# Common FireWire device selection options
# -f, --fw0                        Select the first FireWire device available
# -g, --guid <GUID>                Select a FireWire device given its GUID
require 'rubygems'
require 'optparse'
require 'fw'

module FWSelectOptions
  
  class << self
        
    def add_options(opts, options)
      opts.define("-f", "--fw0",
        "Select the first FireWire device available", :NONE) do
        fw0_option(options)
      end
      opts.define("-g", "--guid <GUID>",
        "Select a FireWire device given its GUID", :REQUIRED) do |guid|
        guid_option(guid, options)
      end
    end
    
    def verify_selection(opts, options)
      raise "No FireWire device has been selected!" unless options.device
    end
    
    def fw0_option(options)
      devices = FW::scanbus()
      raise "No FireWire device available" unless devices && devices.size > 0
      options.device = devices[0]
    end
    
    def guid_option(guid, options)
      devices = FW::scanbus().reject { |d| d.guid.to_ui64 != guid }
      raise "FireWire device not found!" unless devices && devices.size > 0
      options.device = devices[0]
    end

  end
  
end