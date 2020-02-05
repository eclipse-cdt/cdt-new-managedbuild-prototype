/********************************************************************************
 * Copyright (c) 2019 Renesas Electronics Europe Ltd and others
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 ********************************************************************************/
package org.eclipse.cdt.build.managed.config.ide

import com.google.inject.Guice
import org.eclipse.cdt.build.managed.config.ConfigurationDslRuntimeModule
import org.eclipse.cdt.build.managed.config.ConfigurationDslStandaloneSetup
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class ConfigurationDslIdeSetup extends ConfigurationDslStandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new ConfigurationDslRuntimeModule, new ConfigurationDslIdeModule))
	}
	
}
