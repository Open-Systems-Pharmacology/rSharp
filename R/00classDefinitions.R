# Declares the S4 class that is used to hold references to .NET objects.
# rSharp C++ code still relies on this class
setClass("cobjRef", representation(clrobj = "externalptr", clrtype = "character"), prototype = list(clrobj = NULL, clrtype = "System.Object"))
