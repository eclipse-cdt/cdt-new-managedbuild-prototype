# Toolchain file design

[ToolchainDsl.xtext](../../bundles/org.eclipse.cdt.build.managed.toolchain/src/org/eclipse/cdt/build/managed/toolchain/ToolchainDsl.xtext)

A toolchain file must contain one (and only one) toolchain definition.
## toolchain
A toolchain definition contains a set of properties, options & tools. 

```
toolchain example {
    displayName: "Example"
    option exampleOption as String {
        ...
    }
    tool exampleTool {
        ...
    }
}
```

Toolchains can extend another. When extending a toolchain all options & tools are inherited.

```
toolchain example2 extends example {

}
```

Valid properties of a toolchain are:
| Property | Description | Type | Example |
| --- | --- | --- | --- |
| displayName | Display name of the toolchain | String | "Cross GCC" |

## tool

A toolchain definition contains a set of properties, options.
```
tool assembler {
    displayName: "GCC Assembler"
    command: "as"
    argsPattern: "${flags} -o ${output} ${inputs}"
    option exampleOption as String {
        ...
    }
}
```

## Inheriting options from parent toolchain
A tool can inherit options defined in the toolchain. When inheriting an option the following properties can be overridden:
* TODO

```
    inherit test {
        ...
    }
```
## option
