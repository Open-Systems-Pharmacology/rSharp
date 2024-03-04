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
    #'   x <- NetObject$new(o)
    #'   print(x)
    initialize = function(pointer) {
      .validateIsExtPtr(pointer)
      private$.pointer <- pointer
      # Get the type of the pointer
      private$.type <- .External("r_get_typename_externalptr", pointer, PACKAGE = rSharpEnv$nativePkgName)
      return(self)
    },

#' List the instance members of a .NET object
#'
#' @description
#' List the instance members of a .NET object, i.e. its methods, fields and properties.
#'
#' @return A list of methods, fields, and properties of the object
#' @export
#'
#' @examples
#' testClassName <- "ClrFacade.TestObject"
#' testObj <- newObjectFromName(testClassName)
#' testObj$reflect()
    reflect = function(){
      return(list(Methods = clrGetMethods(self), Fields = getFields(self), Properties = clrGetProperties(self)))
    },

    # is = function(type) {
    #   # call static method once implemented https://github.com/Open-Systems-Pharmacology/rSharp/issues/67
    # },

    #' Print
    #' @description print prints a summary of the object.
    print = function() {
      private$.printClass()
      private$.printLine("Type", private$.type)
      private$.printLine("Methods:", clrGetMethods(self))
      private$.printLine("Fields",  getFields(self))
      private$.printLine("Properties", clrGetProperties(self))
      invisible(self)
    }
  )
)
#'
#'
#' # functions to move here:
#'
#' # clrReflect - will not be used, use separate methods instead
#' # clrToString
#' # clrGetFields
#' # clrGetProperties
#' # clrGetMethods
#' # clrGetMemberSignature
#' # clrNew
#' # clrCall
#' # clrGet
#' # clrSet
#' # clrTypename
#'
#' # Obsolete
#' # .clrGetExtPtr
