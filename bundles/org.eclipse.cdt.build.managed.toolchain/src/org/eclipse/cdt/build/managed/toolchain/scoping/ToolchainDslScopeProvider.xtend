/********************************************************************************
 * Copyright (c) 2019 Renesas Electronics Europe Ltd and others
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 ********************************************************************************/
package org.eclipse.cdt.build.managed.toolchain.scoping

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.OptionInherit
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.ToolchainDslPackage
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.Option
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.Toolchain
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.common.util.BasicEList
import java.util.Set
import java.util.HashSet
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.Tool

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class ToolchainDslScopeProvider extends AbstractToolchainDslScopeProvider {
	override getScope(EObject context, EReference reference) {
	    // Handle option inheritance from tool to toolchain
	    if (context instanceof OptionInherit
	            && reference == ToolchainDslPackage.Literals.OPTION_INHERIT__OPTION) {
	        var EList<Option> candidates = new BasicEList<Option>();
	        if(context.eContainer().eContainer() instanceof Toolchain){	        	
		        val toolchainElement = context.eContainer().eContainer() as Toolchain;
		        candidates += getOptionsFromToolchain(toolchainElement, new HashSet<Toolchain>);
	        }
	        return Scopes.scopeFor(candidates)
	    } else if (context instanceof Tool
	            && reference == ToolchainDslPackage.Literals.TOOL__PARENT) {
	        var EList<Tool> candidates = new BasicEList<Tool>();
	        if(context.eContainer() instanceof Toolchain) {	        	
		        val toolchainElement = context.eContainer() as Toolchain;
		        candidates += getToolsFromToolchain(toolchainElement, new HashSet<Toolchain>);
	        }
	        return Scopes.scopeFor(candidates)
	    }
	    return super.getScope(context, reference);
	}
	
	def EList<Option> getOptionsFromToolchain(Toolchain toolchain, Set<Toolchain> knownToolchains) {
		knownToolchains += toolchain
		var EList<Option> options = new BasicEList<Option>();
		options += toolchain.getOptions();
		if(toolchain.getParent() !== null && !knownToolchains.contains(toolchain.getParent())) {
			options += getOptionsFromToolchain(toolchain.getParent(), knownToolchains);
		}
		return options
	}
	
	def EList<Tool> getToolsFromToolchain(Toolchain toolchain, Set<Toolchain> knownToolchains) {
		knownToolchains += toolchain
		var EList<Tool> tools = new BasicEList<Tool>();
		tools += toolchain.getTools();
		if(toolchain.getParent() !== null && !knownToolchains.contains(toolchain.getParent())) {
			tools += getToolsFromToolchain(toolchain.getParent(), knownToolchains);
		}
		return tools
	}
}
