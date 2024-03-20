
# rSharp

<!-- badges: start -->

[![R-CMD-check](https://github.com/Open-Systems-Pharmacology/rSharp/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Open-Systems-Pharmacology/rSharp/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

<!-- README.md is generated from README.Rmd. Please edit that file -->

The **RSharp** R package provides access to .NET libraries from R. It
allows to create .NET objects, access their fields, and call their
methods.

This package is based on the [rClr](https://github.com/rdotnet/rClr)
package and utilizes some of its code base.

The package utilizes two code bases - the R code which is exposed to the
user, and the C++/C# code that communicates with the .NET libraries. The
end user of the package will only interact with the R code, and
pre-build C++/C# libraries are supplied with the package. See section
[Installation](#installation) for instructions on how to install the
package.

Advanced users and C++/C# developers might want to build the C++/C# code
from source. For this, follow the instructions in section
[Build](#build).

## Installation

### Windows

#### Prerequisites

- Latest Microsoft Visual C++ Redistributable for Visual Studio 2015,
  2017 and 2019 available
  [here](https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads)
- .NET 8 runtime available
  [here](https://dotnet.microsoft.com/download/dotnet/8.0/runtime).

#### Install from Github

You can install the package from GitHub with pre-build binaries by
running:

``` r
install.packages("remotes")
remotes::install_github("Open-Systems-Pharmacology/rSharp@*release")
```

Get the latest development version with:

``` r
remotes::install_github("Open-Systems-Pharmacology/rSharp")
```

#### Install from Binary

Alternatively, download the attached binary file from [latest
release](https://github.com/Open-Systems-Pharmacology/rSharp/releases),
and install it locally using:

``` r
install.packages("path/to/rSharp_X.zip",  type = "win.binary")
```

### Ubuntu

Run the following commands to install the required dependencies:

    sudo apt-get install dotnet-runtime-8.0 libcurl4-openssl-dev libssl-dev libxml2-dev 
    sudo apt-get install libfontconfig1-dev libharfbuzz-dev libfribidi-dev
    sudo apt-get install libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev

Symlink libdl.so.2 to libdl.so

    sudo ln -s /usr/lib/x86_64-linux-gnu/libdl.so.2 /usr/lib/x86_64-linux-gnu/libdl.so

Install the package from GitHub with pre-build binaries by running:

``` r
install.packages("remotes")
remotes::install_github("Open-Systems-Pharmacology/rSharp@*release")
```

Get the latest development version with:

``` r
remotes::install_github("Open-Systems-Pharmacology/rSharp")
```

## Build

### Windows

To build the C++/C# libraries from source, make sure the
`Desktop development with C++` workload is installed in Visual Studio.

Create an environment variable `R_INSTALL_PATH` and set the value to the
path where R is installed

    set R_INSTALL_PATH = "C:\Program Files\R\R-4.3.3"

Start Visual Studio and open the `rSharp.sln` solution file and build
the solution. The build process will automatically copy the required
files to the `rSharp/inst/lib` folder.

Then start your preferred R environment and run the following R commands
from within the `rSharp` folder

    devtools::install()

### Ubuntu

Set up .NET SDK and `nuget` (the latter to get the required
dependencies)

Optionally set up to build the binaries

    sudo apt-get install dotnet-sdk-8.0
    sudo apt-get install nuget

Navigate to the `rSharp\shared` directory and run

    make

Then change back to the `rSharp` directory start your preferred R
environment and run the following R commands

    devtools::install()

## User guide

Examples of interacting with .NET assemblies using this package are
detailed in `vignette('user-guide')`. Some useful tips around using the
package are available in the `vignette('knowledge-base')`.

## Code of conduct

Everyone interacting in the Open Systems Pharmacology community
(codebases, issue trackers, chat rooms, mailing lists etc…) is expected
to follow the Open Systems Pharmacology [code of
conduct](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CODE_OF_CONDUCT.md).

## Contribution

We encourage contribution to the Open Systems Pharmacology community.
Before getting started please read the [contribution
guidelines](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CONTRIBUTING.md).
If you are contributing code, please be familiar with the [coding
standards](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CODING_STANDARDS_R.md).

## License

The `{RSharp}` package is released under the [GPLv2 License](LICENSE).

All trademarks within this document belong to their legitimate owners.
