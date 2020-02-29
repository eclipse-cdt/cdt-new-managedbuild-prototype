# cdt-new-managedbuild-prototype
Prototype of new Managed Build system for Eclipse CDT
[![Eclipse License](https://img.shields.io/badge/license-EPL--2.0-brightgreen.svg)](https://github.com/eclipse-cdt/cdt-new-managedbuild-prototype/blob/master/LICENSE)


[![Eclipse License](https://img.shields.io/badge/license-EPL--2.0-brightgreen.svg)](https://github.com/eclipse-cdt/cdt-new-managedbuild-prototype/blob/master/LICENSE)


## Overall Aims
* Replace existing Managed Build in CDT with new simple framework providing GUI managing of build settings
* Allow use from outside CDT, both in CI & new editors such as Eclipse Theia & VS Code
* Allow more extensibility to support multiple external build systems & toolchains
* Simplify CDT implementation to ensure maintainability
More information can be found in [Outline](docs/outline.md)

## Outline Design
* 4 main components:
  * Toolchain & Configuration models
  * Core Managed Build Framework - Responsible for managing the toolchain & configuration models, calling build tool extensions & providing APIs for IDE integration extensions
  * Build Tool extensions - Responsible for generating build files, invoking build tool & handling return of tool console output. Some common functionality will be provided as abstract implementations but all build logic (such as handling interfile dependencies or rebuilding when build options changed) will be left to the tool specific extensions.
  * CDT Integration - Integrates the core framework into CDT, providing the UI for build options, handling mapping configurations into the Core Build system, and providing information to the indexer (using compile-commands.json).

## Out of scope
* Internal builder - Focus is on integration with external build systems. Though framework will be designed to allow an internal build implementation to be developed as an extension
* Modeling dependencies between source files or determining tool ordering - If this is required for a particular build engine then must be implemented in support extension rather than main framework

## Current progress
* Prototype DSLs for toolchain & configuration. See examples in docs/examples

## Building in Eclipse IDE
Requirements:
 * Eclipse 2019-12 or later
 * Xtext SDK 2.20 or later
Steps:
 * Import all projects under "bundles"
 * Right click on org.eclipse.cdt.build.managed.toolchain/src/org/eclipse/cdt/build/managed/toolchain/GenerateToolchainDsl.mwe2 & select Run As -> MWE2 Workflow
 * Repeat with GenerateConfigurationDsl.mwe2
 * Select Build -> Clean and clean the workspace

## More infomation
 * [Outline](docs/outline.md)
 * [Toolchian DSL Description](docs/dsls/toolchain_dsl.md)
 * [Configuration DSL Description](docs/dsls/configuration_dsl.md)