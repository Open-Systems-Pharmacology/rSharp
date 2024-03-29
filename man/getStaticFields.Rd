% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilities-static.R
\name{getStaticFields}
\alias{getStaticFields}
\title{Gets the static fields for a type}
\usage{
getStaticFields(objOrType, contains = "")
}
\arguments{
\item{objOrType}{a `NetObject` object, or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.}

\item{contains}{a string that the property names returned must contain}
}
\description{
Gets the static fields for a type
}
