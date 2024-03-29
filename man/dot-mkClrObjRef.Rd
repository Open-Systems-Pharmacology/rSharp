% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rSharp-internal.R
\name{.mkClrObjRef}
\alias{.mkClrObjRef}
\title{Create if possible an S4 `cobjRef` object.}
\usage{
.mkClrObjRef(obj, clrtype = NULL)
}
\arguments{
\item{obj}{the presumed external pointer.}

\item{clrtype}{character; the name of the type for the object. If NULL, rSharp retrieves the type name.}
}
\value{
a cobjRef S4 object if the argument is indeed an external pointer,
otherwise returned unchanged.
}
\description{
Create if possible and adequate the S4 object that wraps the external pointer to a `cobjRef` object.
}
