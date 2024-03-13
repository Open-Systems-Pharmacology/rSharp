using System;

namespace ClrFacade;

// Classes and methods in this file are used dynamically by their names. 
// Do not change the names or signatures without also updating usages in R

public static class ClrFacade
{
   public static string LastException => InternalRSharpFacade.LastException;

   public delegate int CallInstanceMethodDelegate(IntPtr obj, string methodName, IntPtr arguments, int numObjects, IntPtr returnValue);

   public static int CallInstanceMethod(IntPtr obj, string methodName, IntPtr arguments, int numObjects, IntPtr returnValue) => InternalRSharpFacade.CallInstanceMethod(obj, methodName, arguments, numObjects, returnValue);

   public delegate int CreateSexpWrapperDelegate(long ptrValue, IntPtr returnValue);

   public static int CreateSexpWrapperLong(long ptrValue, IntPtr returnValue) => InternalRSharpFacade.CreateSexpWrapper(new IntPtr(ptrValue), returnValue);

   public delegate int CallStaticMethodDelegate(string typename, string methodName, IntPtr objects, int numObjects, IntPtr returnValue);

   public static int CallStaticMethod(string typename, string methodName, IntPtr objects, int numObjects, IntPtr returnValue) => InternalRSharpFacade.CallStaticMethod(typename, methodName, objects, numObjects, returnValue);

   public delegate int CurrentObjectDelegate(IntPtr returnValue);

   public static int CurrentObject(IntPtr returnValue) => InternalRSharpFacade.CurrentObject(returnValue);

   public delegate int CreateInstanceDelegate(string typename, IntPtr objects, int numObjects, IntPtr returnValue);

   public static int CreateInstance(string typename, IntPtr objects, int numObjects, IntPtr returnValue) => InternalRSharpFacade.CreateInstance(typename, objects, numObjects, returnValue);

   public delegate IntPtr GetObjectTypeNameDelegate(IntPtr obj);

   public static IntPtr GetObjectTypeName(IntPtr obj) => InternalRSharpFacade.GetObjectTypeName(obj);

   public static string GetObjectTypeName(object obj) => InternalRSharpFacade.GetObjectTypeName(obj);

   public delegate void LoadFromDelegate(string pathOrAssemblyName);

   public static void LoadFrom(string pathOrAssemblyName) => InternalRSharpFacade.LoadFrom(pathOrAssemblyName);

   public static void SetFieldOrProperty(object obj, string name, object value) => InternalRSharpFacade.SetFieldOrProperty(obj, name, value);

   public static void SetFieldOrProperty(string typename, string name, object value) => InternalRSharpFacade.SetFieldOrProperty(typename, name, value);

   public static object GetFieldOrProperty(string typename, string name) => InternalRSharpFacade.GetFieldOrProperty(typename, name);

   public static object GetFieldOrProperty(object obj, string name) => InternalRSharpFacade.GetFieldOrProperty(obj, name);

   public static Type GetType(string typename) => InternalRSharpFacade.GetType(typename);

   public delegate void FreeObjectDelegate(IntPtr obj);

   public static void FreeObject(IntPtr obj) => InternalRSharpFacade.FreeObject(obj);
   
   public static string ToString(object obj) => InternalRSharpFacade.ToString(obj);
}