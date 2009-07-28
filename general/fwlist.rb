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
# List the devices connected to the FireWire interface.
require 'rubygems'
require 'fw'

module FWList

  COMMAND = "list"
  HELP = "list the available devices."

  def self.parse(args)
    list
  end

  class << self

    def list()
      puts "List of FireWire devices:"
      puts ""
      devices = FW::scanbus()
      for device in devices
        puts "* " + device.to_s
        puts " " * 4 + "GUID: ".ljust(16) + device.guid.to_ui64
        puts " " * 4 + "Vendor Name: ".ljust(16) + device.vendorName
        puts " " * 4 + "VendorID: ".ljust(16) + "0x" + device.vendorID.to_s(16)
        puts " " * 4 + "NodeID: ".ljust(16) + "0x" + device.nodeID.to_s(16)
        puts " " * 4 + "Speed: ".ljust(16) + device.speed.to_s
      end
    end

  end

end
