% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilities-assembly.R
\name{getTypesInAssembly}
\alias{getTypesInAssembly}
\title{Get a list of .NET type names exported by an assembly}
\usage{
getTypesInAssembly(assemblyName)
}
\arguments{
\item{assemblyName}{the name of the assembly}
}
\value{
The names of the types exported by the assembly
}
\description{
Get a list of .NET type names exported by an assembly
}
\examples{
getTypesInAssembly("ClrFacade")
}
