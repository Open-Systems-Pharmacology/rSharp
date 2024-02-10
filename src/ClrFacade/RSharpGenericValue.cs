﻿using System;
using System.Runtime.InteropServices;

namespace ClrFacade
{
   public enum RSharpValueType
   {
      INT,
      FLOAT,
      DOUBLE,
      BOOL,
      INT_ARRAY,
      FLOAT_ARRAY,
      DOUBLE_ARRAY,
      BOOL_ARRAY,
      STRING,
      STRING_ARRAY,
      OBJECT,
      NULL,
      INTPTR
   }

   public static class RSharpGenericValueExtensions
   {
      public static T[] GetArray<T>(this RSharpGenericValue genericValue)
      {
         if (genericValue.Type == RSharpValueType.INT_ARRAY && typeof(T) == typeof(int))
         {
            int[] array = new int[genericValue.Size];
            Marshal.Copy(genericValue.Value, array, 0, genericValue.Size);
            return array as T[];
         }
         else if (genericValue.Type == RSharpValueType.FLOAT_ARRAY && typeof(T) == typeof(float))
         {
            float[] array = new float[genericValue.Size];
            Marshal.Copy(genericValue.Value, array, 0, genericValue.Size);
            return array as T[];
         }
         else if (genericValue.Type == RSharpValueType.DOUBLE_ARRAY && typeof(T) == typeof(double))
         {
            double[] array = new double[genericValue.Size];
            Marshal.Copy(genericValue.Value, array, 0, genericValue.Size);
            return array as T[];
         }
         else if (genericValue.Type == RSharpValueType.BOOL_ARRAY && typeof(T) == typeof(bool))
         {
            bool[] array = new bool[genericValue.Size];
            for (int i = 0; i < genericValue.Size; i++)
            {
               array[i] = Marshal.ReadByte(genericValue.Value, i) != 0;
            }

            return array as T[];
         }
         else
         {
            throw new InvalidOperationException("Invalid array type");
         }
      }

      // Factory method to create RSharpGenericValue from an object
      public static RSharpGenericValue FromObject(object obj)
      {
         if (obj == null)
            return new RSharpGenericValue { Type = RSharpValueType.NULL, Value = IntPtr.Zero };
         // Determine the ValueType based on the actual type of the object
         RSharpValueType type;
         if (obj is int)
         {
            type = RSharpValueType.INT;
         }
         else if (obj is IntPtr ptr)
         {
            return new RSharpGenericValue
            {
               Value = ptr,
               Type = RSharpValueType.INTPTR
            };
         }
         else if (obj is float)
         {
            type = RSharpValueType.FLOAT;
         }
         else if (obj is double)
         {
            type = RSharpValueType.DOUBLE;
         }
         else if (obj is bool)
         {
            type = RSharpValueType.BOOL;
         }
         else if (obj is string objString)
         {
            type = RSharpValueType.STRING;

            RSharpGenericValue tempRes = new RSharpGenericValue();
            tempRes.Value = Marshal.StringToBSTR(objString);
            tempRes.Type = type;

            return tempRes;
         }
         else if (obj is Array arrayObj)
         {
            Type elementType = arrayObj.GetType().GetElementType();
            if (elementType == typeof(int))
            {
               type = RSharpValueType.INT_ARRAY;
            }
            else if (elementType == typeof(float))
            {
               type = RSharpValueType.FLOAT_ARRAY;
            }
            else if (elementType == typeof(double))
            {
               type = RSharpValueType.DOUBLE_ARRAY;
            }
            else if (elementType == typeof(bool))
            {
               type = RSharpValueType.BOOL_ARRAY;
            }
            else if (elementType == typeof(string))
            {
               type = RSharpValueType.STRING_ARRAY;
            }
            else //keeping it like that for now - not sure we should be supporting arrays of objects
            {
               throw new ArgumentException($"Unsupported array element type: {elementType}");
            }
         }
         else // non of the above, so we treat it as a generic object
         {
            type = RSharpValueType.OBJECT;
         }

         // Convert the object to IntPtr
         GCHandle handle = GCHandle.Alloc(obj, GCHandleType.Normal);
         IntPtr valuePtr = (IntPtr)handle;

         RSharpGenericValue result = new RSharpGenericValue();
         result.Value = valuePtr;
         result.Type = type;

         return result;
      }

      public static object GetObject(this RSharpGenericValue genericValue)
      {
         if (genericValue.Type == RSharpValueType.OBJECT)
         {
            GCHandle handle = GCHandle.FromIntPtr(genericValue.Value);
            return handle.Target;
         }
         else
         {
            throw new InvalidOperationException("Invalid object type");
         }
      }
   }

   [StructLayout(LayoutKind.Sequential)]
   public struct RSharpGenericValue
   {
      public RSharpValueType Type { get; set; }
      public IntPtr Value { get; set; }
      public int Size { get; set; }

      // Constructor for non-array types
      //public RSharpGenericValue(RSharpValueType type, IntPtr value, int size)
      //{
      //   Type = type;
      //   Value = value;
      //   Size = size;
      //}

      // Constructor for array types
      //public RSharpGenericValue(RSharpValueType type, IntPtr value)
      //{
      //   Type = type;
      //   Value = value;
      //   Size = 0; // For non-array types, set size to 0
      //}
   }
}