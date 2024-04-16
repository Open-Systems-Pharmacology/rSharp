BUILDTYPE ?= Debug
TGTPLATFORM=x64
RUNTIMECONFIG=RSharp.runtimeconfig
OBJ_DIR := obj
OUT_DIR := out
SRC_DIR := .
SRC_FILES := $(wildcard $(SRC_DIR)/*.cpp)
OBJ_FILES := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRC_FILES))
SHLIB_EXT := .so
INSTDIR= ../inst

# only nuget supports packages.config
NUGET_CMD=nuget
DOTNET_CMD=dotnet

ifeq "$(BUILDTYPE)" "Release"
BuildConfiguration=UnixRelease
else
BuildConfiguration=UnixDebug
endif  ## ifeq "$(BUILDTYPE)" "Release"


MODE=Rebuild

SLNPROPERTIES=/p:Configuration=$(BuildConfiguration) /p:Platform="$(TGTPLATFORM)" /nologo /consoleloggerparameters:ErrorsOnly /verbosity:minimal

RM = 		rm -f

# .PHONY: 	all clean

all:		printarch instdir rSharpLib $(OUT_DIR)/rSharpUX.so rSharpInstrSharpUX

clean:
	${RM} $(OUT_DIR)/* $(OBJ_DIR)/*

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	-@mkdir -p $(OBJ_DIR) 2>/dev/null
	$(CXX) -std=c++11 -Ipackages/Microsoft.NETCore.App.Host.linux-x64.8.0.2/runtimes/linux-x64/native $(ALL_CPPFLAGS) -I/usr/share/R/include/ $(ALL_CFLAGS) -fPIC -c $<  -o $@  -lsupc++

$(OUT_DIR)/rSharpUX.so:  $(OBJ_FILES)
	-@mkdir -p $(OUT_DIR) 2>/dev/null
	$(CXX) -std=c++11 -shared -Wl,-z,relro -o $@  $^ $(ALL_LIBS) -L./packages/Microsoft.NETCore.App.Host.linux-x64.8.0.2/runtimes/linux-x64/native -l:libnethost.a

printarch:
	-@echo **Variable information only for diagnosis purposes**
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

	-cp -u -p ./$(RUNTIMECONFIG).json $(INSTDIR)/lib/

rSharpNugetRestore:
	-$(NUGET_CMD) restore packages.config -PackagesDirectory packages
	-$(DOTNET_CMD) restore

rSharpLibComp: rSharpNugetRestore
	"$(DOTNET_CMD)" build /t:$(MODE) $(SLNPROPERTIES)
