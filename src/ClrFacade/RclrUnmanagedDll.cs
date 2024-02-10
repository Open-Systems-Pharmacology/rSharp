using System;
using System.IO;
using DynamicInterop;

namespace ClrFacade
{
   public class RclrUnmanagedDll : IUnmanagedDll
   {
      public RclrUnmanagedDll(string dllName)
      {
         if (!File.Exists(dllName))
         {
            throw new FileNotFoundException(dllName);
         }

         this.dll = new UnmanagedDll(dllName);
         this.ClrObjectToSexp = dll.GetFunction<ClrObjectToSexpDelegate>("rsharp_object_to_SEXP");
      }

      public ClrObjectToSexpDelegate ClrObjectToSexp { get; set; }

      private readonly UnmanagedDll dll;

      public IntPtr GetFunctionAddress(string entryPointName)
      {
         return dll.GetFunctionAddress(entryPointName);
      }
   }
}