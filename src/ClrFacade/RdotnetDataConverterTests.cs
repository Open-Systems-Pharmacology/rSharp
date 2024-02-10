using System;
using RDotNet;

namespace ClrFacade
{
   public class RdotnetDataConverterTests
   {
      public class MemTestObjectRDotnet : NumericVector
      {
         public static int counter = 0;

         public MemTestObjectRDotnet(double[] values)
            : base(REngine, values)
         {
            counter++;
         }

         ~MemTestObjectRDotnet()
         {
            counter--;
         }
      }

      public static int GetMemTestObjCounterRDotnet()
      {
         return MemTestObjectRDotnet.counter;
      }

      public static object CreateMemTestObjRDotnet()
      {
         return new MemTestObjectRDotnet(TestCases.CreateNumArray());
      }

      internal static REngine REngine
      {
         get
         {
            var rdotnetconverter = ClrFacade.DataConverter as RDotNetDataConverter;
            if (rdotnetconverter == null)
               return null;
            else
               return RDotNetDataConverter.GetEngine();
         }
      }

      private static Tuple<string, SymbolicExpression> tc(string name, double[] values)
      {
         return Tuple.Create<string, SymbolicExpression>(name, REngine.CreateNumericVector(values));
      }

      private static Tuple<string, SymbolicExpression> tc(string name, string[] values)
      {
         return Tuple.Create<string, SymbolicExpression>(name, REngine.CreateCharacterVector(values));
      }

      public static SymbolicExpression CreateTestDataFrame()
      {
         var dfFun = REngine.Evaluate("data.frame").AsFunction();
         var result = dfFun.InvokeNamed(
            tc("name", new[] { "a", "b", "c" }),
            tc("a", new[] { 1.0, 2.0, 3.0 })
         );
         return result;
      }
   }
}