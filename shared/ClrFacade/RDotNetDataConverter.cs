namespace ClrFacade;

// Classes and methods in this file are used dynamically by their names. 
// Do not change the names or signatures without also updating usages in R
public static class RDotNetDataConverter
{
   public static void SetRDotNet(bool setIt, string pathToNativeSharedObj = null) => InternalRDotNetDataConverter.SetRDotNet(setIt, pathToNativeSharedObj);

   public static void SetConvertAdvancedTypes(bool enable) => InternalRDotNetDataConverter.SetConvertAdvancedTypes(enable);
}