# Outline of design & goals

## Goals
* Allow users to use any text editor to change their build settings
* No enforced links between configurations in a projects so can use the same or different toolchains
* Support for multiple build systems (planned to support Ninja & make)
* Allow integration with other IDEs (e.g. Theia)
* Creating new toolchains should not require any Eclipse or Java development
* Users should be able to extend toolchains to add custom tools themselves

## Design
* 4 main components
  * Toolchain & Configuration models
  * Core Managed Build Framework - Responsible for managing the toolchain & configuration models, calling build tool extensions & providing APIs for IDE integration extensions
  * Build Tool extensions - Responsible for generating build files, invoking build tool & handling return of tool console output. Some common functionality will be provided as abstract implementations but all build logic (such as handling interfile dependencies or rebuilding when build options changed) will be left to the tool specific extensions.
  * CDT Integration - Integrates the core framework into CDT, providing the UI for build options, handling mapping configurations into the Core Build system, and providing information to the indexer (using compile-commands.json).

## Overvall design ideas
* Xtext DSLs for both Configuration & Toolchain
* Eclipse editor with provide syntax highlighting, error & warning indication & auto complete 
* User can switch between text & GUI based editing as desired
* Language Server can provide syntax highlighting & auto complete to external editors like VS Code
* Users should be able to add custom tools to an existing toolchain within a project by creating a custom toolchain

## Toolchain
* Support options at either toolchain or tool level
* Ability to customize command line argument ordering by using “groups” with command line pattern
* Native support for response files
* No default values
* By default all options are optional, and when not specified do not contribute to the tools command line
* Ability to mark some options as required so that user must specify
* Ability to indicate what the toolchains default would be for Boolean & Enum types without causing inclusion in command line
* Should be static once created, except to fix bugs
* Different versions of a toolchain should be provided using separate toolchain files

## Configuration File
* Support for multiple build artifacts in a configuration
* Support for paths inside or outside an Eclipse workspace
* Concept of template configurations which are not directly buildable but can be used as a base
  * Idea is that Project Generators could add these to the project so they are fixed at generation time and don’t change if project is moved between versions of an IDE

## Extensibility
* Validation
  * Simple Regex based validation supported within toolchain file
  * Hooks for toolchains to provide custom validation via Java code if required
* Command line generation
  * Significantly more complex control of option & tool command line generation will be supported
  * Including custom grouping/ordering of options within command line
* Allow a toolchain to take over control of build settings UI control completely, allowing custom controls to be used
* Build Systems
  * Support for Ninja will be provided
  * Custom build systems will be supported
  * Build systems may lock to a toolchain but not the other way round. Users must always be able to use any build system even if some functionality cannot be supported
