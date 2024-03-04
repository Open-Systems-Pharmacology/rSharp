#' #' @title NetObject
#' #' @docType class
#' #'
#' #' @description
#' #' Base wrapper class for the S4 class `cobjRef` which holds pointers to .NET objects
#' #'
#' #' @importFrom R6
#' #'
#' #' @examples
#' #' myPrintable <- R6::R6Class(
#' #'   "myPrintable",
#' #'   inherit = Printable,
#' #'   public = list(
#' #'     x = NULL,
#' #'     y = NULL,
#' #'     print = function() {
#' #'       private$printClass()
#' #'       private$printLine("x", self$x)
#' #'       private$printLine("y", self$y)
#' #'       invisible(self)
#' #'     }
#' #'   )
#' #' )
#' #'
#' #' x <- myPrintable$new()
#' #' x
NetObject <- R6::R6Class(
  "NetObject",
  cloneable = FALSE,
  active = list(
    #' @field type The type of the .NET object. Read-only
    type = function(value) {
      if (missing(value)) {
        private$.type
      } else {
        private$.throwPropertyIsReadonly("type")
      }
    },

    #' @field pointer The external pointer to the .NET object. Read-only
    pointer = function(value) {
      if (missing(value)) {
        private$.pointer
      } else {
        private$.throwPropertyIsReadonly("pointer")
      }
    },

    #' @field cobjRef The underlying `cobjRef` object. Read-only
    cobjRef = function(value) {
      if (missing(value)) {
        private$.cobjRef
      } else {
        private$.throwPropertyIsReadonly("cobjRef")
      }
    }
  ),
  private = list(
    # The external pointer to the .NET object
    .pointer = NULL,
    # Type of the .NET object
    .type = NULL,
    # The underlying `cobjRef` object
    .cobjRef = NULL,
    .printLine = function(entry, value = NULL, addTab = TRUE) {
      entries <- paste0(entry, ":", sep = "")

      # helps to visually distinguish class name from its entries
      if (addTab) {
        entries <- c("  ", entries)
      }

      value <- format(value)
      entries <- c(entries, value, "\n")
      cat(entries, sep = " ")
      invisible(self)
    },
    .printClass = function() {
      cat(class(self)[1], ": \n", sep = "")
    },
    .throwPropertyIsReadonly = function(propertyName) {
      stop(messages$errorPropertyReadOnly(propertyName))
    }
  ),
  public = list(
    #' Initialize
    #' @description Initializes the object.
    #' @param pointer The external pointer to the .NET object
    #' @return The initialized object
    #' @export
    #' @examples
    #'   testClassName <- "ClrFacade.Tests.RefClasses.LevelOneClass"
    #'   o <- .External("r_create_clr_object", testClassName, PACKAGE = getRSharpSetting("nativePkgName"))
    #'   x <- newObjectFromName(testClassName)
    #'   print(x)
    initialize = function(pointer) {
      .validateIsExtPtr(pointer)
      private$.pointer <- pointer
      # Get the type of the pointer
      private$.type <- .External("r_get_typename_externalptr", pointer, PACKAGE = rSharpEnv$nativePkgName)
      return(self)
    },

    # is = function(type) {
    #   # call static method once implemented https://github.com/Open-Systems-Pharmacology/rSharp/issues/67
    # },

    #' List the fields of the object
    #'
    #' @param contains a string that the field names returned must contain
    #' @return a list of names of the fields of the object
    #' @export
    #' @examples
    #' testClassName <- rSharpEnv$testObjectTypeName
    #' testObj <- newObjectFromName(testClassName)
    #' testObj$getFields()
    #' testObj$getFields("ieldInt")
    getFields = function(contains = "") {
      # Validate contains is string
      callStatic(rSharpEnv$reflectionHelperTypeName, "GetInstanceFields", self$pointer, contains)
    },

    #' List the properties of the object
    #'
    #' @param contains a string that the property names returned must contain
    #' @return a list of names of the properties of the object
    #' @export
    #' @examples
    #' testClassName <- "ClrFacade.TestObject"
    #' testObj <- newObjectFromName(testClassName)
    #' testObj$getProperties()
    #' testObj$getProperties("One")
    getProperties = function(contains = "") {
      # Validate contains is string
      callStatic(rSharpEnv$reflectionHelperTypeName, "GetInstanceProperties", self$pointer, contains)
    },

    #' List the methods the object
    #'
    #' @param contains a string that the methods names returned must contain
    #' @return a list of names of the methods of the object
    #' @export
    #' @examples
    #' testClassName <- "ClrFacade.TestObject"
    #' testObj <- newObjectFromName(testClassName)
    #' testObj$getMethods()
    #' testObj$getMethods("Get")
    getMethods = function(contains = "") {
      # Validate contains is string
      callStatic(rSharpEnv$reflectionHelperTypeName, "GetInstanceMethods", self$pointer, contains)
    },
    #' Print
    #' @description print prints a summary of the object.
    print = function() {
      private$.printClass()
      private$.printLine("Type", private$.type)
      private$.printLine("Methods:", self$getMethods())
      private$.printLine("Fields",  self$getFields())
      private$.printLine("Properties", self$getProperties())
      invisible(self)
    }
  )
)
#'
#'
#' # functions to move here:
#'
#' # clrToString
#' # clrGetMemberSignature
#' # clrNew
#' # clrCall
#' # clrGet
#' # clrSet
#' # clrTypename
#'
#' # Obsolete
#' # .clrGetExtPtr
