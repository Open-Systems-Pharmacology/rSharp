#' Turn on/off the conversion of advanced data types with R.NET
#'
#' Turn on/off the conversion of advanced data types with R.NET. This will turn off the conversion of classes such as dictionaries into R lists,
#' as these are not bidirectional and you may want to see and manipulate external pointers to dictionaries in some circumstances.
#'
#' @param enable if true enable, otherwise disable
#' @export
#' @examples
#' library(rSharp)
#' cTypename <- "ClrFacade.TestCases"
#' callStatic(cTypename, "CreateStringDictionary")
#' setConvertAdvancedTypes(FALSE)
#' callStatic(cTypename, "CreateStringDictionary")
setConvertAdvancedTypes <- function(enable = TRUE) {
  invisible(clrCallStatic("ClrFacade.RDotNetDataConverter", "SetConvertAdvancedTypes", enable))
}
#' List the instance members of a CLR object
#'
#' List the instance members of a CLR object, i.e. its methods, fields and properties.
#'
#' @param clrobj CLR object
#' @return a list of methods, fields and properties of the CLR object
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' testClassName <- "Rclr.TestObject"
#' testObj <- clrNew(testClassName)
#' clrReflect(testObj)
#' }
clrReflect <- function(clrobj) {
  # .Call("r_reflect_on_object", clrobj@clrobj, silent=FALSE, PACKAGE="rClr")
  list(Methods = clrGetMethods(clrobj), Fields = clrGetFields(clrobj), Properties = clrGetProperties(clrobj))
}

#' Calls the ToString method of an object
#'
#' Calls the ToString method of an object as represented in the CLR.
#' This function is here to help quickly test object equivalence from the R interpreter, for instance on the tricky topic of date-time conversions
#'
#' @param x any R object, which is converted to a CLR object on which to call ToString
#' @return the string representation of the object in the CLR
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' dt <- as.POSIXct("2001-01-01 02:03:04", tz = "UTC")
#' clrToString(dt)
#' }
clrToString <- function(x) {
  return(callStatic(rSharpEnv$clrFacadeTypeName, "ToString", x))
}

#' List the instance fields of a CLR object
#'
#' @param clrobj CLR object
#' @param contains a string that the field names returned must contain
#' @return a list of names of the fields of the CLR object
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' testClassName <- "Rclr.TestObject"
#' testObj <- clrNew(testClassName)
#' clrGetFields(testObj)
#' clrGetFields(testObj, "ieldInt")
#' }
clrGetFields <- function(clrobj, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetInstanceFields", clrobj, contains)
}

#' List the instance properties of a CLR object
#'
#' @param clrobj CLR object
#' @param contains a string that the property names returned must contain
#' @return a list of names of the properties of the CLR object
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' testClassName <- "Rclr.TestObject"
#' testObj <- clrNew(testClassName)
#' clrGetProperties(testObj)
#' clrGetProperties(testObj, "One")
#' }
clrGetProperties <- function(clrobj, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetInstanceProperties", clrobj, contains)
}

#' List the instance methods of a CLR object
#'
#' @param clrobj CLR object
#' @param contains a string that the methods names returned must contain
#' @return a list of names of the methods of the CLR object
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' testClassName <- "Rclr.TestObject"
#' testObj <- clrNew(testClassName)
#' clrGetMethods(testObj)
#' clrGetMethods(testObj, "Get")
#' }
clrGetMethods <- function(clrobj, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetInstanceMethods", clrobj, contains)
}

#' Gets the signature of a CLI object member
#'
#' Gets a string representation of the signature of a member (i.e. field, property, method).
#' Mostly used to interactively search for what arguments to pass to a method.
#'
#' @param clrobj CLR object
#' @param memberName The exact name of the member (i.e. field, property, method) to search for
#' @return a character vector with summary information on the method/member signatures
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' testClassName <- "Rclr.TestObject"
#' testObj <- clrNew(testClassName)
#' clrReflect(testObj)
#' clrGetMemberSignature(testObj, "set_PropertyIntegerOne")
#' clrGetMemberSignature(testObj, "FieldIntegerOne")
#' clrGetMemberSignature(testObj, "PropertyIntegerTwo")
#' }
clrGetMemberSignature <- function(clrobj, memberName) {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetSignature", clrobj, memberName)
}

#' Create a new NetObject R6 object
#'
#' @param typename type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param ... additional method arguments passed to the object constructor via the call to .External
#' @return a `NetObject` R6 object
#' @export
#' @examples
#' \dontrun{
#' testClassName <- "Rclr.TestObject"
#' (testObj <- clrNew(testClassName))
#' # object with a constructor that has parameters
#' (testObj <- clrNew(testClassName, as.integer(123)))
#' clrLoadAssembly("System.Windows.Forms, Version=2.0.0.0,
#'   Culture=neutral, PublicKeyToken=b77a5c561934e089")
#' f <- clrNew("System.Windows.Forms.Form")
#' clrSet(f, "Text", "Hello from '.NET'")
#' clrCall(f, "Show")
#' }
clrNew <- function(typename, ...) {
  o <- .External("r_create_clr_object", typename, ..., PACKAGE = rSharpEnv$nativePkgName)
  if (is.null(o)) {
    stop("Failed to create instance of type '", typename, "'")
  }
  NetObject$new(o)
}

#' System function to get a direct access to an object
#'
#' This function needs to be exported, but is highly unlikely to be of any use to an end user, even an advanced one.
#' This is indirectly needed to unlock the benefits of using R.NET convert data structures between R and .NET.
#' Using this function is a critical part of solving the rather complicated issue rClr #33.
#'
#' @return a `NetObject` R6 object
#' @export
getCurrentConvertedObject <- function() {
  o <- .External("r_get_object_direct", PACKAGE = rSharpEnv$nativePkgName)
  NetObject$new(o)
}

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
      interfaces <- callStatic(rSharpEnv$reflectionHelperTypeName, "GetInterfacesFullnames", type)

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
