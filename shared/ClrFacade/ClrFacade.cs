﻿using System;
using System.Reflection;

namespace ClrFacade;

public static class ClrFacade
{
   public static string LastException => Internal.LastException;

   // ReSharper disable UnusedMember.Global
   public delegate int CallInstanceMethodDelegate(IntPtr obj, string methodName, IntPtr arguments, int numObjects, IntPtr returnValue);

   public static int CallInstanceMethod(IntPtr obj, string methodName, IntPtr arguments, int numObjects, IntPtr returnValue) => Internal.CallInstanceMethod(obj, methodName, arguments, numObjects, returnValue);

   public delegate int CreateSexpWrapperDelegate(long ptrValue, IntPtr returnValue);

   public static int CreateSexpWrapperLong(long ptrValue, IntPtr returnValue) => Internal.CreateSexpWrapper(new IntPtr(ptrValue), returnValue);

   public delegate int CallStaticMethodDelegate(string typename, string methodName, IntPtr objects, int numObjects, IntPtr returnValue);

   public static int CallStaticMethod(string typename, string methodName, IntPtr objects, int numObjects, IntPtr returnValue) => Internal.CallStaticMethod(typename, methodName, objects, numObjects, returnValue);

   public delegate int CurrentObjectDelegate(IntPtr returnValue);

   public static int CurrentObject(IntPtr returnValue) => Internal.CurrentObject(returnValue);

   public delegate int CreateInstanceDelegate(string typename, IntPtr objects, int numObjects, IntPtr returnValue);

   public static int CreateInstance(string typename, IntPtr objects, int numObjects, IntPtr returnValue) => Internal.CreateInstance(typename, objects, numObjects, returnValue);

   public delegate IntPtr GetObjectTypeNameDelegate(IntPtr obj);

   public static IntPtr GetObjectTypeName(IntPtr obj) => Internal.GetObjectTypeName(obj);

   public static string GetObjectTypeName(object obj) => Internal.GetObjectTypeName(obj);

   public delegate int LoadFromDelegate(string pathOrAssemblyName, IntPtr returnValue);

   public static int LoadFrom(string pathOrAssemblyName, IntPtr returnValue) => Internal.LoadFrom(pathOrAssemblyName, returnValue);

   public static void SetFieldOrProperty(object obj, string name, object value) => Internal.SetFieldOrProperty(obj, name, value);

   public static void SetFieldOrProperty(string typename, string name, object value) => Internal.SetFieldOrProperty(typename, name, value);

   public static object GetFieldOrProperty(string typename, string name) => Internal.GetFieldOrProperty(typename, name);

   public static object GetFieldOrProperty(object obj, string name) => Internal.GetFieldOrProperty(obj, name);

   public static Type GetType(string typename) => Internal.GetType(typename);

   public delegate void FreeObjectDelegate(IntPtr obj);

   public static void FreeObject(IntPtr obj) => Internal.FreeObject(obj);
   
   public static string ToString(object obj) => Internal.ToString(obj);
   // ReSharper restore UnusedMember.Global
}