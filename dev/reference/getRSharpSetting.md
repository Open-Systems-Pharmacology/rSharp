# getRSharpSetting

Get the value of a global rSharp setting.

## Usage

``` r
getRSharpSetting(settingName)
```

## Arguments

- settingName:

  String name of the setting

## Value

Value of the setting stored in rSharpEnv. If the setting does not exist,
an error is thrown.

## Examples

``` r
getRSharpSetting("nativePkgName")
#> [1] "rSharp.linux"
```
