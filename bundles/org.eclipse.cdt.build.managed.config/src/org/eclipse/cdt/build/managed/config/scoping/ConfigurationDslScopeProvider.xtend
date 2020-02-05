/********************************************************************************
 * Copyright (c) 2019 Renesas Electronics Europe Ltd and others
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 ********************************************************************************/
package org.eclipse.cdt.build.managed.config.scoping

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.cdt.build.managed.config.configurationDsl.OptionSetting
import org.eclipse.cdt.build.managed.config.configurationDsl.ConfigurationDslPackage
import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.Option
import com.google.inject.Inject
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.cdt.build.managed.config.configurationDsl.Configuration
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.scoping.IScope
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.Toolchain

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class ConfigurationDslScopeProvider extends AbstractConfigurationDslScopeProvider {
	@Inject
	var IQualifiedNameProvider nameProvider;

	override getScope(EObject context, EReference reference) {
		// Handle option inheritance from tool to toolchain
		if (context instanceof OptionSetting && reference == ConfigurationDslPackage.Literals.OPTION_SETTING__OPTION) {
			val configuation = EcoreUtil2.getContainerOfType(context, Configuration);
//			if (configuation.getToolchain() != null) {
//				val tc = configuation.getToolchain();
//				if(tc !== null) {
//				var candidates = EcoreUtil2.getAllContentsOfType(tc, Option);
//					return Scopes.scopeFor(candidates, new IQualifiedNameProvider.AbstractImpl() {
//						override QualifiedName getFullyQualifiedName(EObject obj) {
//							return nameProvider.getFullyQualifiedName(obj).skipFirst(1)
//						}
//	
//					}, IScope.NULLSCOPE);					
//				}
//
//			}
			// return Scopes.scopeFor(candidates)
			return getOptionsInScope(configuation)
		}
		return super.getScope(context, reference);
	}
	
	def IScope getOptionsInScope(Configuration config) {
		if(config.getToolchain() !== null) {
			return Scopes.scopeFor(new BasicEList<EObject>(), getOptionsInScope(config.getToolchain()));
		} else {			
			return Scopes.scopeFor(new BasicEList<EObject>(), getOptionsInScope(config.getParent()));
		}
	}
	
	def IScope getOptionsInScope(Toolchain tc) {
		var outerScope = IScope.NULLSCOPE
		if(tc.getParent() !== null) {
			outerScope = getOptionsInScope(tc.getParent());
		}
		val candidates = EcoreUtil2.getAllContentsOfType(tc, Option);
		return Scopes.scopeFor(candidates, new IQualifiedNameProvider.AbstractImpl() {
			override QualifiedName getFullyQualifiedName(EObject obj) {
				return nameProvider.getFullyQualifiedName(obj).skipFirst(1)
			}

		}, outerScope);	
	}
}
