/********************************************************************************
 * Copyright (c) 2019 Renesas Electronics Europe Ltd and others
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 ********************************************************************************/
package org.eclipse.cdt.build.managed.config.ui.contentassist

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.Assignment
import com.google.inject.Inject
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.cdt.build.managed.config.configurationDsl.Configuration
import java.util.List
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.Toolchain
import java.util.ArrayList
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.cdt.build.managed.toolchain.toolchainDsl.Option
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.scoping.Scopes

/**
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#content-assist
 * on how to customize the content assistant.
 */
class ConfigurationDslProposalProvider extends AbstractConfigurationDslProposalProvider {
	@Inject
	var IQualifiedNameProvider nameProvider;
	var tcOptionNameProvider = new IQualifiedNameProvider.AbstractImpl() {
		override QualifiedName getFullyQualifiedName(EObject obj) {
			return nameProvider.getFullyQualifiedName(obj).skipFirst(1)
		}
	}
	override completeStringOptionSetting_Option(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		super.completeStringOptionSetting_Option(model, assignment, context, acceptor);
		val configuation = EcoreUtil2.getContainerOfType(model, Configuration);
		val proposals = getOptionsInScope(configuation)
		for(p : proposals) {
			acceptor.accept(createCompletionProposal(p, context))
		}
	}

	override completeIdOptionSetting_Value(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		super.completeIdOptionSetting_Value(model, assignment, context, acceptor);
		val configuation = EcoreUtil2.getContainerOfType(model, Configuration);
		val proposals = getOptionsInScope(configuation)
		for(p : proposals) {
			acceptor.accept(createCompletionProposal(p, context))
		}
	}
	
	def List<String> getOptionsInScope(Configuration config) {
		if(config.getToolchain() !== null) {
			return getOptionsInScope(config.getToolchain());
		} else {			
			return getOptionsInScope(config.getParent());
		}
	}
	
	def List<String> getOptionsInScope(Toolchain tc) {
		var list = new ArrayList<String>()
		if(tc.getParent() !== null) {
			list += getOptionsInScope(tc.getParent());
		}
		val candidates = EcoreUtil2.getAllContentsOfType(tc, Option);
		for(o : candidates) {
			list += tcOptionNameProvider.getFullyQualifiedName(o).toString() + ':'
		}
		return list
	}
}
