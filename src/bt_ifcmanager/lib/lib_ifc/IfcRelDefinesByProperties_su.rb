#  IfcRelDefinesByProperties_su.rb
#
#  Copyright 2017 Jan Brouwer <jan@brewsky.nl>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#
#

require_relative 'set.rb'
require_relative 'IfcLabel.rb'
require_relative 'IfcIdentifier.rb'
require_relative 'IfcText.rb'
require_relative File.join('IFC2X3', 'IfcPropertySet.rb')
require_relative File.join('IFC2X3', 'IfcPropertySingleValue.rb')

module BimTools
  module IfcRelDefinesByProperties_su
    
    include IFC2X3
    
    def initialize(ifc_model, sketchup)
    
      # (!) this should be automatically created by root!!!
      self.globalid = IfcManager::new_guid
      self.ownerhistory = ifc_model.owner_history
      
      self.relatedobjects = IfcManager::Ifc_Set.new()
      if sketchup.is_a?( Sketchup::AttributeDictionary )
        attr_dict = sketchup
        pset = IfcPropertySet.new( ifc_model, attr_dict )
        self.relatingpropertydefinition = pset
        pset.name = BimTools::IfcManager::IfcLabel.new( attr_dict.name ) unless attr_dict.name.nil?
        pset.hasproperties = IfcManager::Ifc_Set.new()
        attr_dict.each { | key, value |
          prop = IfcPropertySingleValue.new( ifc_model, attr_dict )
          prop.name = BimTools::IfcManager::IfcIdentifier.new( key ) 
          prop.nominalvalue = BimTools::IfcManager::IfcLabel.new( value ) # (!) not always IfcLabel
          prop.nominalvalue.long = true # adding long = true returns a full object string
          pset.hasproperties.add( prop )
        }
      end
    end # def sketchup
  end # module IfcRelDefinesByProperties_su
end # module BimTools