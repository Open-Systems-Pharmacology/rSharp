using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using ClrFacade.Tests;

// ReSharper disable UnusedMember.Global

namespace ClrFacade;

/// <summary>
///    Gathers the reflection operations on objects performed by rSharp, as well as discovery operations on the CLR.
/// </summary>
public static class ReflectionHelper
{
   /// <summary>
   ///    Gets information on the common language runtime on which this code is executing.
   ///    Purpose is to have human-readable information ot diagnose interop issues between R and the CLR runtime.
   /// </summary>
   public static string[] GetClrInfo() => InternalReflectionHelper.GetClrInfo();

   /// <summary>
   ///    Gets the simple names of assemblies loaded in the current domain.
   /// </summary>
   public static string[] GetLoadedAssemblyNames(bool fullName = false) => InternalReflectionHelper.GetLoadedAssemblyNames(fullName);

   /// <summary>
   ///    Gets the paths of assemblies if loaded in the current domain.
   /// </summary>
   public static string[] GetLoadedAssemblyURI(string[] assemblyNames) => InternalReflectionHelper.GetLoadedAssemblyURI(assemblyNames);
   
   /// <summary>
   ///    Gets the full name of types (Type.FullName) contained in an assembly, given its simple name
   /// </summary>
   public static string[] GetTypesInAssembly(string assemblyName) => InternalReflectionHelper.GetTypesInAssembly(assemblyName);

   /// <summary>
   ///    Gets human-readable signatures of the member(s) of an object or its type.
   ///    The purpose is to explore CLR object members from R.
   /// </summary>
   /// <param name="obj">The object to reflect on, or the type of the object if already known</param>
   /// <param name="memberName">The name of the object/class member, e.g. the method name</param>
   public static string[] GetSignature(object obj, string memberName) => InternalReflectionHelper.GetSignature(obj, memberName);

   public static string[] GetSignature(string typeName, string memberName) => InternalReflectionHelper.GetSignature(typeName, memberName);

   /// <summary>
   ///    Gets human-readable signatures of the member(s) of a type.
   /// </summary>
   /// <param name="type">The type to reflect on</param>
   /// <param name="memberName">The name of the object/class member, e.g. the method name</param>
   public static string[] GetSignature_Type(Type type, string memberName) => InternalReflectionHelper.GetSignature_Type(type, memberName);

   /// <summary>
   ///    Finds the first method in a type that matches a method name.
   ///    Explicit interface implementations are searched if required.
   /// </summary>
   public static MethodInfo GetMethod(Type classType, string methodName, Binder binder, BindingFlags bindingFlags, Type[] types) => InternalReflectionHelper.GetMethod(classType, methodName, binder, bindingFlags, types);
   
   public static bool HasOptionalParams(MethodInfo method) => InternalReflectionHelper.HasOptionalParams(method);

   public static bool HasVarArgs(MethodInfo method) => InternalReflectionHelper.HasVarArgs(method);

   public static bool IsVarArg(ParameterInfo parameterInfo) => InternalReflectionHelper.IsVarArg(parameterInfo);

   /// <summary>
   ///    Gets all the methods of an object with a name that contains a specific string.
   /// </summary>
   /// <param name="obj">The object to reflect on, or its type</param>
   /// <param name="pattern">The case sensitive string to look for in member names</param>
   public static string[] GetMethods(object obj, string pattern) => InternalReflectionHelper.GetMethods(obj, pattern);

   /// <summary>
   ///    Gets all the non-static public methods of an object with a name that contains a specific string.
   /// </summary>
   /// <param name="obj">The object to reflect on, or its type</param>
   /// <param name="pattern">The case sensitive string to look for in member names</param>
   public static string[] GetInstanceMethods(object obj, string pattern) => InternalReflectionHelper.GetInstanceMethods(obj, pattern);

   /// <summary>
   ///    Gets all the non-static public constructors of a class.
   /// </summary>
   /// <param name="typeName">type name</param>
   public static string[] GetConstructors(string typeName) => InternalReflectionHelper.GetConstructors(typeName);

   /// <summary>
   ///    Gets all the non-static public constructors of a class.
   /// </summary>
   /// <param name="type">type</param>
   public static string[] GetConstructors(Type type) => InternalReflectionHelper.GetConstructors(type);

   /// <summary>
   ///    Gets all the static public methods of an object with a name that contains a specific string.
   /// </summary>
   /// <param name="obj">The object to reflect on, or its type</param>
   /// <param name="pattern">The case sensitive string to look for in member names</param>
   public static string[] GetStaticMethods(object obj, string pattern) => InternalReflectionHelper.GetStaticMethods(obj, pattern);

   public static string[] GetStaticMethods(string typeName, string pattern) => InternalReflectionHelper.GetStaticMethods(typeName, pattern);

   /// <summary>
   ///    Gets all the public fields of an object with a name that contains a specific string.
   /// </summary>
   /// <param name="obj">The object to reflect on, or its type</param>
   /// <param name="pattern">The case sensitive string to look for in member names</param>
   public static string[] GetFields(object obj, string pattern) => InternalReflectionHelper.GetFields(obj, pattern);

   /// <summary>
   ///    Gets all the non-static public fields of an object with a name that contains a specific string.
   /// </summary>
   /// <param name="obj">The object to reflect on, or its type</param>
   /// <param name="pattern">The case sensitive string to look for in member names</param>
   public static string[] GetInstanceFields(object obj, string pattern) => InternalReflectionHelper.GetInstanceFields(obj, pattern);

   /// <summary>
   ///    Gets all the static fields of an object with a name that contains a specific string.
   /// </summary>
   /// <param name="obj">The object to reflect on, or its type</param>
   /// <param name="pattern">The case sensitive string to look for in member names</param>
   public static string[] GetStaticFields(object obj, string pattern) => InternalReflectionHelper.GetStaticFields(obj, pattern);

   public static string[] GetStaticFields(string typeName, string pattern) => InternalReflectionHelper.GetStaticFields(typeName, pattern);

   public static string[] GetStaticFields(Type type, string pattern) => InternalReflectionHelper.GetStaticFields(type, pattern);

   /// <summary>
   ///    Gets the value of a field of an object.
   /// </summary>
   public static object GetFieldValue(object obj, string fieldName) => InternalReflectionHelper.GetFieldValue(obj,fieldName);

   /// <summary>
   ///    Gets all the properties of an object with a name that contains a specific string.
   /// </summary>
   /// <param name="obj">The object to reflect on, or its type</param>
   /// <param name="pattern">The case sensitive string to look for in member names</param>
   public static string[] GetProperties(object obj, string pattern) => InternalReflectionHelper.GetProperties(obj, pattern);

   /// <summary>
   ///    Gets all the non-static public properties of an object with a name that contains a specific string.
   /// </summary>
   /// <param name="obj">The object to reflect on, or its type</param>
   /// <param name="pattern">The case sensitive string to look for in member names</param>
   public static string[] GetInstanceProperties(object obj, string pattern) => InternalReflectionHelper.GetInstanceProperties(obj, pattern);

   /// <summary>
   ///    Gets all the static public properties of an object with a name that contains a specific string.
   /// </summary>
   /// <param name="obj">The object to reflect on, or its type</param>
   /// <param name="pattern">The case sensitive string to look for in member names</param>
   public static string[] GetStaticProperties(object obj, string pattern) => InternalReflectionHelper.GetStaticProperties(obj, pattern);

   public static string[] GetStaticProperties(string typeName, string pattern) => InternalReflectionHelper.GetStaticProperties(typeName, pattern);

   /// <summary>
   ///    Gets the value of a property of an object.
   /// </summary>
   public static object GetPropertyValue(object obj, string propertyName) => InternalReflectionHelper.GetPropertyValue(obj, propertyName);

   public static string[] GetEnumNames(string enumTypename) => InternalReflectionHelper.GetEnumNames(enumTypename);

   public static string[] GetEnumNames(Type enumType) => InternalReflectionHelper.GetEnumNames(enumType);

   public static string[] GetEnumNames(Enum e) => InternalReflectionHelper.GetEnumNames(e);

   public static string[] GetInterfacesFullNames(Type type) => InternalReflectionHelper.GetInterfacesFullNames(type);

   public static string[] GetDeclaredMethodNames(Type type, BindingFlags bindings = BindingFlags.DeclaredOnly | BindingFlags.Public | BindingFlags.Instance) => InternalReflectionHelper.GetDeclaredMethodNames(type, bindings);
   
   internal static string SummarizeTypes(Type[] types) => InternalReflectionHelper.SummarizeTypes(types);

   internal static string[] GetMethodParameterTypes(MethodBase method) => InternalReflectionHelper.GetMethodParameterTypes(method);

   internal static void ThrowMissingMethod(Type classType, string methodName, string modifier, Type[] types) => InternalReflectionHelper.ThrowMissingMethod(classType, methodName, modifier, types);
}