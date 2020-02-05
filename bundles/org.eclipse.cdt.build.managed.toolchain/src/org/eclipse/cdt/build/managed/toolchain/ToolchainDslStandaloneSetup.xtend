/********************************************************************************
 * Copyright (c) 2019 Renesas Electronics Europe Ltd and others
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 ********************************************************************************/
package org.eclipse.cdt.build.managed.toolchain


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class ToolchainDslStandaloneSetup extends ToolchainDslStandaloneSetupGenerated {

	def static void doSetup() {
		new ToolchainDslStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
