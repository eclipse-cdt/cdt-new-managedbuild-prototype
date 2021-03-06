/********************************************************************************
 * Copyright (c) 2019 Renesas Electronics Europe Ltd and others
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 ********************************************************************************/
package org.eclipse.cdt.build.managed.toolchain.ide

import com.google.inject.Guice
import org.eclipse.cdt.build.managed.toolchain.ToolchainDslRuntimeModule
import org.eclipse.cdt.build.managed.toolchain.ToolchainDslStandaloneSetup
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class ToolchainDslIdeSetup extends ToolchainDslStandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new ToolchainDslRuntimeModule, new ToolchainDslIdeModule))
	}
	
}
