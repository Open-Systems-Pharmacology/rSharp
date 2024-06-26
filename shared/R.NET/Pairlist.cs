﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using RDotNet.Internals;

namespace RDotNet
{
   /// <summary>
   ///    A pairlist.
   /// </summary>
   public class Pairlist : SymbolicExpression, IEnumerable<Symbol>
   {
      /// <summary>
      ///    Creates a pairlist.
      /// </summary>
      /// <param name="engine">The engine</param>
      /// <param name="pointer">The pointer.</param>
      protected internal Pairlist(REngine engine, IntPtr pointer)
         : base(engine, pointer)
      {
      }

      /// <summary>
      ///    Gets the number of nodes.
      /// </summary>
      public int Count
      {
         get { return this.GetFunction<Rf_length>()(handle); }
      }

      #region IEnumerable<Symbol> Members

      /// <summary>
      ///    Gets an enumerator over this pairlist
      /// </summary>
      /// <returns>The enumerator</returns>
      public IEnumerator<Symbol> GetEnumerator()
      {
         if (Count != 0)
         {
            var sexprecType = Engine.GetSEXPRECType();
            for (dynamic sexp = GetInternalStructure(); sexp.sxpinfo.type != SymbolicExpressionType.Null; sexp = Convert.ChangeType(Marshal.PtrToStructure(sexp.listsxp.cdrval, sexprecType), sexprecType))
            {
               yield return new Symbol(Engine, sexp.listsxp.tagval);
            }
         }
      }

      IEnumerator IEnumerable.GetEnumerator()
      {
         return GetEnumerator();
      }

      #endregion IEnumerable<Symbol> Members
   }
}