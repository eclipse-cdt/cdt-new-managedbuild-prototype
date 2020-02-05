/********************************************************************************
 * Copyright (c) 2019 Renesas Electronics Europe Ltd and others
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 ********************************************************************************/
package org.eclipse.cdt.build.managed.config.ui

import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtext.ui.resource.IResourceSetProvider
import org.eclipse.xtext.ui.editor.model.IResourceForEditorInputFactory
import org.eclipse.xtext.ui.editor.model.ResourceForIEditorInputFactory
import org.eclipse.xtext.ui.resource.SimpleResourceSetProvider
import com.google.inject.Binder
import org.eclipse.xtext.ui.editor.contentassist.XtextContentAssistProcessor

/**
 * Use this class to register components to be used within the Eclipse IDE.
 */
@FinalFieldsConstructor
class ConfigurationDslUiModule extends AbstractConfigurationDslUiModule {
	/**
	 * Overridden to achieve JDT independence according to https://eclipse.org/Xtext/documentation/307_special_languages.html
	 */
	override Class<? extends IResourceForEditorInputFactory> bindIResourceForEditorInputFactory() {
		return ResourceForIEditorInputFactory
	}

	/**
	 * TODO: Implement custom logic for URIs
	 */
	override Class<? extends IResourceSetProvider> bindIResourceSetProvider() {
		return SimpleResourceSetProvider;
	}

	/**
	 * Overridden to achieve JDT independence according to https://eclipse.org/Xtext/documentation/307_special_languages.html
	 */
	override provideIAllContainersState() {
		return org.eclipse.xtext.ui.shared.Access.getWorkspaceProjectsState();
	}

	override configure(Binder binder) {
		super.configure(binder);
		binder.bind(String).annotatedWith(com.google.inject.name.Names.named(
			(XtextContentAssistProcessor.COMPLETION_AUTO_ACTIVATION_CHARS))).toInstance(".,: ");
	}
}
