
// Module Name
%module(docstring="The RoadRunner SBML Simulation Engine,
(c) 2009-2013 Herbert Sauro, Andy Somogyi and Totte Karlsson", "
        ""threads"=1) roadrunner

// ************************************************************
// Module Includes
// ************************************************************

// These are copied directly to the .cxx file and are not parsed
// by SWIG.  Include include files or definitions that are required
// for the module to build correctly.

%{
    #define SWIG_FILE_WITH_INIT
    #include <numpy/arrayobject.h>
    #include <lsMatrix.h>
    #include <lsLibla.h>
    #include <lsLA.h>
    #include <lsLUResult.h>
    #include <lsUtils.h>
    #include <rrCompiler.h>
    #include <rrModelGenerator.h>
    #include <rrExecutableModel.h>
    #include <rrRoadRunnerData.h>
    #include <rrRoadRunnerOptions.h>
    #include <rrRoadRunner.h>
    #include <rrLogger.h>
    #include <rrPluginManager.h>
    #include <rrPlugin.h>
    #include <cstddef>
    #include <map>
    #include <rrVersionInfo.h>
    #include <rrException.h>
    #include <assert.h>
    using namespace rr;
%}

%naturalvar;

// C++ std::string handling
%include "std_string.i"

// C++ std::map handling
%include "std_map.i"

// C++ std::map handling
%include "std_vector.i"

//enables better handling of STL exceptions
%include "exception.i"

// correct mapping of unsigned integers
%include "rr_stdint.i"

// all the documentation goes here.
%include "rr_docstrings.i"


%template(IntVector) std::vector<int>;
%template(StringVector) std::vector<std::string>;


%apply std::vector<std::string> {vector<std::string>, vector<string>, std::vector<string> };

%template(SelectionRecordVector) std::vector<rr::SelectionRecord>;
%apply std::vector<rr::SelectionRecord> {std::vector<SelectionRecord>, std::vector<rr::SelectionRecord>, vector<SelectionRecord>};


%exception {
  try {
    $action
  } catch (const std::exception& e) {
    SWIG_exception(SWIG_RuntimeError, e.what());
  }
}

/**
 *  Convert from C --> Python
 *  copy data
 */
%typemap(out) ls::DoubleMatrix {

    int rows = ($1).numRows();
    int cols = ($1).numCols();
    int nd = 2;
    npy_intp dims[2] = {rows, cols};
    double *data = (double*)malloc(sizeof(double)*rows*cols);
    memcpy(data, ($1).getArray(), sizeof(double)*rows*cols);

    PyObject *pArray = PyArray_New(&PyArray_Type, nd, dims, NPY_DOUBLE, NULL, data, 0,
            NPY_CARRAY | NPY_OWNDATA, NULL);
    $result  = pArray;
}


/**
 * Convert from C --> Python
 * reference roadrunner owned data.
 */
%typemap(out) ls::DoubleMatrix* {

    int rows = ($1)->numRows();
    int cols = ($1)->numCols();
    int nd = 2;
    npy_intp dims[2] = {rows, cols};
    double *data = ($1)->getArray();

    PyObject *pArray = PyArray_New(&PyArray_Type, nd, dims, NPY_DOUBLE, NULL, data, 0,
            NPY_CARRAY, NULL);
    $result  = pArray;
}


/* Convert from C --> Python */
%typemap(out) const rr::RoadRunnerData* {

    /* int rows = 0; */
    /* int cols = 0; */
    /* int nd = 2; */
    /* double *data = 0; */

    /* if ($1) */
    /* { */
    /*     ls::DoubleMatrix& mat = const_cast<ls::DoubleMatrix&>(($1)->getData()); */
    /*     rows = mat.numRows(); */
    /*     cols = mat.numCols(); */
    /*     data = mat.getArray(); */
    /* } */

    /* npy_intp dims[2] = {rows, cols}; */

    /* PyObject *pArray = PyArray_New(&PyArray_Type, nd, dims, NPY_DOUBLE, NULL, data, 0, */
    /*         NPY_CARRAY, NULL); */


    $result  = RoadRunnerData_to_py($1);
}

%apply const rr::RoadRunnerData* {rr::RoadRunnerData*, RoadRunnerData*, const RoadRunnerData* };

/* Convert from C --> Python */
%typemap(out) std::vector<double> {

    int len = $1.size();
    npy_intp dims[1] = {len};

    PyObject *array = PyArray_SimpleNew(1, dims, NPY_DOUBLE);

    if (!array) {
        // TODO error handling.
        return 0;
    }

    double *data = (double*)PyArray_DATA((PyArrayObject*)array);

    std::vector<double>& vec = $1;

    memcpy(data, &vec[0], sizeof(double)*len);

    $result  = array;
}


/*
%typemap(out) std::vector<std::string> {

    int len = $1.size();

    PyObject* pyList = PyList_New(len);

    for(int i = 0; i < len; i++)
    {
        const std::string& str  = $1.at(i);
        PyObject* pyStr = PyString_FromString(str.c_str());
        PyList_SET_ITEM(pyList, i, pyStr);
    }

    $result = pyList;
}
*/

//%apply std::vector<std::string> {vector<std::string>, vector<string>, std::vector<string> };






%include "numpy.i"


%init %{
import_array();
%}

%{
    static std::string version_info() {
        return string(RR_VERSION) + string(", compiled with ") + string(RR_COMPILER)
            + " on date " + string( __DATE__ ) + ", " + string(__TIME__);
    }
%}

std::string version_info();

%{

typedef int (rr::ExecutableModel::*getValuesPtr)(int, int const*, double*);
typedef string (ExecutableModel::*getNamePtr)(int);
typedef int (ExecutableModel::*getNumPtr)();


static PyObject* _ExecutableModel_getValues(rr::ExecutableModel *self, getValuesPtr func,
                                            getNumPtr numPtr, int len, int const *indx) {
    if (len <= 0) {
        len = (self->*numPtr)();
        indx = 0;
    }

    npy_intp dims[1] = {len};
    PyObject *array = PyArray_SimpleNew(1, dims, NPY_DOUBLE);

    if (!array) {
        // TODO error handling.
        return 0;
    }

    double *data = (double*)PyArray_DATA((PyArrayObject*)array);

    (self->*func)(len, indx, data);

    // TODO check result
    return array;
}

static std::string strvec_to_pystring(const std::vector<std::string>& strvec) {
    std::stringstream s;
    s << "[";

    for (int i = 0; i < strvec.size(); ++i) {
        s << "'" << strvec[i] << "'";
        if (i + 1 < strvec.size()) {
            s << ",";
        }
    }

    s << "]";

    return s.str();
}



// we can write a single function to pick the string lists out
// of the model instead of duplicating it 6 times with
// fun ptrs.

// make this static here, hide our implementation...
static PyObject* _ExecutableModel_getIds(ExecutableModel *model,
        getNumPtr numFunc, getNamePtr nameFunc)
{
    const int num = (model->*numFunc)();

    PyObject* pyList = PyList_New(num);

    for(int i = 0; i < num; i++)
    {
        const std::string& name  = (model->*nameFunc)(i);
        PyObject* pyStr = PyString_FromString(name.c_str());
        PyList_SET_ITEM(pyList, i, pyStr);
    }

    return pyList;
}

/**
 * create a numpy structured array with the column names set from
 * the column names of the RoadRunnerData object.
 */
static PyObject *RoadRunnerData_to_py(rr::RoadRunnerData* pData) {

    // a valid array descriptor:
    // In [87]: b = array(array([0,1,2,3]),
    //      dtype=[('r', 'f8'), ('g', 'f8'), ('b', 'f8'), ('a', 'f8')])

    if (pData->structuredResult) {

        const std::vector<std::string> &names = pData->getColumnNames();
        ls::DoubleMatrix& mat = const_cast<ls::DoubleMatrix&>(pData->getData());

        int rows = mat.numRows();
        int cols = mat.numCols();
        double* mData = mat.getArray();

        PyObject* list = PyList_New(names.size());

        for(int i = 0; i < names.size(); ++i)
            {
                PyObject *col = PyString_FromString(names[i].c_str());
                PyObject *type = PyString_FromString("f8");
                PyObject *tup = PyTuple_Pack(2, col, type);

                void PyList_SET_ITEM(list, i, tup);
            }

        PyArray_Descr* descr = 0;
        PyArray_DescrConverter(list, &descr);

        // done with list
        Py_CLEAR(list);

        npy_intp dims[] = {rows};

        // steals a reference to descr
        PyObject *result = PyArray_SimpleNewFromDescr(1, dims,  descr);

        if (result) {

            assert(PyArray_NBYTES(result) == rows*cols*sizeof(double) && "invalid array size");

            double* data = (double*)PyArray_BYTES(result);

            memcpy(data, mData, rows*cols*sizeof(double));
        }

        return result;
    }
    else {

        ls::DoubleMatrix& mat = const_cast<ls::DoubleMatrix&>(pData->getData());
        int rows = mat.numRows();
        int cols = mat.numCols();
        int nd = 2;

        npy_intp dims[2] = {rows, cols};
        double *data = (double*)malloc(sizeof(double)*rows*cols);
        memcpy(data, mat.getArray(), sizeof(double)*rows*cols);

        PyObject *pArray = PyArray_New(&PyArray_Type, nd, dims, NPY_DOUBLE, NULL, data, 0,
                                       NPY_CARRAY | NPY_OWNDATA, NULL);
        return pArray;
    }
};


%}


%apply (int DIM1, int* IN_ARRAY1) {(int len, int const *indx)};

%apply (int DIM1, double* IN_ARRAY1) {(int len, double const *values)};

// typemap for the set***Values methods
%apply (int DIM1, int* IN_ARRAY1) {(int leni, int const* indx)};
%apply (int DIM1, double* IN_ARRAY1) {(int lenv, const  double* values)};

#define LIB_EXTERN
#define RR_DECLSPEC
#define PUGIXML_CLASS



%warnfilter(509) rr::RoadRunner::setSelections;
%warnfilter(509) rr::RoadRunner::setSteadyStateSelections;

// Many of the RoadRunner methods will be ignored for the time being
// as currently we do not have a clean mapping to Python.


%ignore rr::RoadRunner::addCapabilities;
%ignore rr::RoadRunner::getFloatingSpeciesIds;
%ignore rr::RoadRunner::getRateOfChangeIds;
//%ignore rr::RoadRunner::getuCC;
%ignore rr::RoadRunner::addCapability;
%ignore rr::RoadRunner::getFloatingSpeciesInitialConcentrationByIndex;
%ignore rr::RoadRunner::getRatesOfChange;
//%ignore rr::RoadRunner::getuEE;
%ignore rr::RoadRunner::changeInitialConditions;
%ignore rr::RoadRunner::getFloatingSpeciesInitialConcentrations;
%ignore rr::RoadRunner::getRatesOfChangeEx;
%ignore rr::RoadRunner::initializeModel;
%ignore rr::RoadRunner::computeAndAssignConservationLaws;
%ignore rr::RoadRunner::getFloatingSpeciesInitialConditionIds;
%ignore rr::RoadRunner::getReactionIds;
//%ignore rr::RoadRunner::isModelLoaded;
//%ignore rr::RoadRunner::computeSteadyStateValue;
//%ignore rr::RoadRunner::getFullJacobian;
%ignore rr::RoadRunner::getReactionRate;
//%ignore rr::RoadRunner::loadSBML;
%ignore rr::RoadRunner::computeSteadyStateValues;
%ignore rr::RoadRunner::getFullReorderedJacobian;
%ignore rr::RoadRunner::getReactionRates;
//%ignore rr::RoadRunner::loadSBMLFromFile;
%ignore rr::RoadRunner::correctMaxStep;
//%ignore rr::RoadRunner::getFullyReorderedStoichiometryMatrix;
%ignore rr::RoadRunner::getReactionRatesEx;
%ignore rr::RoadRunner::loadSimulationSettings;
//%ignore rr::RoadRunner::createDefaultSelectionLists;
%ignore rr::RoadRunner::getGlobalParameterByIndex;
//%ignore rr::RoadRunner::getReducedJacobian;
//%ignore rr::RoadRunner::oneStep;
//%ignore rr::RoadRunner::createTimeCourseSelectionList;
%ignore rr::RoadRunner::getGlobalParameterIds;
//%ignore rr::RoadRunner::getReorderedStoichiometryMatrix;
//%ignore rr::RoadRunner::reset;
%ignore rr::RoadRunner::evalModel;
%ignore rr::RoadRunner::getGlobalParameterValues;
//%ignore rr::RoadRunner::getSBML;
%ignore rr::RoadRunner::setBoundarySpeciesByIndex;
%ignore rr::RoadRunner::getBoundarySpeciesAmountIds;
//%ignore rr::RoadRunner::getInfo;
//%ignore rr::RoadRunner::getScaledConcentrationControlCoefficientMatrix;
%ignore rr::RoadRunner::setBoundarySpeciesConcentrations;
%ignore rr::RoadRunner::getBoundarySpeciesByIndex;
//%ignore rr::RoadRunner::getInstanceCount;
//%ignore rr::RoadRunner::getScaledFloatingSpeciesElasticity;
%ignore rr::RoadRunner::setCapabilities;
%ignore rr::RoadRunner::getBoundarySpeciesConcentrations;
//%ignore rr::RoadRunner::getInstanceID;
//%ignore rr::RoadRunner::getScaledFluxControlCoefficientMatrix;
%ignore rr::RoadRunner::setCompartmentByIndex;
%ignore rr::RoadRunner::getBoundarySpeciesIds;
//%ignore rr::RoadRunner::getIntegrator;
//%ignore rr::RoadRunner::getScaledReorderedElasticityMatrix;
%ignore rr::RoadRunner::setCompiler;
//%ignore rr::RoadRunner::getCC;
//%ignore rr::RoadRunner::getL0Matrix;
//%ignore rr::RoadRunner::getSelectedValues;
%ignore rr::RoadRunner::setFloatingSpeciesByIndex;
//%ignore rr::RoadRunner::getCapabilitiesAsXML;
//%ignore rr::RoadRunner::getLinkMatrix;
//%ignore rr::RoadRunner::getSelectionList;
%ignore rr::RoadRunner::setFloatingSpeciesConcentrations;
%ignore rr::RoadRunner::getCapability;
%ignore rr::RoadRunner::getListOfCapabilities;
//%ignore rr::RoadRunner::getSimulationResult;
%ignore rr::RoadRunner::setFloatingSpeciesInitialConcentrationByIndex;
%ignore rr::RoadRunner::getCompartmentByIndex;
%ignore rr::RoadRunner::getListOfParameters;
//%ignore rr::RoadRunner::getSteadyStateSelection;
%ignore rr::RoadRunner::setFloatingSpeciesInitialConcentrations;
%ignore rr::RoadRunner::getCompartmentIds;
//%ignore rr::RoadRunner::getModel;
//%ignore rr::RoadRunner::getSteadyStateSelectionList;
%ignore rr::RoadRunner::setGlobalParameterByIndex;
//%ignore rr::RoadRunner::getCompiler;
//%ignore rr::RoadRunner::getModelGenerator;
//%ignore rr::RoadRunner::getStoichiometryMatrix;
%ignore rr::RoadRunner::setNumPoints;
//%ignore rr::RoadRunner::getConservationMatrix;
%ignore rr::RoadRunner::getModelName;
%ignore rr::RoadRunner::getTempFolder;
%ignore rr::RoadRunner::setParameterValue;
%ignore rr::RoadRunner::getConservedSumIds;
//%ignore rr::RoadRunner::getNrMatrix;
//%ignore rr::RoadRunner::getTimeCourseSelectionList;
%ignore rr::RoadRunner::setSimulationSettings;
%ignore rr::RoadRunner::getConservedSums;
%ignore rr::RoadRunner::getNumPoints;
%ignore rr::RoadRunner::getTimeEnd;
//%ignore rr::RoadRunner::setSteadyStateSelectionList;
//%ignore rr::RoadRunner::getCopyright;
%ignore rr::RoadRunner::getNumberOfBoundarySpecies;
%ignore rr::RoadRunner::getTimeStart;
%ignore rr::RoadRunner::setTempFileFolder;
//%ignore rr::RoadRunner::getDescription;
%ignore rr::RoadRunner::getNumberOfCompartments;
//%ignore rr::RoadRunner::getURL;
//%ignore rr::RoadRunner::setTimeCourseSelectionList;
//%ignore rr::RoadRunner::getEE;
%ignore rr::RoadRunner::getNumberOfDependentSpecies;
//%ignore rr::RoadRunner::getUnscaledConcentrationControlCoefficientMatrix;
%ignore rr::RoadRunner::setTimeEnd;
//%ignore rr::RoadRunner::getEigenvalueIds;
%ignore rr::RoadRunner::getNumberOfFloatingSpecies;
//%ignore rr::RoadRunner::getUnscaledElasticityMatrix;
%ignore rr::RoadRunner::setTimeStart;
//%ignore rr::RoadRunner::getEigenvalues;
%ignore rr::RoadRunner::getNumberOfGlobalParameters;
//%ignore rr::RoadRunner::getUnscaledFluxControlCoefficientMatrix;
//%ignore rr::RoadRunner::setValue;
%ignore rr::RoadRunner::getEigenvaluesCpx;
%ignore rr::RoadRunner::getNumberOfIndependentSpecies;
//%ignore rr::RoadRunner::getUnscaledSpeciesElasticity;
//%ignore rr::RoadRunner::simulate;
//%ignore rr::RoadRunner::getExtendedVersionInfo;
%ignore rr::RoadRunner::getNumberOfReactions;
%ignore rr::RoadRunner::getValue;
//%ignore rr::RoadRunner::steadyState;
%ignore rr::RoadRunner::getSelectionValue(const SelectionRecord&);
//%ignore rr::RoadRunner::this;
%ignore rr::RoadRunner::getFloatingSpeciesByIndex;
%ignore rr::RoadRunner::getParameterValue;
//%ignore rr::RoadRunner::getVersion;
%ignore rr::RoadRunner::unLoadModel;
%ignore rr::RoadRunner::getFloatingSpeciesConcentrations;
%ignore rr::RoadRunner::getRateOfChange;
//%ignore rr::RoadRunner::getlibSBMLVersion;
//%ignore rr::RoadRunner::writeSBML;
%ignore rr::RoadRunner::getSimulateOptions;
%ignore rr::RoadRunner::setSimulateOptions;
%ignore rr::RoadRunner::_getDuplicateSimulateOptions;


// rename these, the injected python code will take care of
// making these properties.
%rename (_getSelections) rr::RoadRunner::getSelections();
%rename (_setSelections) setSelections(const std::vector<rr::SelectionRecord>&);
%rename (_setSelections) setSelections(const std::vector<std::string>&);
%rename (_getModel) getModel();

%rename (_getSteadyStateSelections) rr::RoadRunner::getSteadyStateSelections();
%rename (_setSteadyStateSelections) setSteadyStateSelections(const std::vector<rr::SelectionRecord>&);
%rename (_setSteadyStateSelections) setSteadyStateSelections(const std::vector<std::string>&);


%ignore rr::LoggingBuffer;
%ignore rr::LogLevel;
%ignore rr::getLogger;
%ignore rr::ToUpperCase;
%ignore rr::GetHighestLogLevel;
%ignore rr::GetLogLevel;
%ignore rr::GetLogLevelAsString;
%ignore rr::getLogLevel;
%ignore rr::lShowAlways;
%ignore rr::lError;
%ignore rr::lWarning;
%ignore rr::lInfo;
%ignore rr::lDebug;
%ignore rr::lDebug1;
%ignore rr::lDebug2;
%ignore rr::lDebug3;
%ignore rr::lDebug4;
%ignore rr::lDebug5;
%ignore rr::lAny;
%ignore rr::lUser;


%ignore rr::ExecutableModel::getFloatingSpeciesAmounts(int, int const*, double *);
%ignore rr::ExecutableModel::setFloatingSpeciesAmounts(int len, int const *indx, const double *values);
%ignore rr::ExecutableModel::getFloatingSpeciesAmountRates(int, int const*, double *);
%ignore rr::ExecutableModel::getFloatingSpeciesConcentrations(int, int const*, double *);
%ignore rr::ExecutableModel::setFloatingSpeciesConcentrations(int len, int const *indx, const double *values);
%ignore rr::ExecutableModel::setFloatingSpeciesInitConcentrations(int len, int const *indx, const double *values);
%ignore rr::ExecutableModel::getFloatingSpeciesInitConcentrations(int, int const*, double *);
%ignore rr::ExecutableModel::getBoundarySpeciesAmounts(int, int const*, double *);
%ignore rr::ExecutableModel::getBoundarySpeciesConcentrations(int, int const*, double *);
%ignore rr::ExecutableModel::setBoundarySpeciesConcentrations(int len, int const *indx, const double *values);
%ignore rr::ExecutableModel::getGlobalParameterValues(int, int const*, double *);
%ignore rr::ExecutableModel::setGlobalParameterValues(int len, int const *indx, const double *values);
%ignore rr::ExecutableModel::getCompartmentVolumes(int, int const*, double *);
%ignore rr::ExecutableModel::setCompartmentVolumes(int len, int const *indx, const double *values);
%ignore rr::ExecutableModel::getConservedSums(int, int const*, double *);
%ignore rr::ExecutableModel::setConservedSums(int len, int const *indx, const double *values);
%ignore rr::ExecutableModel::getReactionRates(int, int const*, double *);
%ignore rr::ExecutableModel::evalReactionRates;
%ignore rr::ExecutableModel::convertToAmounts;
%ignore rr::ExecutableModel::computeConservedTotals;
%ignore rr::ExecutableModel::setRateRuleValues;
%ignore rr::ExecutableModel::getRateRuleValues;
%ignore rr::ExecutableModel::getStateVector;
%ignore rr::ExecutableModel::setStateVector;
%ignore rr::ExecutableModel::convertToConcentrations;
%ignore rr::ExecutableModel::updateDependentSpeciesValues;
%ignore rr::ExecutableModel::computeAllRatesOfChange;
%ignore rr::ExecutableModel::evalModel;
%ignore rr::ExecutableModel::testConstraints;
%ignore rr::ExecutableModel::print;
%ignore rr::ExecutableModel::getNumEvents;
%ignore rr::ExecutableModel::getEventTriggers;
%ignore rr::ExecutableModel::evalEvents;
%ignore rr::ExecutableModel::applyPendingEvents;
%ignore rr::ExecutableModel::evalEventRoots;
%ignore rr::ExecutableModel::getNextPendingEventTime;
%ignore rr::ExecutableModel::getPendingEventSize;
%ignore rr::ExecutableModel::resetEvents;

%ignore rr::ExecutableModel::getFloatingSpeciesId(int index);
%ignore rr::ExecutableModel::getBoundarySpeciesId(int index);
%ignore rr::ExecutableModel::getGlobalParameterId(int index);
%ignore rr::ExecutableModel::getCompartmentId(int index);
%ignore rr::ExecutableModel::getConservedSumId(int index);
%ignore rr::ExecutableModel::getReactionId(int index);

%ignore rr::ExecutableModel::getFloatingSpeciesIndex(const std::string& eid);
%ignore rr::ExecutableModel::getBoundarySpeciesIndex(const std::string &eid);
%ignore rr::ExecutableModel::getGlobalParameterIndex(const std::string& eid);
%ignore rr::ExecutableModel::getCompartmentIndex(const std::string& eid);
%ignore rr::ExecutableModel::getConservedSumIndex(const std::string& eid);
%ignore rr::ExecutableModel::getReactionIndex(const std::string& eid);

%ignore rr::ExecutableModel::getStoichiometryMatrix(int*, int*, double**);



// ignore Plugin methods that will be deprecated
%ignore rr::Plugin::assignCallbacks;
//%ignore rr::Plugin::getCopyright;
%ignore rr::Plugin::getParameters;
%ignore rr::Plugin::setInputData;
//%ignore rr::Plugin::execute;
//%ignore rr::Plugin::getImplementationLanguage;
//%ignore rr::Plugin::getResult;
//%ignore rr::Plugin::setLibraryName;
//%ignore rr::Plugin::getAuthor;
//%ignore rr::Plugin::getInfo;
//%ignore rr::Plugin::getStatus;
%ignore rr::Plugin::setParameter;
%ignore rr::Plugin::getCapabilities;
//%ignore rr::Plugin::getLibraryName;
//%ignore rr::Plugin::getVersion;
//%ignore rr::Plugin::this
%ignore rr::Plugin::getCapability;
//%ignore rr::Plugin::getName;
//%ignore rr::Plugin::isWorking;
//%ignore rr::Plugin::getCategory;
%ignore rr::Plugin::getParameter;
//%ignore rr::Plugin::resetPlugin;




%ignore rr::ostream;
%ignore ostream;
%ignore std::ostream;
%ignore operator<<(ostream&, const rr::SelectionRecord& rec);
%ignore operator<<(rr::ostream&, const rr::SelectionRecord& rec);

// ignore all instances of the Configurable methods.
%ignore *::createConfigNode;
%ignore *::loadConfig;


// Warning 389: operator[] ignored (consider using %extend)
// Warning 401: Nothing known about base class 'Configurable'. Ignored.


// Warning 315: Nothing known about 'std::ostream'.
namespace std { class ostream{}; }

// Warning 315: Nothing known about 'Poco::SharedLibrary'.
namespace Poco { class SharedLibrary{}; }
// Warning 401: Nothing known about base class 'Configurable'. Ignored.


/**
 * include the roadrunner files here, this is where the wrappers are generated.
 */

//%import(module="roadrunner") "Configurable.h"
//%ignore rr::Configurable;

//namespace rr { class Configurable{}; }

%ignore rr::Configurable;
%include <Configurable.h>

%include <rrRoadRunnerOptions.h>
%include <rrLogger.h>
%include <rrCompiler.h>
%include <rrExecutableModel.h>
%include <rrModelGenerator.h>
%include <rrRoadRunner.h>
%include <rrSelectionRecord.h>
%include <rrPluginManager.h>
%include <rrPlugin.h>

%extend std::vector<rr::SelectionRecord>
{
    std::string __repr__() {
        std::stringstream s;
        std::vector<rr::SelectionRecord> &p = *($self);

        s << "[";

        for (int i = 0; i < p.size(); ++i)
        {
            s << "\"" << p[i].to_string() << "\"";

            if (i + 1 < p.size())
            {
                s << ", ";
            }
        }

        s << "]";

        return s.str();
    }
}

%extend rr::RoadRunner
{
    // attributes

    const rr::SimulateOptions *simulateOptions;


    const rr::RoadRunnerData *simulate(int startTime, int endTime, int steps) {
        rr::SimulateOptions s = $self->getSimulateOptions();
        s.start = startTime;
        s.duration = endTime - startTime;
        s.steps = steps;
        return $self->simulate(&s);
    }

    std::string __repr__() {
        std::stringstream s;
        s << "<roadrunner.RoadRunner() { this = " << (void*)$self << " }>";
        return s.str();
    }

    double getSelectionValue(const rr::SelectionRecord* pRecord) {
        return $self->getSelectionValue(*pRecord);
    }


    %pythoncode %{
       def getModel(self):
           m = self._getModel();
           m._makeProperties()
           return m

       __swig_getmethods__["selections"] = _getSelections
       __swig_setmethods__["selections"] = _setSelections
       __swig_getmethods__["steadyStateSelections"] = _getSteadyStateSelections
       __swig_setmethods__["steadyStateSelections"] = _setSteadyStateSelections
       __swig_getmethods__["model"] = _getModel

       if _newclass:
           selections = property(_getSelections, _setSelections)
           steadyStateSelections = property(_getSteadyStateSelections, _setSteadyStateSelections)
           model = property(getModel)

       def foo(self):
           return "foo"


    %}
}

%{
    rr::SimulateOptions* rr_RoadRunner_simulateOptions_get(RoadRunner* r) {
        return &r->getSimulateOptions();
    }

    void rr_RoadRunner_simulateOptions_set(RoadRunner* r, const rr::SimulateOptions* opt) {
        r->setSimulateOptions(*opt);
    }
%}


%extend rr::SelectionRecord {

    std::string __repr__() {
        return $self->to_repr();
    }

    std::string __str__() {
        return $self->to_string();
    }
}

%extend rr::SimulateOptions
{
    double end;
    bool resetModel;
    bool stiff;
    bool structuredResult;

    std::string __repr__() {
        std::stringstream s;
        s << "<roadrunner.SimulateOptions() { this = " << (void*)$self << " }>";
        return s.str();
    }

    std::string __str__() {
        std::stringstream s;
        s << "{ 'flags' : " << $self->flags;
        s << ", 'integrator' : " << $self->integrator;
        s << ", 'integratorFlags' : " << $self->integratorFlags;
        s << ", 'steps' : " << $self->steps;
        s << ", 'start' : " << $self->start;
        s << ", 'duration' : " << $self->duration;
        s << ", 'absolute' : " << $self->absolute;
        s << ", 'relative' : " << $self->relative;
        s << ", 'variables' : " << strvec_to_pystring($self->variables);
        s << ", 'amounts' : " << strvec_to_pystring($self->amounts);
        s << ", 'concentrations' : " << strvec_to_pystring($self->concentrations);
        s << "}";
        return s.str();
    }
}

%{
    double rr_SimulateOptions_end_get(SimulateOptions* opt) {
        return opt->start + opt->duration;
    }

    void rr_SimulateOptions_end_set(SimulateOptions* opt, double end) {
        opt->duration = end - opt->start;
    }

    bool rr_SimulateOptions_resetModel_get(SimulateOptions* opt) {
        return opt->flags & SimulateOptions::RESET_MODEL;
    }

    void rr_SimulateOptions_resetModel_set(SimulateOptions* opt, bool value) {
        if (value) {
            opt->flags |= SimulateOptions::RESET_MODEL;
        } else {
            opt->flags &= !SimulateOptions::RESET_MODEL;
        }
    }

    bool rr_SimulateOptions_structuredResult_get(SimulateOptions* opt) {
        return opt->flags & SimulateOptions::STRUCTURED_RESULT;
    }

    void rr_SimulateOptions_structuredResult_set(SimulateOptions* opt, bool value) {
        if (value) {
            opt->flags |= SimulateOptions::STRUCTURED_RESULT;
        } else {
            opt->flags &= !SimulateOptions::STRUCTURED_RESULT;
        }
    }

    bool rr_SimulateOptions_stiff_get(SimulateOptions* opt) {
        return opt->flags & SimulateOptions::STIFF;
    }

    void rr_SimulateOptions_stiff_set(SimulateOptions* opt, bool value) {
        if (value) {
            opt->integratorFlags |= SimulateOptions::STIFF;
        } else {
            opt->integratorFlags &= !SimulateOptions::STIFF;
        }
    }
%}


%extend rr::ExecutableModel
{

    /***
     ** get values section
     ***/

    PyObject *getFloatingSpeciesAmounts(int len, int const *indx) {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getFloatingSpeciesAmounts,
                                          &rr::ExecutableModel::getNumFloatingSpecies, len, indx);
    }

    PyObject *getFloatingSpeciesAmounts() {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getFloatingSpeciesAmounts,
                                          &rr::ExecutableModel::getNumFloatingSpecies, (int)0, (int const*)0);
    }

    PyObject *getFloatingSpeciesAmountRates(int len, int const *indx) {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getFloatingSpeciesAmountRates,
                                         &rr::ExecutableModel::getNumFloatingSpecies,  len, indx);
    }

    PyObject *getFloatingSpeciesAmountRates() {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getFloatingSpeciesAmountRates,
                                          &rr::ExecutableModel::getNumFloatingSpecies, (int)0, (int const*)0);
    }

    PyObject *getFloatingSpeciesConcentrations(int len, int const *indx) {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getFloatingSpeciesConcentrations,
                                         &rr::ExecutableModel::getNumFloatingSpecies,  len, indx);
    }

    PyObject *getFloatingSpeciesConcentrations() {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getFloatingSpeciesConcentrations,
                                          &rr::ExecutableModel::getNumFloatingSpecies, (int)0, (int const*)0);
    }

    PyObject *getBoundarySpeciesAmounts(int len, int const *indx) {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getBoundarySpeciesAmounts,
                                         &rr::ExecutableModel::getNumBoundarySpecies,  len, indx);
    }

    PyObject *getBoundarySpeciesAmounts() {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getBoundarySpeciesAmounts,
                                          &rr::ExecutableModel::getNumBoundarySpecies, (int)0, (int const*)0);
    }

    PyObject *getBoundarySpeciesConcentrations(int len, int const *indx) {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getBoundarySpeciesConcentrations,
                                         &rr::ExecutableModel::getNumBoundarySpecies,  len, indx);
    }

    PyObject *getBoundarySpeciesConcentrations() {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getBoundarySpeciesConcentrations,
                                          &rr::ExecutableModel::getNumBoundarySpecies, (int)0, (int const*)0);
    }
    PyObject *getGlobalParameterValues(int len, int const *indx) {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getGlobalParameterValues,
                                         &rr::ExecutableModel::getNumGlobalParameters,  len, indx);
    }

    PyObject *getGlobalParameterValues() {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getGlobalParameterValues,
                                          &rr::ExecutableModel::getNumGlobalParameters, (int)0, (int const*)0);
    }

    PyObject *getCompartmentVolumes(int len, int const *indx) {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getCompartmentVolumes,
                                         &rr::ExecutableModel::getNumCompartments,  len, indx);
    }

    PyObject *getCompartmentVolumes() {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getCompartmentVolumes,
                                          &rr::ExecutableModel::getNumCompartments, (int)0, (int const*)0);
    }

    PyObject *getConservedSums(int len, int const *indx) {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getConservedSums,
                                         &rr::ExecutableModel::getNumConservedSums,  len, indx);
    }

    PyObject *getConservedSums() {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getConservedSums,
                                          &rr::ExecutableModel::getNumConservedSums, (int)0, (int const*)0);
    }

    PyObject *getReactionRates(int len, int const *indx) {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getReactionRates,
                                         &rr::ExecutableModel::getNumReactions,  len, indx);
    }

    PyObject *getReactionRates() {
        return _ExecutableModel_getValues($self, &rr::ExecutableModel::getReactionRates,
                                          &rr::ExecutableModel::getNumReactions, (int)0, (int const*)0);
    }

    /***
     ** get ids section
     ***/


    PyObject *getFloatingSpeciesIds() {
        return _ExecutableModel_getIds($self, &rr::ExecutableModel::getNumFloatingSpecies,
                                       &rr::ExecutableModel::getFloatingSpeciesId);
    }

    PyObject *getBoundarySpeciesIds() {
        return _ExecutableModel_getIds($self, &rr::ExecutableModel::getNumBoundarySpecies,
                                       &rr::ExecutableModel::getBoundarySpeciesId);
    }

    PyObject *getGlobalParameterIds() {
        return _ExecutableModel_getIds($self, &rr::ExecutableModel::getNumGlobalParameters,
                                       &rr::ExecutableModel::getGlobalParameterId);
    }

    PyObject *getCompartmentIds() {
        return _ExecutableModel_getIds($self, &rr::ExecutableModel::getNumCompartments,
                                       &rr::ExecutableModel::getCompartmentId);
    }

    PyObject *getReactionIds() {
        return _ExecutableModel_getIds($self, &rr::ExecutableModel::getNumReactions,
                                       &rr::ExecutableModel::getReactionId);
    }


    /***
     ** set values section
     ***/

    int setFloatingSpeciesAmounts(int len, double const *values) {
        return $self->setFloatingSpeciesAmounts(len, 0, values);
    }


    //int setFloatingSpeciesAmountRates(int len, double const *values) {
    //    return $self->setFloatingSpeciesAmountRates(len, 0, values);
    //}


    int setFloatingSpeciesConcentrations(int len, double const *values) {
        return $self->setFloatingSpeciesConcentrations(len, 0, values);
    }

    //int setBoundarySpeciesAmounts(int len, double const *values) {
    //    return $self->setBoundarySpeciesAmounts(len, 0, values);
    //}

    int setBoundarySpeciesConcentrations(int len, double const *values) {
        return $self->setBoundarySpeciesConcentrations(len, 0, values);
    }

    int setGlobalParameterValues(int len, double const *values) {
        return $self->setGlobalParameterValues(len, 0, values);
    }

    int setCompartmentVolumes(int len, double const *values) {
        return $self->setCompartmentVolumes(len, 0, values);
    }

    int setConservedSums(int len, double const *values) {
        return $self->setConservedSums(len, 0, values);
    }

    //int setReactionRates(int len, double const *values) {
    //    return $self->setReactionRates(len, 0, values);
    //}

    int setFloatingSpeciesAmounts(int leni, int const* indx, int lenv, double const *values) {
        if (leni != lenv) {
            PyErr_Format(PyExc_ValueError,
                         "Arrays of lengths (%d,%d) given",
                         leni, lenv);
            return -1;
        }
        return $self->setFloatingSpeciesAmounts(leni, indx, values);
    }


    //int setFloatingSpeciesAmountRates(int len, double const *values) {
    //    return $self->setFloatingSpeciesAmountRates(len, 0, values);
    //}


    int setFloatingSpeciesConcentrations(int leni, int const* indx, int lenv, double const *values) {
        if (leni != lenv) {
            PyErr_Format(PyExc_ValueError,
                         "Arrays of lengths (%d,%d) given",
                         leni, lenv);
            return -1;
        }
        return $self->setFloatingSpeciesConcentrations(leni, indx, values);
    }

    //int setBoundarySpeciesAmounts(int len, double const *values) {
    //    return $self->setBoundarySpeciesAmounts(len, 0, values);
    //}

    int setBoundarySpeciesConcentrations(int leni, int const* indx, int lenv, double const *values) {
        if (leni != lenv) {
            PyErr_Format(PyExc_ValueError,
                         "Arrays of lengths (%d,%d) given",
                         leni, lenv);
            return -1;
        }
        return $self->setBoundarySpeciesConcentrations(leni, indx, values);
    }

    int setGlobalParameterValues(int leni, int const* indx, int lenv, double const *values) {
        if (leni != lenv) {
            PyErr_Format(PyExc_ValueError,
                         "Arrays of lengths (%d,%d) given",
                         leni, lenv);
            return -1;
        }
        return $self->setGlobalParameterValues(leni, indx, values);
    }

    int setCompartmentVolumes(int leni, int const* indx, int lenv, double const *values) {
        if (leni != lenv) {
            PyErr_Format(PyExc_ValueError,
                         "Arrays of lengths (%d,%d) given",
                         leni, lenv);
            return -1;
        }
        return $self->setCompartmentVolumes(leni, indx, values);
    }

    int setConservedSums(int leni, int const* indx, int lenv, double const *values) {
        if (leni != lenv) {
            PyErr_Format(PyExc_ValueError,
                         "Arrays of lengths (%d,%d) given",
                         leni, lenv);
            return -1;
        }
        return $self->setConservedSums(leni, indx, values);
    }

    PyObject* getStoichiometryMatrix() {
        int rows = 0;
        int cols = 0;
        double* data = 0;

        $self->getStoichiometryMatrix(&rows, &cols, &data);

        int nd = 2;
        npy_intp dims[2] = {rows, cols};

        PyObject *pArray = PyArray_New(&PyArray_Type, nd, dims, NPY_DOUBLE, NULL, data, 0,
                NPY_CARRAY | NPY_OWNDATA, NULL);

        return pArray;
    }


    /**
     * get values.
     */

    double __getitem__(const std::string& id) {
        ExecutableModel* p = $self;

        SelectionRecord sel(id);

        int index = -1;
        double result = 0;

        if (sel.selectionType == SelectionRecord::UNKNOWN)
        {
            throw Exception("invalid selection string " + id);
        }

        // check to see that we have valid selection ids
        switch(sel.selectionType)
        {
        case SelectionRecord::TIME:
            result = p->getTime();
            break;
        case SelectionRecord::UNKNOWN_ELEMENT:
            // check for sbml element types

            if ((index = p->getFloatingSpeciesIndex(sel.p1)) >= 0)
            {
                p->getFloatingSpeciesAmounts(1, &index, &result);
                break;
            }
            else if ((index = p->getBoundarySpeciesIndex(sel.p1)) >= 0)
            {
                p->getBoundarySpeciesAmounts(1, &index, &result);
                break;
            }
            else if ((index = p->getCompartmentIndex(sel.p1)) >= 0)
            {
                p->getCompartmentVolumes(1, &index, &result);
                break;
            }
            else if ((index = p->getGlobalParameterIndex(sel.p1)) >= 0)
            {
                p->getGlobalParameterValues(1, &index, &result);
                break;
            }
            else if ((index = p->getReactionIndex(sel.p1)) >= 0)
            {
                p->getReactionRates(1, &index, &result);
                break;
            }
            else
            {
                throw Exception("No sbml element exists for symbol '" + id + "'");
                break;
            }
        case SelectionRecord::UNKNOWN_CONCENTRATION:
            if ((index = p->getFloatingSpeciesIndex(sel.p1)) >= 0)
            {
                p->getFloatingSpeciesConcentrations(1, &index, &result);
                break;
            }
            else if ((index = p->getBoundarySpeciesIndex(sel.p1)) >= 0)
            {
                p->getBoundarySpeciesConcentrations(1, &index, &result);
                break;
            }
            else
            {
                string msg = "No sbml element exists for concentration selection '" + id + "'";
                Log(Logger::PRIO_ERROR) << msg;
                throw Exception(msg);
                break;
            }
        case SelectionRecord::FLOATING_AMOUNT_RATE:
            if ((index = p->getFloatingSpeciesIndex(sel.p1)) >= 0)
            {
                p->getReactionRates(1, &index, &result);
                break;
            }
            else
            {
                throw Exception("Invalid id '" + id + "' for floating amount rate");
                break;
            }

        default:
            Log(Logger::PRIO_ERROR) << "A new SelectionRecord should not have this value: "
                                    << sel.to_repr();
            throw Exception("Invalid selection '" + id + "' for setting value");
            break;
        }

        return result;
    }

    void __setitem__(const std::string& id, double value) {
        ExecutableModel* p = $self;

        SelectionRecord sel(id);

        int index = -1;

        if (sel.selectionType == SelectionRecord::UNKNOWN)
        {
            throw Exception("invalid selection string " + id);
        }

        // check to see that we have valid selection ids
        switch(sel.selectionType)
        {
        case SelectionRecord::TIME:
            p->setTime(value);
            break;
        case SelectionRecord::UNKNOWN_ELEMENT:
            // check for sbml element types

            if ((index = p->getFloatingSpeciesIndex(sel.p1)) >= 0)
            {
                p->setFloatingSpeciesAmounts(1, &index, &value);
                break;
            }
            else if ((index = p->getCompartmentIndex(sel.p1)) >= 0)
            {
                p->setCompartmentVolumes(1, &index, &value);
                break;
            }
            else if ((index = p->getGlobalParameterIndex(sel.p1)) >= 0)
            {
                p->setGlobalParameterValues(1, &index, &value);
                break;
            }
            else
            {
                throw Exception("Invalid or non-existant sbml id  '" + id + "' for set value");
                break;
            }
        case SelectionRecord::UNKNOWN_CONCENTRATION:
            if ((index = p->getFloatingSpeciesIndex(sel.p1)) >= 0)
            {
                p->setFloatingSpeciesConcentrations(1, &index, &value);
                break;
            }
            else if ((index = p->getBoundarySpeciesIndex(sel.p1)) >= 0)
            {
                p->setBoundarySpeciesConcentrations(1, &index, &value);
                break;
            }
            else
            {
                string msg = "No sbml element exists for concentration selection '" + id + "'";
                Log(Logger::PRIO_ERROR) << msg;
                throw Exception(msg);
                break;
            }

        default:
            Log(Logger::PRIO_ERROR) << "Invalid selection '" + sel.to_string() + "' for setting value";
            throw Exception("Invalid selection '" + sel.to_string() + "' for setting value");
            break;
        }
    }


    std::string __repr__() {
        std::stringstream s;
        s << "<roadrunner.ExecutableModel() { this = " << (void*)$self << " }>";
        return s.str();
    }

    %pythoncode %{
        def _makeProperties(self) :

            def mk_fget(sel): return lambda self: self.__getitem__(sel)
            def mk_fset(sel): return lambda self, val: self.__setitem__(sel, val)

            for s in self.getFloatingSpeciesIds():
                sel = "[" + s + "]"
                fget = mk_fget(sel)
                fset = mk_fset(sel)
                self.__class__.__swig_getmethods__[s] = fget
                self.__class__.__swig_setmethods__[s] = fset
                setattr(self.__class__, s, property(fget, fset))

                fget = mk_fget(s)
                fset = mk_fset(s)
                name = s + "_amt"
                self.__class__.__swig_getmethods__[name] = fget
                self.__class__.__swig_setmethods__[name] = fset
                setattr(self.__class__, name, property(fget, fset))

            ids = self.getGlobalParameterIds() + self.getCompartmentIds() + \
                self.getReactionIds()

            for s in ids:
                fget = mk_fget(s)
                fset = mk_fset(s)
                self.__class__.__swig_getmethods__[s] = fget
                self.__class__.__swig_setmethods__[s] = fset
                setattr(self.__class__, s, property(fget, fset))
    %}
}

%pythoncode %{
def plot(result, show=True):
    import pylab as p

    if result.dtype.names is None:
        # treat as a regular array
        p.plot(result[:,0], result[:,1:])

    else:
        if len(result.dtype.names) < 1:
            raise Exception('no columns to plot')

        time = result.dtype.names[0]

        for name in result.dtype.names[1:]:
            p.plot(result[time], result[name], label='$' + name + '$')

        p.legend()

    if show:
        p.show()
%}

