/********************************************************************************
 * Copyright (c) 2019 Renesas Electronics Europe Ltd and others
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 ********************************************************************************/
package org.eclipse.cdt.build.managed.config


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class ConfigurationDslStandaloneSetup extends ConfigurationDslStandaloneSetupGenerated {

	def static void doSetup() {
		new ConfigurationDslStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
