#' Turn on/off the conversion of advanced data types with R.NET
#'
#' Turn on/off the conversion of advanced data types with R.NET. This will turn off the conversion of classes such as dictionaries into R lists,
#' as these are not bidirectional and you may want to see and manipulate external pointers to dictionaries in some circumstances.
#'
#' @param enable if true enable, otherwise disable
#' @export
#' @examples
#' library(rSharp)
#' cTypename <- getRSharpSetting("testCasesTypeName")
#' callStatic(cTypename, "CreateStringDictionary")
#' setConvertAdvancedTypes(FALSE)
#' callStatic(cTypename, "CreateStringDictionary")
setConvertAdvancedTypes <- function(enable = TRUE) {
  invisible(callStatic("ClrFacade.RDotNetDataConverter", "SetConvertAdvancedTypes", enable))
}

#' List the instance members of a .NET object
#'
#' List the instance members of a .NET object, i.e. its methods, fields and properties.
#'
#' @param clrobj .NET object encapsupated as `clrobj`
#' @return a list of methods, fields and properties of the CLR object
#' @export
#' @examples
#' library(rSharp)
#' testClassName <- "ClrFacade.TestObject"
#' testObj <- clrNew(testClassName)
#' clrReflect(testObj)
clrReflect <- function(clrobj) {
  # .Call("r_reflect_on_object", clrobj@clrobj, silent=FALSE, PACKAGE="rSharp")
  list(Methods = clrGetMethods(clrobj), Fields = getFields(clrobj), Properties = clrGetProperties(clrobj))
}

#' Calls the ToString method of an object
#'
#' @description
#'
#' Calls the ToString method of an object as represented in the .NET.
#' This function is here to help quickly test object equivalence from the R interpreter,
#'  for instance on the tricky topic of date-time conversions
#'
#' @param x any R object, which is converted to a .NET object on which to call ToString
#' @return The string representation of the object in .NET
#' @export
#' @examples
#' library(rSharp)
#' dt <- as.POSIXct("2001-01-01 02:03:04", tz = "UTC")
#' toString(dt)
toString <- function(x) {
  return(callStatic(rSharpEnv$InternalTypeName, "ToString", x))
}

#' List the instance fields of a .NET object
#'
#' @param clrobj CLR object
#' @param contains a string that the field names returned must contain
#' @return a list of names of the fields of the .NET object
#' @export
#' @examples
#' testClassName <- rSharpEnv$testObjectTypeName
#' testObj <- clrNew(testClassName)
#' getFields(testObj)
#' getFields(testObj, "ieldInt")
getFields <- function(clrobj, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetInstanceFields", clrobj, contains)
}

#' List the instance properties of a CLR object
#'
#' @param clrobj CLR object
#' @param contains a string that the property names returned must contain
#' @return a list of names of the properties of the CLR object
#' @export
#' @examples
#' testClassName <- "ClrFacade.TestObject"
#' testObj <- clrNew(testClassName)
#' clrGetProperties(testObj)
#' clrGetProperties(testObj, "One")
clrGetProperties <- function(clrobj, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetInstanceProperties", clrobj, contains)
}

#' List the instance methods of a .NET object
#'
#' @param clrobj CLR object
#' @param contains a string that the methods names returned must contain
#' @return a list of names of the methods of the .NET object
#' @export
#' @examples
#' testClassName <- "ClrFacade.TestObject"
#' testObj <- clrNew(testClassName)
#' clrGetMethods(testObj)
#' clrGetMethods(testObj, "Get")
clrGetMethods <- function(clrobj, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetInstanceMethods", clrobj, contains)
}

#' Gets the signature of a .NET object member
#'
#' Gets a string representation of the signature of a member (i.e. field, property, method).
#' Mostly used to interactively search for what arguments to pass to a method.
#'
#' @param clrobj CLR object
#' @param memberName The exact name of the member (i.e. field, property, method) to search for
#' @return a character vector with summary information on the method/member signatures
#' @export
#' @examples
#' testClassName <- "ClrFacade.TestObject"
#' testObj <- clrNew(testClassName)
#' clrReflect(testObj)
#' clrGetMemberSignature(testObj, "set_PropertyIntegerOne")
#' clrGetMemberSignature(testObj, "FieldIntegerOne")
#' clrGetMemberSignature(testObj, "PropertyIntegerTwo")
clrGetMemberSignature <- function(clrobj, memberName) {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetSignature", clrobj, memberName)
}

#' Create a new CLR object
#'
#' @param typename type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param ... additional method arguments passed to the object constructor via the call to .External
#' @return a CLR object
#' @export
#' @import methods
#' @examples
#' testClassName <- rSharpEnv$testObjectTypeName
#' testObj <- clrNew(testClassName)
#' # object with a constructor that has parameters
#' testObj <- clrNew(testClassName, as.integer(123))
clrNew <- function(typename, ...) {
  o <- .External("r_create_clr_object", typename, ..., PACKAGE = rSharpEnv$nativePkgName)
  if (is.null(o)) {
    stop("Failed to create instance of type '", typename, "'")
  }
  .mkClrObjRef(o, clrtype = typename)
}

#' Gets the static members for a type
#'
#' Gets the static members for a type
#'
#' @param objOrType a CLR object, or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @export
#' @examples
#' \dontrun{
#' library(rSharp)
#' cTypename <- getRSharpSetting("testCasesTypeName")
#' clrGetStaticMembers(cTypename)
#' testClassName <- "ClrFacade.TestObject"
#' testObj <- clrNew(testClassName)
#' clrGetStaticMembers(testObj)
#' }
clrGetStaticMembers <- function(objOrType) {
  list(Methods = clrGetStaticMethods(objOrType), Fields = clrGetStaticFields(objOrType), Properties = clrGetStaticProperties(objOrType))
}

#' Gets the static fields for a type
#'
#' Gets the static fields for a type
#'
#' @param objOrType a CLR object, or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param contains a string that the property names returned must contain
#' @export
clrGetStaticFields <- function(objOrType, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetStaticFields", objOrType, contains)
}

#' Gets the static members for a type
#'
#' Gets the static members for a type
#'
#' @inheritParams clrGetStaticFields
#' @export
clrGetStaticProperties <- function(objOrType, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetStaticProperties", objOrType, contains)
}

#' Gets the static members for a type
#'
#' @inheritParams clrGetStaticFields
#' @export
clrGetStaticMethods <- function(objOrType, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetStaticMethods", objOrType, contains)
}

#' Gets the signature of a static member of a type
#'
#' @param typename type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param memberName The exact name of the member (i.e. field, property, method) to search for
#' @export
clrGetStaticMemberSignature <- function(typename, memberName) {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetSignature", typename, memberName)
}

#' Get the type code for a SEXP
#'
#' Get the type code for a SEXP, as returned by the TYPEOF macro
#'
#' @param sexp an R object
#' @return the type code, an integer, as defined in Rinternals.h
#' @export
getSexpType <- function(sexp) {
  extPtr <- .External("r_get_sexp_type", sexp, PACKAGE = rSharpEnv$nativePkgName)
  return(.mkClrObjRef(extPtr))
}

#' Peek into the structure of R objects 'as seen from C code'
#'
#' Inspect one or more R object to get information on its representation in the engine.
#' This function is mostly useful for R/rSharp developers. It is derived from the 'showArgs'
#' example in the R extension manual
#'
#' @param ... one or more R objects
#' @return NULL. Information is printed, not returned.
#' @export
inspectArgs <- function(...) {
  extPtr <- .External("r_show_args", ..., PACKAGE = rSharpEnv$nativePkgName)
  # return(.mkClrObjRef(extPtr))
}

#' Get the COM variant type of a CLR object
#'
#' Get the COM variant type of a CLR object, e.g. "VT_ARRAY | VT_I8". This function only works when run on the Microsoft implementation of the CLR.
#' This function is useful for advanced diagnosis; most users should never have to use it.
#'
#' @param objOrType a CLR object, or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param methodName the name of the method called on the object or class specified with objOrType
#' @param ... one or more arguments to pass to the function call
#' @examples
#' \dontrun{
#' library(rSharp)
#' cTypename <- getRSharpSetting("testCasesTypeName")
#' #         public static bool IsTrue(bool arg)
#' }

#' Gets the type of a CLR object resulting from converting an R object
#'
#' Gets the type of a CLR object resulting from converting an R object. This function is mostly for documentation purposes, but may be of use to end users.
#'
#' @param x An R objects
#' @return A list, with columns including mode, type,class,length and the string of the corresponding CLR type.
#' @export
rToClrType <- function(x) {
  list(
    # what = str(x),
    mode = mode(x),
    type = typeof(x),
    class = class(x),
    length = length(x),
    clrType = callStatic("ClrFacade.ClrFacade", "GetObjectTypeName", x)
  )
}

#' Gets the type of a CLR object given its type name
#'
#' Gets the type of a CLR object given its type name
#'
#' @param objOrTypename a character vector of length one. It can be the full file name of the assembly to load, or a fully qualified assembly name, or as a last resort a partial name.
#' @return the CLR Type.
#' @export
clrGetType <- function(objOrTypename) {
  if (is.character(objOrTypename)) {
    return(callStatic(rSharpEnv$clrFacadeTypeName, "GetType", objOrTypename))
  } else if ("cobjRef" %in% class(objOrTypename)) {
    return(clrCall(objOrTypename, "GetType"))
  } else {
    stop("objOrTypename is neither a cobjRef object nor a character vector")
  }
}


#' Create a reference object wrapper around a CLR object
#'
#' (EXPERIMENTAL) Create a reference object wrapper around a CLR object
#'
#' @param obj an object of S4 class clrObj
#' @param envClassWhere environment where the new generator is created.
#' @return the reference object.
clrCobj <- function(obj, envClassWhere = .GlobalEnv) {
  refgen <- setClrRefClass(obj@clrtype, envClassWhere)
  refgen$new(ref = obj)
}

#' Create reference classes for an object hierarchy
#'
#' EXPERIMENTAL Create reference classes for an object hierarchy. Gratefully acknowledge Peter D. and its rJavax work.
#'
#' @param typeName a CLR type name, recognizable by clrGetType
#' @param env environment where the new generator is created.
#' @return the object generator function
setClrRefClass <- function(typeName,
                           env = topenv(parent.frame())) {
  isAbstract <- function(type) {
    clrGet(type, "IsAbstract")
  }
  isInterface <- function(type) {
    clrGet(type, "IsInterface")
  }

  tryCatch(getRefClass(typeName),
    error = function(e) {
      type <- clrGetType(typeName)
      if (is.null(type)) stop(paste("CLR type not found for type name", typeName))

      baseType <- clrGet(type, "BaseType")
      baseTypeName <- NULL
      if (!is.null(baseType)) {
        baseTypeName <- clrGet(baseType, "FullName")
        setClrRefClass(baseTypeName, env)
      }

      # interfaces <- Map(function(interface) interface$getName(),
      # as.list(class$getInterfaces()))

      # If the type is the type for an interface, then GetInterfacesFullnames will not return 'itself', so no need to deal with infinite recursion here.
      interfaces <- callStatic(rSharpEnv$reflectionHelperTypeName, "GetInterfacesFullNames", type)

      for (ifname in interfaces) {
        setClrRefClass(ifname, env)
      }

      ## sort the interfaces lexicographically to avoid inconsistencies
      contains <- c(
        baseTypeName,
        sort(as.character(unlist(interfaces)))
      )

      ## if an interface or an abstract type, need to contain VIRTUAL
      if (isInterface(type) || isAbstract(type)) {
        contains <- c(contains, "VIRTUAL")
      }

      declaredMethods <- callStatic(rSharpEnv$reflectionHelperTypeName, "GetDeclaredMethodNames", type)
      # Map(function(method) method$getName(),
      # Filter(notProtected, as.list(class$getDeclaredMethods())))
      declaredMethods <- unique(declaredMethods)

      methods <- sapply(as.character(declaredMethods), function(method) {
        eval(substitute(function(...) {
          arguments <- Map(function(argument) {
            if (is(argument, "System.Object")) {
              argument$ref
            } else {
              argument
            }
          }, list(...))
          "TODO Here there should be the method description"
          do.call(clrCall, c(.self$ref, method, arguments))
        }, list(method = method)))
      })

      if (typeName == "System.Object") {
        setRefClass("System.Object",
          fields = list(ref = "cobjRef"),
          methods = c(methods,
            initialize = function(...) {
              argu <- list(...)
              x <- argu[["ref"]]
              if (!is.null(x)) {
                ref <<- x
              } else {
                ref <<- clrNew(class(.self), ...)
              }
              .self
              # },
              # copy = function(shallow = FALSE) {
              # ## unlike clone(), this preserves any
              # ## fields that may be present in
              # ## an R-specific subclass
              # x <- callSuper(shallow)
              # x$ref <- ref$clone()
              # x
            }
          ),
          contains = contains,
          where = env
        )
      } else {
        setRefClass(typeName,
          methods = methods,
          contains = contains,
          where = env
        )
      }
    }
  )
}
