/********************************************************************************
 * Copyright (c) 2019 Renesas Electronics Europe Ltd and others
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 ********************************************************************************/
package org.eclipse.cdt.build.managed.toolchain.validation

import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.Tool
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.Property
import org.eclipse.xtext.validation.Check
import java.util.Set
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.ToolchainDslPackage
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.Option
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.Toolchain
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.StringLiteral
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.BoolLiteral
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.PropertyHolder
import org.eclipse.xtext.validation.CheckType
import java.util.HashSet

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class ToolchainDslValidator extends AbstractToolchainDslValidator {
	
	private static val Set<String> TOOL_TYPES_VALID = #{'String', 'StringList', 'Bool', 'Enum', 'File', 'FileList', 'Directory', 'DirectoryList'}
	
	public static val INVALID_PROPERTY = 'invalidProperty'
	public static val INVALID_PROPERTY_VALUE_TYPE = 'invalidPropertyValueType'
	public static val INVALID_OPTION_TYPE = 'invalidOptionType'
	public static val MULTIPLE_PROPERTY_DEF = 'propertyMultipleDefinition'
	public static val TOOLCHIAN_PARENT_CYCLE = 'toolchainParentCycle'

	@Check
	def checkToolProperties(Tool tool) {
		val properties = tool.getProperties().map[getName() -> getValue()];
		properties
//		for(e: properties.vales) {
//
//		}
	}	

	@Check
	def checkToolchainParentCycles(Toolchain toolchain) {
		var Set<Toolchain> known = new HashSet<Toolchain>();
		var lastToolchain = toolchain;
		while(lastToolchain.getParent() !== null && !known.contains(lastToolchain)) {
			known += lastToolchain
			lastToolchain = lastToolchain.getParent()
		}
		if(known.contains(lastToolchain)) {
			error('Parent toolchain extends this one', 
				ToolchainDslPackage.Literals.TOOLCHAIN__PARENT,
				TOOLCHIAN_PARENT_CYCLE)
		}
	}

	@Check
	def checkOptionType(Option option) {
		if (!TOOL_TYPES_VALID.contains(option.getType())) {
				error('Invalid option type', 
					ToolchainDslPackage.Literals.OPTION__TYPE,
					INVALID_OPTION_TYPE)
		}
	}
	/**
	 * Provides a warning if property names are defined multiple time for a property holder
	 */
	@Check(CheckType.NORMAL)
	def checkPropertyUnique(Property property) {
		if(property.eContainer() instanceof PropertyHolder) {
			var holder = property.eContainer() as PropertyHolder
			if(holder.getProperties().filter[property.getName().equals(getName())].size > 1) {				
					warning('''«property.getName()» defined more than once for «holder.getName()»''', 
						ToolchainDslPackage.Literals.PROPERTY__NAME,
						MULTIPLE_PROPERTY_DEF)					
			}
		}
	}

	@Check
	def checkProperty(Property property) {
		var container = property.eContainer();
		switch container {
			case container instanceof Toolchain: checkToolchainProperty(property, container as Toolchain)
			case container instanceof Tool: checkToolProperty(property, container as Tool)
			case container instanceof Option: checkOptionProperty(property, container as Option)
		}
	}
	
	def checkSharedProperty(Property property) {
		switch name : property.getName() {
			case name.equals('displayName'): {
				if (!(property.getValue() instanceof StringLiteral)) {
					error('displayName must be a string', 
						ToolchainDslPackage.Literals.PROPERTY__VALUE,
						INVALID_PROPERTY_VALUE_TYPE)
				}
				return true
			} default : {
				return false
			}
		}	
	}
	def checkToolchainProperty(Property property, Toolchain toolchain) {
		if(!checkSharedProperty(property)) {
			switch name : property.getName() {
				default: {
					error('Unknown property name for tool', 
						ToolchainDslPackage.Literals.PROPERTY__NAME,
						INVALID_PROPERTY)					
				}
			}
		}		
	}
	def checkToolProperty(Property property, Tool tool) {
		if(!checkSharedProperty(property)) {
			switch name : property.getName() {
				case name.equals('command'): {
					if (!(property.getValue() instanceof StringLiteral)) {					
						error('command must be a string', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}				
				}
				case name.equals('argsPattern'): {
					if (!(property.getValue() instanceof StringLiteral)) {					
						error('command must be a string', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}				
				}
				case name.equals('multipleInputs'): {
					if (!(property.getValue() instanceof BoolLiteral)) {					
						error('multipleInputs must be a bool', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}				
				}
				case name.equals('depsType'): {
					if (!(property.getValue() instanceof StringLiteral)) {					
						error('depsType must be a string', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}				
				}
				case name.equals('depsFile'): {
					if (!(property.getValue() instanceof StringLiteral)) {					
						error('depsFile must be a string', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}				
				}
				case name.equals('rspFileCommand'): {
					if (!(property.getValue() instanceof StringLiteral)) {					
						error('rspFileCommand must be a string', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}				
				}
				case name.equals('rspFileContent'): {
					if (!(property.getValue() instanceof StringLiteral)) {					
						error('rspFileContent must be a string', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}				
				}
				case name.equals('primaryInputType'): {
					if (!(property.getValue() instanceof StringLiteral)) {					
						error('primaryInputType must be a string', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}				
				}
				default: {
					error('Unknown property name for tool', 
						ToolchainDslPackage.Literals.PROPERTY__NAME,
						INVALID_PROPERTY)					
				}
			}			
		}
	}
	def checkOptionProperty(Property property, Option option) {
		if(!checkSharedProperty(property)) {
			switch name : property.getName() {
				case name.equals('commandPattern'): {
					if (!(property.getValue() instanceof StringLiteral)) {					
						error('commandPattern must be a string', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}
				}
				case name.equals('argsGroup'): {
					if (!(property.getValue() instanceof StringLiteral)) {					
						error('argsGroup must be a string', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}
				}
				case name.equals('trueCommand'): {
					if (!(property.getValue() instanceof StringLiteral)) {					
						error('trueCommand must be a string', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}
				}
				case name.equals('falseCommand'): {
					if (!(property.getValue() instanceof StringLiteral)) {					
						error('falseCommand must be a string', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}
				}
				case name.equals('inputGroup'): {
					if (!(property.getValue() instanceof StringLiteral)) {
						error('inputGroup must be a string', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}
				}
				case name.equals('directories'): {
					if (!(property.getValue() instanceof BoolLiteral)) {					
						error('directories must be a bool', 
							ToolchainDslPackage.Literals.PROPERTY__VALUE,
							INVALID_PROPERTY_VALUE_TYPE)
					}
				}
				default: {
					error('Unknown property name for tool', 
						ToolchainDslPackage.Literals.PROPERTY__NAME,
						INVALID_PROPERTY)					
				}
			}		
		}
	}
	
}
