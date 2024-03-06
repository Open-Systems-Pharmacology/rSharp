# Emacs please make this -*- mode: makefile; tab-width: 8 -*-
#
#
# Copyright (C) 2013-2015      <jean-michel.perraud@csiro.au>
#

# WARNING: Makevars is generated from Makevars.in
# You may loose direct modifications to the file Makevars!

BUILDTYPE ?= Debug

# as of mono 4.0.3 on Debian, using monosgen fails. Need to offer the option to revert to boehm GC.
# other acceptable option is MONO_LIB = mono-2

TGTPLATFORM=x64
RUNTIMECONFIG=RSharp.runtimeconfig
OBJ_DIR := obj
OUT_DIR := out
SRC_DIR := .
SRC_FILES := $(wildcard $(SRC_DIR)/*.cpp)
OBJ_FILES := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRC_FILES))
SHLIB_EXT := .so
PKG_CPPFLAGS = --std=c++11 -lsupc++

MONO_INSTALL_PATH=
MONO_INSTALL_PATH64=
OBJECTS=$(OUT_DIR)/rSharpUX.so
ifeq "$(MONO_INSTALL_PATH)" ""
XBUILD=xbuild
else
XBUILD=$(MONO_INSTALL_PATH)/bin/xbuild
endif

XBUILD=dotnet

DOTNET_CMD=dotnet

######## O/S dependent config
ifeq "$(R_OSTYPE)" "windows"
SLN=rSharp.sln

ifeq "$(BUILDTYPE)" "Release"
BuildConfiguration=Release
else
BuildConfiguration=MonoInstallDebug
endif  # ifeq "$(BUILDTYPE)" "Release"

RSHARP_LIBS=rSharpUX$(SHLIB_EXT)

# On a Win7 machine,  'pkg-config --cflags mono-2 glib-2.0'   returns
# -mno-cygwin -mms-bitfields -mwindows -IF:/bin/Mono/include/mono-2.0 -IF:/bin/Mono/include/glib-2.0 -IF:/bin/Mono/lib/glib-2.0/include
# however 'which pkg-config' is in /cygdrive/f/bin/Mono/bin/pkg-config, something unusual for windows machines (?).
# Not sure what is to be expected on CRAN winbuilder.
# -mno-cygwin is a trouble flag somehow, not to be included.
# pkg-config --libs mono-2 glib-2.0
# -Wl,--export-all-symbols -mno-cygwin -mms-bitfields -mwindows -LF:/bin/Mono/lib
# -lmono-2.0 -lws2_32 -lpsapi -lole32 -lwinmm -loleaut32 -ladvapi32 -lversion -lgl
# ib-2.0 -lintl
PKG_CFLAGS = 	-mms-bitfields -mwindows -I"$(MONO_INSTALL_PATH)/include/mono-2.0" -I"$(MONO_INSTALL_PATH)/include/glib-2.0" -I"$(MONO_INSTALL_PATH)/lib/glib-2.0/include" -D MONO_CLR -D MONO_INST
PKG_LIBS =		-mms-bitfields -mwindows -L"$(MONO_INSTALL_PATH)/lib" -lmono-2.0 -lws2_32 -lpsapi -lole32 -lwinmm -loleaut32 -ladvapi32 -lversion
ifeq "$(R_ARCH)" "/x64"
PKG_LIBS =		-mms-bitfields -mwindows -L"$(MONO_INSTALL_PATH64)/" -lmono-2.0 -lws2_32 -lpsapi -lole32 -lwinmm -loleaut32 -ladvapi32 -lversion
# PKG_LIBS =		-mms-bitfields -mwindows -LF:/bin/mono_built/lib -LF:/bin/mono_built/bin -lmono-2.0 -lws2_32 -lpsapi -lole32 -lwinmm -loleaut32 -ladvapi32 -lversion
endif  ## ifeq "$(R_ARCH)" "/x64"

RSHARPBINDIRFACADE= ./$(BuildConfiguration)

else  ## the OS is not 'windows'
SLN=rSharp_monodev.sln
ifeq "$(BUILDTYPE)" "Release"
BuildConfiguration=Unix
else
BuildConfiguration=UnixDebug
endif  ## ifeq "$(BUILDTYPE)" "Release"

PKG_CFLAGS_LOCAL=`pkg-config --cflags $(MONO_LIB) glib-2.0`
PKG_LIBS_LOCAL=`pkg-config --libs $(MONO_LIB) glib-2.0`
PKG_CFLAGS = $(PKG_CFLAGS_LOCAL) -g -D MONO_CLR -D MONO_INST
PKG_LIBS=$(PKG_LIBS_LOCAL)
# TODO: can I avoid having this platform dependent? Why did I not use BuildConfiguration folder under Linux?
RSHARPBINDIRFACADE= ./ClrFacade/bin/$(BUILDTYPE)/net8.0
endif  ## end if statement testing on  "$(R_OSTYPE)" is "windows" or not

CLR_FACADE_BINS=$(RSHARPBINDIRFACADE)/*.*

NETHOST= libnethost
INSTDIR= ../inst

MODE=Rebuild
# Note: consoleloggerparameters:ErrorsOnly works with msbuild.exe, but xbuild does not support it
SLNPROPERTIES=/p:Configuration=$(BuildConfiguration) /p:Platform="$(TGTPLATFORM)" /nologo /consoleloggerparameters:ErrorsOnly /verbosity:minimal

RM = 		rm -f

# .PHONY: 	all clean

all:		printarch instdir rSharpLib $(OUT_DIR)/rSharpUX.so rSharpInstrSharpUX

clean:
	${RM} $(OUT_DIR)/* $(OBJ_DIR)/*

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) -std=c++11 -Ipackages/Microsoft.NETCore.App.Host.linux-x64.8.0.2/runtimes/linux-x64/native $(ALL_CPPFLAGS) -I/usr/share/R/include/ $(ALL_CFLAGS) -fPIC -c $<  -o $@  -lsupc++

$(OUT_DIR)/rSharpUX.so:  $(OBJ_FILES)
	$(CXX) -std=c++11 -shared -Wl,-z,relro -o $@  $^ $(ALL_LIBS) -L./packages/Microsoft.NETCore.App.Host.linux-x64.8.0.2/runtimes/linux-x64/native -l:libnethost.a

printarch:
	-@echo **Variable information only for diagnosis purposes**
	-@echo R_ARCH=$(R_ARCH)
	-@echo OBJECTS=$(OBJECTS)
	-@echo SHLIB_EXT=$(SHLIB_EXT)
	-@echo CC=$(CC)
	-@echo CXX=$(CXX)
	-@echo **END Variable**

instdir:
	-@rm -rf $(INSTDIR)/lib$(R_ARCH)
	-@mkdir -p $(INSTDIR) 2>/dev/null
	-@mkdir -p $(INSTDIR)/lib$(R_ARCH) 2>/dev/null

rSharpInstrSharpUX: $(OUT_DIR)/rSharpUX.so
	cp -u -p $< $(INSTDIR)/lib$(R_ARCH)

rSharpLib: rSharpLibComp
	if [ -e symbols.rds ] ; then cp -u -p symbols.rds $(INSTDIR)/lib$(R_ARCH) ; fi
	-rm -f $(INSTDIR)/lib/*.*
	-cp -u -p $(CLR_FACADE_BINS) $(INSTDIR)/lib
	-cp -u -p ./$(RUNTIMECONFIG).json $(INSTDIR)/lib/

rSharpNugetRestore:
	-$(DOTNET_CMD) restore

rSharpLibComp: rSharpNugetRestore
	"$(XBUILD)" build /t:$(MODE) $(SLNPROPERTIES)