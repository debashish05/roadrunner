#ifndef rrCGeneratorH
#define rrCGeneratorH
//---------------------------------------------------------------------------
#include "rrModelGenerator.h"
#include "rrCodeBuilder.h"
#include "rrCompiler.h"
#include "Poco/Thread.h"

namespace rr
{

using Poco::Mutex;

class RR_DECLSPEC CGenerator : public ModelGenerator
{
    private:
        CodeBuilder                         mHeader;
        CodeBuilder                         mSource;

        string                              mHeaderCodeFileName;
        string                              mSourceCodeFileName;

        string                              mCurrentSBML;

        ModelSharedLibrary                  mModelLib;

        Compiler                            mCompiler;

        string                              mTempFileFolder;

        bool generateModelCode(const string& sbml, const string& modelName, bool computeAndAssignConsevationLaws);

        static Mutex                    mCompileMutex;

        bool compileModel();

        bool unLoadModelDLL();

        bool compileCurrentModel();

        ExecutableModel* createModel();

        ExecutableModel* mModel;

        /**
         * perform some basic initialization on the model.
         *
         * If the caller has mComputeAndAssignConservationLaws or mCVode, it
         * needs to make the model aware of these.
         */
        bool initializeModel();

        string                              convertUserFunctionExpression(const string& equation);
        string                              convertCompartmentToC(const string& compartmentName);
        string                              convertSpeciesToBc(const string& speciesName);
        string                              convertSpeciesToY(const string& speciesName);
        string                              convertSymbolToC(const string& compartmentName);
        string                              convertSymbolToGP(const string& parameterName);

        void                                substituteEquation(const string& reactionName, Scanner& s, CodeBuilder& sb);
        void                                substituteWords(const string& reactionName, bool bFixAmounts, Scanner& s, CodeBuilder& sb);
        void                                substituteToken(const string& reactionName, bool bFixAmounts, Scanner& s, CodeBuilder& sb);
        string                              findSymbol(const string& varName);
		void 								write_getModelNameFunction(CodeBuilder& ignore, CodeBuilder& source);
        void                                writeOutSymbolTables(CodeBuilder& sb);
        void                                writeComputeAllRatesOfChange(CodeBuilder& sb, const int& numIndependentSpecies, const int& numDependentSpecies, DoubleMatrix& L0);
        void                                writeComputeConservedTotals(CodeBuilder& sb, const int& numFloatingSpecies, const int& numDependentSpecies);
        void                                writeUpdateDependentSpecies(CodeBuilder& sb, const int& numIndependentSpecies, const int& numDependentSpecies, DoubleMatrix& L0);
        void                                writeUserDefinedFunctions(CodeBuilder& sb);
        void                                writeResetEvents(CodeBuilder& sb, const int& numEvents);
        void                                writeSetConcentration(CodeBuilder& sb);
        void                                writeGetConcentration(CodeBuilder& sb);
        void                                writeConvertToAmounts(CodeBuilder& sb);
        void                                writeConvertToConcentrations(CodeBuilder& sb);
        void                                writeProperties(CodeBuilder& sb);
        void                                writeAccessors(CodeBuilder& sb);
        void                                writeOutVariables(CodeBuilder& sb);
        void                                writeClassHeader(CodeBuilder& sb);
        void                                writeTestConstraints(CodeBuilder& sb);
        void                                writeEvalInitialAssignments(CodeBuilder& sb, const int& numReactions);
        int                                 writeComputeRules(CodeBuilder& sb, const int& numReactions);
        void                                writeComputeReactionRates(CodeBuilder& sb, const int& numReactions);
        void                                writeEvalEvents(CodeBuilder& sb, const int& numEvents, const int& numFloatingSpecies);
        void                                writeEvalModel(CodeBuilder& sb, const int& numReactions, const int& numIndependentSpecies, const int& numFloatingSpecies, const int& numOfRules);
        void                                writeEventAssignments(CodeBuilder& sb, const int& numReactions, const int& numEvents);
        void                                writeSetParameterValues(CodeBuilder& sb, const int& numReactions);
        void                                writeSetCompartmentVolumes(CodeBuilder& sb);
        void                                writeSetBoundaryConditions(CodeBuilder& sb);
        void                                writeSetInitialConditions(CodeBuilder& sb, const int& numFloatingSpecies);
        void                                writeInitFunction(CodeBuilder& sbh, CodeBuilder& sbc);
        void                                writeInitModelDataFunction(CodeBuilder& sbh, CodeBuilder& sbc);

        int                                 readFloatingSpecies();
        int                                 readBoundarySpecies();

    public:
                                            CGenerator(const string& tempFolder, const string& supportCodeFolder, const string& compiler,
                                                    LibStructural *ls, NOMSupport *nom);
        virtual                            ~CGenerator();

        // Generates the Model Code from th e SBML string
        string                              generateModelCode(const string& sbmlStr, const bool& _computeAndAssignConsevationLaws = false);

        //C Specifics..
        string                              getHeaderCode();
        string                              getSourceCode();
        string                              getSourceCodeFileName();
        string                              getHeaderCodeFileName();
        bool                                saveSourceCodeToFolder(const string& folder, const string& baseName);
        int                                 getNumberOfFloatingSpecies();

        virtual ExecutableModel             *createModel(const string& sbml, LibStructural *ls, NOMSupport *nom,
                                                         bool forceReCompile, bool computeAndAssignConsevationLaws);
};
}

#endif
