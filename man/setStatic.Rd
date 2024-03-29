% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilities-static.R
\name{setStatic}
\alias{setStatic}
\title{Sets the value of a field or property of an object or class}
\usage{
setStatic(type, name, value, asInteger = FALSE)
}
\arguments{
\item{type}{Type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.}

\item{name}{the name of a field/property of the object}

\item{value}{The value to set the field with}

\item{asInteger}{Boolean whether to convert the value to an integer.
Used for cases where .NET signature requires an integer. Ignored if `value` is not numeric.}
}
\description{
Sets the value of a field or property of an object or class
}
\examples{
testClassName <- getRSharpSetting("testObjectTypeName")
setStatic(testClassName, "StaticPropertyIntegerOne", as.integer(42))
}
