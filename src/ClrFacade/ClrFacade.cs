using System;
using System.Reflection;

namespace ClrFacade
{
   public static class ClrFacade
   {
      // ReSharper disable UnusedMember.Global
      public delegate int CallInstanceMethodDelegate(IntPtr obj, string methodName, IntPtr arguments, int numObjects, IntPtr returnValue);

      public static int CallInstanceMethod(IntPtr obj, string methodName, IntPtr arguments, int numObjects, IntPtr returnValue)
      {
         return Internal.CallInstanceMethod(obj, methodName, arguments, numObjects, returnValue);
      }

      public delegate int CreateSexpWrapperDelegate(long ptrValue, IntPtr returnValue);

      public static int CreateSexpWrapperLong(long ptrValue, IntPtr returnValue)
      {
         return Internal.CreateSexpWrapper(new IntPtr(ptrValue), returnValue);
      }

      public delegate int CallStaticMethodDelegate(string typename, string methodName, IntPtr objects, int numObjects, IntPtr returnValue);
      public static int CallStaticMethod(string typename, string methodName, IntPtr objects, int numObjects, IntPtr returnValue)
      {
         return Internal.CallStaticMethod(typename, methodName, objects, numObjects, returnValue);
      }

      public delegate int CurrentObjectDelegate(IntPtr returnValue);

      public static int CurrentObject(IntPtr returnValue)
      {
         return Internal.CurrentObject(returnValue);
      }

      public delegate int CreateInstanceDelegate(string typename, IntPtr objects, int numObjects, IntPtr returnValue);

      public static int CreateInstance(string typename, IntPtr objects, int numObjects, IntPtr returnValue)
      {
         return Internal.CreateInstance(typename, objects, numObjects, returnValue);
      }

      public delegate IntPtr GetObjectTypeNameDelegate(IntPtr obj);

      public static IntPtr GetObjectTypeName(IntPtr obj)
      {
         return Internal.GetObjectTypeName(obj);
      }

      public delegate Assembly LoadFromDelegate(string pathOrAssemblyName);

      public static Assembly LoadFrom(string pathOrAssemblyName)
      {
         return Internal.LoadFrom(pathOrAssemblyName);
      }

      public static void SetFieldOrProperty(object obj, string name, object value)
      {
         Internal.SetFieldOrProperty(obj, name, value);
      }

      public static void SetFieldOrProperty(string typename, string name, object value)
      {
         Internal.SetFieldOrProperty(typename, name, value);
      }

      public static object GetFieldOrProperty(string typename, string name)
      {
         return Internal.GetFieldOrProperty(typename, name);
      }

      public static object GetFieldOrProperty(object obj, string name)
      {
         return Internal.GetFieldOrProperty(obj, name);
      }

      public static Type GetType(string typename)
      {
         return Internal.GetType(typename);
      }
      // ReSharper restore UnusedMember.Global
   }
}