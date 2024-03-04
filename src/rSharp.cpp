#include "rSharp.h"

//for logging
#include <fstream>


#define TOPOF(A) CAR(A)
#define POP(A) CDR(A)

using string_t = std::basic_string<char_t>;

const char_t* dotnetlib_path = nullptr;
const auto loadAssemblyDelegate = STR("ClrFacade.ClrFacade+LoadFromDelegate, ClrFacade");
void* create_instance_fn_ptr = nullptr;
void* load_from_fn_ptr = nullptr;
void* call_static_method_fn_ptr = nullptr;
void* call_instance_method_fn_ptr = nullptr;
void* call_free_object_method_ptr = nullptr;
void* get_object_direct_fn_ptr = nullptr;
void* get_full_type_name_fn_ptr = nullptr;
void* create_sexp_wrapper_fn_ptr = nullptr;

//Definition of Delegates
typedef int (CORECLR_DELEGATE_CALLTYPE* CallStaticMethodDelegate)(const char*, const char*, RSharpGenericValue** objects, int num_objects, RSharpGenericValue* returnValue);
typedef int (CORECLR_DELEGATE_CALLTYPE* CallInstanceMethodDelegate)(RSharpGenericValue** instance, const char* mname, RSharpGenericValue** objects, int num_objects, RSharpGenericValue* returnValue);
typedef void (CORECLR_DELEGATE_CALLTYPE* FreeObjectDelegate)(intptr_t instance);
typedef intptr_t(CORECLR_DELEGATE_CALLTYPE* CallFullTypeNameDelegate)(RSharpGenericValue** instance);
typedef int (CORECLR_DELEGATE_CALLTYPE* GetObjectDirectDelegate)(RSharpGenericValue* returnValue);
typedef int (CORECLR_DELEGATE_CALLTYPE* CreateSEXPWrapperDelegate)(intptr_t pointer, RSharpGenericValue* returnValue);
typedef int (CORECLR_DELEGATE_CALLTYPE* CreateInstanceDelegate)(const char*, RSharpGenericValue** objects, int num_objects, RSharpGenericValue* returnValue);
typedef void (CORECLR_DELEGATE_CALLTYPE* LoadFromDelegate)(const char*);


void freeObject(RSharpGenericValue* instance);

/////////////////////////////////////////
// Initialization and disposal of the CLR
/////////////////////////////////////////
void rSharp_create_domain(char ** libPath)
{
	char_t* wideStringPath = MergeLibPath(libPath, "/RSharp.runtimeconfig.json");
	dotnetlib_path = MergeLibPath(libPath, "/ClrFacade.dll");

	// if already loaded in this process, do not load again
	if (load_assembly_and_get_function_pointer != nullptr)
		return;

	// STEP 1: Load HostFxr and get exported hosting functions
	if (!load_hostfxr())
	{
		assert(false && "Failure: load_hostfxr()");
		return;
	}

	// STEP 2: Initialize and start the .NET Core runtime
	load_assembly_and_get_function_pointer = nullptr;
	load_assembly_and_get_function_pointer = get_dotnet_load_assembly(wideStringPath);
	assert(load_assembly_and_get_function_pointer != nullptr && "Failure: get_dotnet_load_assembly()");

	delete[] wideStringPath;
}

char_t* MergeLibPath(char** libPath, char* additionalPath)
{
	size_t libPathLen = strlen(*libPath);
	size_t additionalPathLen = strlen(additionalPath);

	char* combinedPath = new char[libPathLen + additionalPathLen + 1];

	strcpy(combinedPath, *libPath);
	strcat(combinedPath, additionalPath);

	size_t length = 0;
	mbstowcs_s(&length, nullptr, 0, combinedPath, 0);
	char_t* wideStringPath = new char_t[length + 1];
	mbstowcs_s(nullptr, wideStringPath, length + 1, combinedPath, length);

	delete[] combinedPath;
	return wideStringPath;
}

void rSharp_shutdown_clr()
{
	ms_rSharp_cleanup();
}

void ms_rSharp_cleanup()
{
	close_fptr(cxt);
}

/////////////////////////////////////////
// Helper Functions
/////////////////////////////////////////

static void rsharp_object_finalizer(SEXP clrSexp) {
	RsharpObjectHandle* clroh_ptr;

	if (TYPEOF(clrSexp) == EXTPTRSXP) {
		RSharpGenericValue* objptr;
		clroh_ptr = static_cast<RsharpObjectHandle*> (R_ExternalPtrAddr(clrSexp));
		objptr = clroh_ptr->objptr;
		freeObject(objptr);
		delete objptr;
	}
}

/////////////////////////////////////////
// Function used to load and activate .NET Core
/////////////////////////////////////////
namespace {
	// Forward declarations
	void* load_library(const char_t*);
	void* get_export(void*, const char*);

	#ifdef WINDOWS
	void *load_library(const char_t *path)
	{
		HMODULE h = ::LoadLibraryW(path);
		assert(h != nullptr);
		return (void*)h;
	}
	void *get_export(void *h, const char *name)
	{
		void *f = ::GetProcAddress((HMODULE)h, name);
		assert(f != nullptr);
		return f;
	}
#else
	void *load_library(const char_t *path)
	{
		void *h = dlopen(path, RTLD_LAZY | RTLD_LOCAL);
		assert(h != nullptr);
		return h;
	}
	void *get_export(void *h, const char *name)
	{
		void *f = dlsym(h, name);
		assert(f != nullptr);
		return f;
	}
#endif

	// <SnippetLoadHostFxr>
   // Using the nethost library, discover the location of hostfxr and get exports
	bool load_hostfxr()
	{
		// Pre-allocate a large buffer for the path to hostfxr
		char_t buffer[MAX_PATH];
		size_t buffer_size = sizeof(buffer) / sizeof(char_t);
		int rc = get_hostfxr_path(buffer, &buffer_size, nullptr);
		if (rc != 0)
			return false;

		// Load hostfxr and get desired exports
		void* lib = load_library(buffer);

		init_for_config_fptr = (hostfxr_initialize_for_runtime_config_fn)get_export(lib, "hostfxr_initialize_for_runtime_config");
		get_delegate_fptr = (hostfxr_get_runtime_delegate_fn)get_export(lib, "hostfxr_get_runtime_delegate");
		close_fptr = (hostfxr_close_fn)get_export(lib, "hostfxr_close");

		return (init_for_config_fptr && get_delegate_fptr && close_fptr);
	}
	// </SnippetLoadHostFxr>

	// <SnippetInitialize>
	// Load and initialize .NET Core and get desired function pointer for scenario
	load_assembly_and_get_function_pointer_fn get_dotnet_load_assembly(const char_t* config_path)
	{
		// Load .NET Core
		void* load_assembly_and_get_function_pointer = nullptr;
		cxt = nullptr;
		int rc = init_for_config_fptr(config_path, nullptr, &cxt);
		if (rc != 0 || cxt == nullptr)
		{
			std::cerr << "Init failed: " << std::hex << std::showbase << rc << std::endl;
			close_fptr(cxt);
			return nullptr;
		}

		// Get the load assembly function pointer
		rc = get_delegate_fptr(
			cxt,
			hdt_load_assembly_and_get_function_pointer,
			&load_assembly_and_get_function_pointer);
		if (rc != 0 || load_assembly_and_get_function_pointer == nullptr)
			std::cerr << "Get delegate failed: " << std::hex << std::showbase << rc << std::endl;

		close_fptr(cxt);
		return (load_assembly_and_get_function_pointer_fn)load_assembly_and_get_function_pointer;
	}
	// </SnippetInitialize>
}

/////////////////////////////////////////
// Functions to initialize the delegates
/////////////////////////////////////////

void initializeCreateInstance()
{
	const char_t* dotnet_type = STR("ClrFacade.ClrFacade, ClrFacade");
	auto functionDelegate = STR("ClrFacade.ClrFacade+CreateInstanceDelegate, ClrFacade");

	int rc_1 = load_assembly_and_get_function_pointer(
		dotnetlib_path,
		dotnet_type,
		STR("CreateInstance"),
		functionDelegate,//delegate_type_name
		nullptr,
		&create_instance_fn_ptr);

	assert(rc_1 == 0 && create_instance_fn_ptr != nullptr && "Failure: CreateInstance()");
}

void initializeLoadAssembly()
{
	const char_t* dotnet_type = STR("ClrFacade.ClrFacade, ClrFacade");
	auto functionDelegate = STR("ClrFacade.ClrFacade+LoadFromDelegate, ClrFacade");

	int rc_1 = load_assembly_and_get_function_pointer(
		dotnetlib_path,
		dotnet_type,
		STR("LoadFrom"),
		loadAssemblyDelegate,//delegate_type_name
		nullptr,
		&load_from_fn_ptr);

	assert(rc_1 == 0 && load_from_fn_ptr != nullptr && "Failure: LoadFrom()");
}

void initializeGetFullTypeNameFunction()
{
	const char_t* dotnet_type = STR("ClrFacade.ClrFacade, ClrFacade");
	auto functionDelegate = STR("ClrFacade.ClrFacade+GetObjectTypeNameDelegate, ClrFacade");

	int rc_1 = load_assembly_and_get_function_pointer(
		dotnetlib_path,
		dotnet_type,
		STR("GetObjectTypeName"),
		functionDelegate,//delegate_type_name
		nullptr,
		&get_full_type_name_fn_ptr);

	assert(rc_1 == 0 && get_full_type_name_fn_ptr != nullptr && "Failure: GetObjectTypeName()");
}

void initializeGetObjectDirectFunction()
{
	const char_t* dotnet_type = STR("ClrFacade.ClrFacade, ClrFacade");
	auto functionDelegate = STR("ClrFacade.ClrFacade+CurrentObjectDelegate, ClrFacade");

	int rc_1 = load_assembly_and_get_function_pointer(
		dotnetlib_path,
		dotnet_type,
		STR("CurrentObject"),
		functionDelegate,//delegate_type_name
		nullptr,
		&get_object_direct_fn_ptr);

	assert(rc_1 == 0 && get_object_direct_fn_ptr != nullptr && "Failure: get_CurrentObject()");
}

void initializeCreateSEXPFunction()
{
	const char_t* dotnet_type = STR("ClrFacade.ClrFacade, ClrFacade");
	auto functionDelegate = STR("ClrFacade.ClrFacade+CreateSexpWrapperDelegate, ClrFacade");

	int rc_1 = load_assembly_and_get_function_pointer(
		dotnetlib_path,
		dotnet_type,
		STR("CreateSexpWrapperLong"),
		functionDelegate,//delegate_type_name
		nullptr,
		&create_sexp_wrapper_fn_ptr);

	assert(rc_1 == 0 && create_sexp_wrapper_fn_ptr != nullptr && "Failure: CreateSexpWrapper()");

}

void initializeCallInstanceFunction()
{
	const char_t* dotnet_type = STR("ClrFacade.ClrFacade, ClrFacade");
	auto functionDelegate = STR("ClrFacade.ClrFacade+CallInstanceMethodDelegate, ClrFacade");

	int rc_1 = load_assembly_and_get_function_pointer(
		dotnetlib_path,
		dotnet_type,
		STR("CallInstanceMethod"),
		functionDelegate,//delegate_type_name
		nullptr,
		&call_instance_method_fn_ptr);

	assert(rc_1 == 0 && call_instance_method_fn_ptr != nullptr && "Failure: CallStatic()");
}

void initializeFreeObjectFunction()
{
	const char_t* dotnet_type = STR("ClrFacade.ClrFacade, ClrFacade");
	auto functionDelegate = STR("ClrFacade.ClrFacade+FreeObjectDelegate, ClrFacade");

	int rc_1 = load_assembly_and_get_function_pointer(
		dotnetlib_path,
		dotnet_type,
		STR("FreeObject"),
		functionDelegate,//delegate_type_name
		nullptr,
		&call_free_object_method_ptr);

	assert(rc_1 == 0 && call_free_object_method_ptr != nullptr && "Failure: FreeObject()");

}

void initializeCallStaticFunction()
{
	const char_t* dotnet_type = STR("ClrFacade.ClrFacade, ClrFacade");
	auto functionDelegate = STR("ClrFacade.ClrFacade+CallStaticMethodDelegate, ClrFacade");

	int rc_1 = load_assembly_and_get_function_pointer(
		dotnetlib_path,
		dotnet_type,
		STR("CallStaticMethod"),
		functionDelegate,//delegate_type_name
		nullptr,
		&call_static_method_fn_ptr);

	assert(rc_1 == 0 && call_static_method_fn_ptr != nullptr && "Failure: CallStatic()");
}


/////////////////////////////////////////
// Functions with R specific constructs, namely SEXPs
/////////////////////////////////////////
SEXP make_int_sexp(int n, int* values) {
	SEXP result;
	long i = 0;
	int* int_ptr;
	PROTECT(result = NEW_INTEGER(n));
	int_ptr = INTEGER_POINTER(result);
	for (i = 0; i < n; i++) {
		int_ptr[i] = values[i];
	}
	UNPROTECT(1);
	return result;
}

SEXP make_numeric_sexp(int n, double* values) {
	SEXP result;
	long i = 0;
	double* dbl_ptr;
	PROTECT(result = NEW_NUMERIC(n));
	dbl_ptr = NUMERIC_POINTER(result);
	for (i = 0; i < n; i++) {
		dbl_ptr[i] = values[i];
	}
	UNPROTECT(1);
	return result;
}

SEXP make_char_sexp(int n, char** values) {
	SEXP result;
	long i = 0;
	PROTECT(result = NEW_CHARACTER(n));
	for (i = 0; i < n; i++) {
		SET_STRING_ELT(result, i, mkChar((const char*)values[i]));
	}
	UNPROTECT(1);
	return result;
}

SEXP make_char_sexp_one(char* values) {
	return make_char_sexp(1, &values);
}

SEXP make_class_from_numeric(int n, double* values, int numClasses, char** classnames) {
	SEXP result;
	result = make_numeric_sexp(n, values);
	PROTECT(result);
	setAttrib(result, R_ClassSymbol, make_char_sexp(numClasses, classnames));
	UNPROTECT(1);
	return result;
}

SEXP make_bool_sexp(int n, bool* values) {
	SEXP result;
	long i = 0;
	int* intPtr;
	PROTECT(result = NEW_LOGICAL(n));
	intPtr = LOGICAL_POINTER(result);
	for (i = 0; i < n; i++) {
		intPtr[i] =
			// found many tests in the mono codebase such as below. Trying by mimicry then.
			// 		if (*(MonoBoolean *) mono_object_unbox(res)) {
			values[i]; // See http://r2clr.codeplex.com/workitem/34;
	}
	UNPROTECT(1);
	return result;
}

SEXP make_uchar_sexp(int n, unsigned char* values) {
	SEXP result;
	long i = 0;
	Rbyte* bPtr;
	PROTECT(result = NEW_RAW(n));
	bPtr = RAW_POINTER(result);
	for (i = 0; i < n; i++) {
		bPtr[i] = values[i];
	}
	UNPROTECT(1);
	return result;
}

//ToDo: to remove when we use it and replace with just a call to mkString()
SEXP make_char_single_sexp(const char* str) {
	return mkString(str);
}

bool isObjectArray(RSharpGenericValue** parameterArray, int i)
{
	return parameterArray[i]->type == RSharpValueType::OBJECT_ARRAY;
}

void free_params_array(RSharpGenericValue** parameterArray, int size)
{
	for (int i = 0; i < size; i++)
	{
		if (isObjectArray(parameterArray, i))
			free_params_array(reinterpret_cast<RSharpGenericValue**>(parameterArray[i]->value), parameterArray[i]->size);
		
		free(parameterArray[i]);
	}
	delete[] parameterArray;
}

RSharpGenericValue** sexp_to_parameters(SEXP args)
{
	int i;
	int nargs = Rf_length(args);
	int lengthArg = 0;
	SEXP el;
	const char* name;

	if (nargs == 0) {
		return NULL;
	}

	auto mparams = new RSharpGenericValue * [nargs];

	for (i = 0; args != R_NilValue; i++, args = CDR(args)) {
		name = isNull(TAG(args)) ? "" : CHAR(PRINTNAME(TAG(args)));
		el = CAR(args);

		mparams[i] = new RSharpGenericValue(ConvertToRSharpGenericValue(el));
	}
	return mparams;
}

//##################################################

SEXP r_get_null_reference() {
	return R_MakeExternalPtr(0, R_NilValue, R_NilValue);
}

SEXP r_show_args(SEXP args)
{
	const char* name;
	int i, j, nclass;
	SEXP el, names, klass;
	int nargs, nnames;
	args = CDR(args); /* skip 'name' */

	nargs = Rf_length(args);
	for (i = 0; i < nargs; i++, args = CDR(args)) {
		name =
			isNull(TAG(args)) ? "<unnamed>" : CHAR(PRINTNAME(TAG(args)));
		el = CAR(args);
		Rprintf("[%d] '%s' R type %s, SEXPTYPE=%d\n", i + 1, name, type2char(TYPEOF(el)), TYPEOF(el));
		Rprintf("[%d] '%s' length %d\n", i + 1, name, LENGTH(el));
		names = getAttrib(el, R_NamesSymbol);
		nnames = Rf_length(names);
		Rprintf("[%d] names of length %d\n", i + 1, nnames);
		klass = getAttrib(el, R_ClassSymbol);
		nclass = length(klass);
		for (j = 0; j < nclass; j++) {
			Rprintf("[%d] class '%s'\n", i + 1, CHAR(STRING_ELT(klass, j)));
		}
	}
	return(R_NilValue);
}

SEXP r_get_sexp_type(SEXP par) {
	SEXP p = par, e;
	int typecode;
	p = CDR(p); e = CAR(p);
	typecode = TYPEOF(e);
	return make_int_sexp(1, &typecode);
}

/////////////////////////////////////////
// Calling ClrFacade methods
/////////////////////////////////////////

void rSharp_load_assembly(char** filename) {
	if (load_from_fn_ptr == nullptr)
		initializeLoadAssembly();

	auto load_from = reinterpret_cast<LoadFromDelegate>(load_from_fn_ptr);
	load_from(*filename);
}

SEXP r_create_clr_object(SEXP p) {
	SEXP methodParams;
	RSharpGenericValue return_value;
	char* ns_qualified_typename = NULL;
	p = CDR(p); /* skip the first parameter: function name*/
	get_FullTypeName(p, &ns_qualified_typename); p = CDR(p);
	methodParams = p;


	//if the function pointer has not been initialized, initialize it
	if (create_instance_fn_ptr == nullptr)
		initializeCreateInstance();
	auto create_instance = reinterpret_cast<CreateInstanceDelegate>(create_instance_fn_ptr);

	RSharpGenericValue** params = sexp_to_parameters(methodParams);
	R_len_t num_objects = Rf_length(methodParams);

	create_instance(ns_qualified_typename, params, num_objects, &return_value);

	free_params_array(params, num_objects);
	return ConvertToSEXP(return_value);
}

RSharpGenericValue callInstance(RSharpGenericValue** instance, const char* mnam, char* ns_qualified_typename, RSharpGenericValue** params, const R_len_t numberOfObjects)
{
	RSharpGenericValue return_value;

	if (call_instance_method_fn_ptr == nullptr)
		initializeCallInstanceFunction();

	const auto call_instance = reinterpret_cast<CallInstanceMethodDelegate>(call_instance_method_fn_ptr);

	auto result = call_instance(instance, mnam, params, numberOfObjects, &return_value);

	if (result < 0)
		throw std::runtime_error("Error calling instance method");

	return return_value;
}

void freeObject(RSharpGenericValue* instance)
{
	if (call_free_object_method_ptr == nullptr)
		initializeFreeObjectFunction();

	const auto free_object = reinterpret_cast<FreeObjectDelegate>(call_free_object_method_ptr);
	free_object(reinterpret_cast<intptr_t>(instance));
}

RSharpGenericValue callStatic(const char* mnam, char* ns_qualified_typename, RSharpGenericValue** params, const R_len_t numberOfObjects)
{
	RSharpGenericValue return_value;
	if (call_static_method_fn_ptr == nullptr)
		initializeCallStaticFunction();

	const auto call_static = reinterpret_cast<CallStaticMethodDelegate>(call_static_method_fn_ptr);

	auto result = call_static(ns_qualified_typename, mnam, params, numberOfObjects, &return_value);

	if (result < 0)
		throw std::runtime_error("Error calling static method");

	return return_value;
}

RSharpGenericValue rclr_convert_element_rdotnet(SEXP p)
{
	RSharpGenericValue return_value;

	if (create_sexp_wrapper_fn_ptr == nullptr)
		initializeCreateSEXPFunction();

	const auto call_static = reinterpret_cast<CreateSEXPWrapperDelegate>(create_sexp_wrapper_fn_ptr);

	auto result = call_static(reinterpret_cast<intptr_t>(p), &return_value);

	return return_value;
}

SEXP r_get_object_direct() {
	RSharpGenericValue return_value;
	if (get_object_direct_fn_ptr == nullptr)
		initializeGetObjectDirectFunction();

	const auto call_static = reinterpret_cast<GetObjectDirectDelegate>(get_object_direct_fn_ptr);

	auto result = call_static(&return_value);

	if (result < 0)
		throw std::runtime_error("Error calling get object direct");

	return ConvertToSEXP(return_value);
}

const char* get_type_full_name(RSharpGenericValue** genericValue) {
	char* ns_qualified_typename = NULL;

	if (get_full_type_name_fn_ptr == nullptr)
		initializeGetFullTypeNameFunction();

	const auto call_static = reinterpret_cast<CallFullTypeNameDelegate>(get_full_type_name_fn_ptr);

	auto hr = call_static(genericValue);
	return (char*)(hr);
}

RSharpGenericValue* get_RSharp_generic_value(SEXP clrObj);

SEXP r_get_typename_externalptr(SEXP p) {
	SEXP methodParams;
	const char* mnam;
	p = CDR(p); /* skip the first parameter: function name*/
	methodParams = CAR(p);
	SEXP el = CAR(methodParams);

	return make_char_single_sexp(get_type_full_name(reinterpret_cast<RSharpGenericValue**>(el)));
}



SEXP rsharp_object_to_SEXP(RSharpGenericValue& objptr) {
	RsharpObjectHandle* clroh_ptr;

	const auto returnPointer = new RSharpGenericValue(objptr);

	if (objptr.type == RSharpValueType::NULL_VALUE)
		return R_NilValue;

	clroh_ptr = static_cast<RsharpObjectHandle*>(malloc(sizeof(RsharpObjectHandle)));
	clroh_ptr->objptr = returnPointer;
	clroh_ptr->handle = 0;
	SEXP result = R_MakeExternalPtr(clroh_ptr, R_NilValue, R_NilValue);
	R_RegisterCFinalizerEx(result, rsharp_object_finalizer, (Rboolean)1/*TRUE*/);
	return result;
}

SEXP r_call_method(SEXP par)
{
	SEXP sExpressionParameterStack = par, instance, sExpressinParameter;
	const char* methodName = 0;


	sExpressinParameter = TOPOF(sExpressionParameterStack);
	auto functionName = CHAR(STRING_ELT(sExpressinParameter, 0));	// should be "r_call_method"
	sExpressionParameterStack = POP(sExpressionParameterStack);

	instance = TOPOF(TOPOF(sExpressionParameterStack));				// object instance is the second SEXP
	sExpressionParameterStack = POP(sExpressionParameterStack);

	sExpressinParameter = TOPOF(sExpressionParameterStack);			// instance method name is the third SEXP
	methodName = CHAR(STRING_ELT(sExpressinParameter, 0));
	sExpressionParameterStack = POP(sExpressionParameterStack);

	RSharpGenericValue** params = sexp_to_parameters(sExpressionParameterStack);

	const R_len_t number_of_objects = Rf_length(sExpressionParameterStack);
	auto return_value = callInstance(reinterpret_cast<RSharpGenericValue**>(instance), methodName, "ClrFacade.ClrFacade,ClrFacade", params, number_of_objects);
	free_params_array(params, number_of_objects);
	return ConvertToSEXP(return_value);
}

SEXP r_call_static_method(SEXP p) {
	SEXP e, methodParams;
	const char* mnam;
	char* ns_qualified_typename = NULL; // My.Namespace.MyClass,MyAssemblyName

	p = CDR(p); /* skip the first parameter: function name*/
	get_FullTypeName(p, &ns_qualified_typename); p = CDR(p);
	e = CAR(p);
	mnam = CHAR(STRING_ELT(e, 0));
	p = CDR(p); // get the method name.
	methodParams = p;

	RSharpGenericValue** params = sexp_to_parameters(methodParams);
	if (TYPEOF(e) != STRSXP || LENGTH(e) != 1)
	{
		free(ns_qualified_typename);
		error_return("r_call_static_method: invalid method name");
	}

	const R_len_t numberOfObjects = Rf_length(methodParams);
	try {
		//if the function pointer has not been initialized, initialize it
		auto return_value = callStatic(mnam, ns_qualified_typename, params, numberOfObjects);
		free(ns_qualified_typename);
		free_params_array(params, numberOfObjects);
		return ConvertToSEXP(return_value);
	}
	catch (const std::exception& ex) {
		free(ns_qualified_typename);
		error_return(ex.what())
	}
}


template <typename T>
std::vector<T> GetArray(const RSharpGenericValue& value) {
	std::vector<T> result;

	switch (value.type)
	{
	case RSharpValueType::INT:
	case RSharpValueType::FLOAT:
	case RSharpValueType::DOUBLE:
	case RSharpValueType::BOOL: {
		result.reserve(1);
		result.push_back(static_cast<T>(*reinterpret_cast<const T*>(value.value)));
		break;
	}

	case RSharpValueType::STRING: {
		const T strValue = *reinterpret_cast<const T*>(value.value);
		result.push_back(strValue);
		break;
	}
	case RSharpValueType::INT_ARRAY: {
		const T* ptr = reinterpret_cast<const T*>(value.value);
		result.reserve(value.size);  // Reserve space to avoid reallocation
		std::copy(ptr, ptr + value.size, std::back_inserter(result));
		break;
	}
	case RSharpValueType::FLOAT_ARRAY: {
		const T* ptr = reinterpret_cast<const T*>(value.value);
		result.reserve(value.size);
		std::copy(ptr, ptr + value.size, std::back_inserter(result));
		break;
	}
	case RSharpValueType::DOUBLE_ARRAY: {
		const T* ptr = reinterpret_cast<const T*>(value.value);
		result.reserve(value.size);
		std::copy(ptr, ptr + value.size, std::back_inserter(result));
		break;
	}
	case RSharpValueType::BOOL_ARRAY: {
		const T* ptr = reinterpret_cast<const T*>(value.value);
		result.reserve(value.size);
		std::copy(ptr, ptr + value.size, std::back_inserter(result));
		break;
	}
	case RSharpValueType::STRING_ARRAY: {
		const T* ptr = reinterpret_cast<const T*>(value.value);
		result.reserve(value.size);
		std::copy(ptr, ptr + value.size, std::back_inserter(result));
		break;
	}
	case RSharpValueType::OBJECT: {
		// Implement conversion for your custom object type
		// ...

		// Example: Returning an empty vector for unsupported type
		break;
	}
								// Handle other value types as needed
	default:
		break;
	}

	return result;
}

SEXP PackFloatIntoSEXP(float value) {
	SEXP result = PROTECT(Rf_allocVector(REALSXP, 1));
	REAL(result)[0] = static_cast<double>(value);  // Set the first element of the numeric vector
	UNPROTECT(1);
	return result;
}

SEXP PackDoubleIntoSEXP(double value) {
	SEXP result = PROTECT(Rf_allocVector(REALSXP, 1));
	REAL(result)[0] = value;  // Set the first element of the numeric vector
	UNPROTECT(1);
	return result;
}


SEXP ConvertToSEXP(RSharpGenericValue& value) {
	switch (value.type)
	{
	case RSharpValueType::NULL_VALUE: {
		return R_NilValue;
	}
	case RSharpValueType::INTPTR: {
		return reinterpret_cast<SEXP>(value.value);
	}
	case RSharpValueType::INT: {
		int intValue = *reinterpret_cast<const int*>(value.value);
		return make_int_sexp(1, &intValue);
	}
	case RSharpValueType::FLOAT: {
		float floatValue = *reinterpret_cast<const float*>(value.value);
		return PackFloatIntoSEXP(floatValue);
	}
	case RSharpValueType::DOUBLE: {
		double doubleValue = *reinterpret_cast<const double*>(value.value);
		return PackDoubleIntoSEXP(doubleValue);
	}
	case RSharpValueType::BOOL: {
		bool boolValue = *reinterpret_cast<const bool*>(value.value);
		return Rf_ScalarLogical(boolValue);
	}
	case RSharpValueType::STRING: {
		const char* stringValue = (char*)value.value;
		return make_char_single_sexp(stringValue);
	}
								/*case RSharpValueType::INT_ARRAY: {
									std::vector<int> array = GetArray<int>(value);
									int length = static_cast<int>(array.size());
									SEXP result = PROTECT(Rf_allocVector(INTSXP, length));
									std::copy(array.begin(), array.end(), INTEGER(result));
									UNPROTECT(1);
									return result;
								}
								case RSharpValueType::FLOAT_ARRAY: {
									std::vector<float> array = GetArray<float>(value);
									int length = static_cast<int>(array.size());
									SEXP result = PROTECT(Rf_allocVector(REALSXP, length));
									std::copy(array.begin(), array.end(), REAL(result));
									UNPROTECT(1);
									return result;
								}
								case RSharpValueType::DOUBLE_ARRAY: {
									std::vector<double> array = GetArray<double>(value);
									int length = static_cast<int>(array.size());
									SEXP result = PROTECT(Rf_allocVector(REALSXP, length));
									std::copy(array.begin(), array.end(), REAL(result));
									UNPROTECT(1);
									return result;
								}
								case RSharpValueType::BOOL_ARRAY: {
									std::vector<bool> array = GetArray<bool>(value);
									int length = static_cast<int>(array.size());
									SEXP result = PROTECT(Rf_allocVector(LGLSXP, length));
									std::copy(array.begin(), array.end(), LOGICAL(result));
									UNPROTECT(1);
									return result;
								}
								case RSharpValueType::STRING_ARRAY: {
									std::vector<const char*> array = GetArray<const char*>(value);
									int length = static_cast<int>(array.size());
									SEXP result = PROTECT(Rf_allocVector(STRSXP, length));
									for (int i = 0; i < length; ++i) {
										SET_STRING_ELT(result, i, Rf_mkChar(array[i]));
									}
									UNPROTECT(1);
									return result;
								}*/
	case RSharpValueType::OBJECT: {
		return rsharp_object_to_SEXP(value);

	default:
		return R_NilValue; // Returning NULL for unsupported types
	}
	}
}

void get_FullTypeName(SEXP p, char** tname) {
	SEXP e;
	e = CAR(p); /* second is the namespace */
	if (TYPEOF(e) != STRSXP || LENGTH(e) != 1)
		error("get_FullTypeName: cannot parse type name: need a STRSXP of length 1");
	(*tname) = STR_DUP(CHAR(STRING_ELT(e, 0))); // is all this really necessary? I recall trouble if using less, but this still looks over the top.
}

RSHARP_BOOL r_has_class(SEXP s, const char* classname) {
	SEXP klasses;
	R_xlen_t j;
	int n_classes;
	klasses = getAttrib(s, R_ClassSymbol);
	n_classes = length(klasses);
	if (n_classes > 0) {
		for (j = 0; j < n_classes; j++)
			if (strcmp(CHAR(STRING_ELT(klasses, j)), classname) == 0)
				return TRUE_BOOL;
	}
	return FALSE_BOOL;
}

RSharpGenericValue* get_RSharp_generic_value(SEXP clrObj) {
	SEXP a, clrobjSlotName;
	SEXP s4classname = getAttrib(clrObj, R_ClassSymbol);
	if (strcmp(CHAR(STRING_ELT(s4classname, 0)), "cobjRef") == 0)
	{
		PROTECT(clrobjSlotName = NEW_CHARACTER(1));
		SET_STRING_ELT(clrobjSlotName, 0, mkChar("clrobj"));
		a = getAttrib(clrObj, clrobjSlotName);
		UNPROTECT(1);
		if (a != NULL && a != R_NilValue && TYPEOF(a) == EXTPTRSXP) {
			return GET_RSHARP_GENERIC_VALUE_FROM_EXTPTR(a);
		}
		else
			return NULL;
	}
	else
	{
		error("Incorrect type of S4 Object: Not of type 'cobjRef'");
		return NULL;
	}
}

/////////////////////////////////////////
// Functions without R specific constructs
/////////////////////////////////////////

RSharpGenericValue ConvertArrayToRSharpGenericValue(SEXP s)
{
	RSharpGenericValue result;
	result.type = RSharpValueType::OBJECT;
	result.value = 0;
	result.size = 0; // Default size for non-array types

	switch (TYPEOF(s)) {
	case INTSXP: {
		result.type = RSharpValueType::INT_ARRAY;
		result.value = reinterpret_cast<intptr_t>(INTEGER(s));
		result.size = LENGTH(s);
		break;
	}
	case REALSXP: {
		result.type = RSharpValueType::DOUBLE_ARRAY;
		result.value = reinterpret_cast<intptr_t>(REAL(s));
		result.size = LENGTH(s);
		break;
	}
	case STRSXP: {
		result.type = RSharpValueType::STRING_ARRAY;
		result.value = reinterpret_cast<intptr_t>(CHAR(STRING_ELT(s, 0)));
		result.size = LENGTH(s);
		break;
	}
	case LGLSXP: {
		result.type = RSharpValueType::BOOL_ARRAY;
		result.value = reinterpret_cast<intptr_t>(LOGICAL(s));
		result.size = LENGTH(s);
		break;
	}
	default:
		break;
	}

	return result;
}


RSharpGenericValue ConvertToRSharpGenericValue(SEXP s)
{
	RSharpGenericValue result;

	int typeof = TYPEOF(s);
	switch (typeof) {
	case S4SXP:
		return *get_RSharp_generic_value(s);
	case VECSXP:
		result.type = RSharpValueType::OBJECT_ARRAY;
		result.size = LENGTH(s);
		auto sharp_generic_value = new RSharpGenericValue* [result.size];
		result.value = reinterpret_cast<intptr_t>(sharp_generic_value);
		for(int i = 0 ; i < result.size; i++)
		{
			sharp_generic_value[i] = new RSharpGenericValue(ConvertToRSharpGenericValue(VECTOR_ELT(s, i)));
		}
		return result;
	}

	if (use_rdotnet)
	{
		return rclr_convert_element_rdotnet(s);
	}

	switch (typeof) {
	case INTSXP: {
		result.type = RSharpValueType::INT;
		result.value = reinterpret_cast<intptr_t>(INTEGER(s));
		break;
	}
	case REALSXP: {
		result.type = RSharpValueType::DOUBLE;
		result.value = reinterpret_cast<intptr_t>(REAL(s));
		break;
	}
	case LGLSXP: {
		result.type = RSharpValueType::BOOL;
		result.value = reinterpret_cast<intptr_t>(LOGICAL(s));
		break;
	}
	case STRSXP: {
		result.type = RSharpValueType::STRING;
		result.value = reinterpret_cast<intptr_t>(CHAR(STRING_ELT(s, 0)));
		break;
	}
	default:
		result = *get_RSharp_generic_value(s);
		break;
	}

	return result;
}