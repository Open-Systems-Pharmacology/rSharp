﻿using System;
using System.Runtime.InteropServices;

namespace RDotNet.Internals.ALTREP
{
   [StructLayout(LayoutKind.Sequential, Pack = 1)]
   internal struct SEXPREC_HEADER
   {
      public sxpinfo sxpinfo;
      public IntPtr attrib;
      public IntPtr gengc_next_node;
      public IntPtr gengc_prev_node;
   }
}