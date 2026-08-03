using System;
using System.IO;
using System.Numerics;
using System.Runtime.InteropServices;
using RDotNet.NativeLibrary;
using RDotNet.Utilities;
using Xunit;

namespace RDotNet
{
   [Collection("R.NET unit tests")]
   public class UtilityTests
   {
      private const string MacFrameworkLibR = "/Library/Frameworks/R.framework/Resources/lib/libR.dylib";

      [Fact]
      public void CanSerializeComplexValues()
      {
         var result = RTypesUtil.SerializeComplexToDouble(new[] { new Complex(1, 0), new Complex(0, 1), new Complex(1, 1) });

         Assert.Equal(result, (new[] { 1d, 0, 0, 1, 1, 1 }));
      }

      /// <summary>
      ///    A non-framework R (managed by uvr, conda or Homebrew, or built from source with --prefix)
      ///    keeps libR under its own R_HOME. Returning the framework copy instead loads a second,
      ///    uninitialised R runtime into the process, which segfaults on the first SEXP that crosses.
      /// </summary>
      [SkippableFact]
      public void MacOSRLibraryFileNameComesFromRHome()
      {
         Skip.IfNot(IsMacOS());
         var rHome = CreateTemporaryDirectory();
         var libR = Path.Combine(rHome, "lib", "libR.dylib");
         Directory.CreateDirectory(Path.GetDirectoryName(libR));
         File.WriteAllText(libR, string.Empty);
         var previousRHome = Environment.GetEnvironmentVariable("R_HOME");
         try
         {
            Environment.SetEnvironmentVariable("R_HOME", rHome);

            Assert.Equal(libR, NativeUtility.GetRLibraryFileName());
         }
         finally
         {
            Environment.SetEnvironmentVariable("R_HOME", previousRHome);
            Directory.Delete(rHome, true);
         }
      }

      [SkippableFact]
      public void MacOSRLibraryFileNameFallsBackToFrameworkWithoutAnRHomeLibrary()
      {
         Skip.IfNot(IsMacOS());
         var rHome = CreateTemporaryDirectory();
         var previousRHome = Environment.GetEnvironmentVariable("R_HOME");
         try
         {
            Environment.SetEnvironmentVariable("R_HOME", rHome);

            Assert.Equal(MacFrameworkLibR, NativeUtility.GetRLibraryFileName());

            Environment.SetEnvironmentVariable("R_HOME", null);

            Assert.Equal(MacFrameworkLibR, NativeUtility.GetRLibraryFileName());
         }
         finally
         {
            Environment.SetEnvironmentVariable("R_HOME", previousRHome);
            Directory.Delete(rHome, true);
         }
      }

      private static bool IsMacOS()
      {
         return RuntimeInformation.IsOSPlatform(OSPlatform.OSX);
      }

      private static string CreateTemporaryDirectory()
      {
         var path = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
         Directory.CreateDirectory(path);
         return path;
      }
   }
}