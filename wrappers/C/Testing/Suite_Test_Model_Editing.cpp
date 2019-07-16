#include <string>
#include "Suite_TestModel.h"
#include "unit_test/UnitTest++.h"
#include "rrConfig.h"
#include "rrIniFile.h"
#include "rrLogger.h"
#include "rrRoadRunner.h"
#include "rrUtils.h"
#include "rrc_api.h"
#include "rrc_cpp_support.h"
#include "src/TestUtils.h"
#include "src/rrSBMLTestSuiteSimulation_CAPI.h"
#include "sbml/SBMLDocument.h"
#include "sbml/ListOf.h"
#include "sbml/Model.h"

using namespace std;
using namespace UnitTest;
using namespace ls;
using namespace rrc;
using namespace rr;

extern string gTempFolder;
extern string gTSModelsPath;
extern string gCompiler;

bool RunModelEditingTest(int caseNumber, void (*modification)(RoadRunner*))
{
	bool result(false);
	RRHandle gRR;
	std::string version = "l2v4";

	//Create instance..
	gRR = createRRInstanceEx(gTempFolder.c_str(), gCompiler.c_str());

	//Setup environment
	setTempFolder(gRR, gTempFolder.c_str());
	libsbml::SBMLDocument doc;

	if (!gRR)
	{
		return false;
	}

	try
	{
		Log(Logger::LOG_NOTICE) << "Running Test: " << caseNumber << endl;
		string dataOutputFolder(gTempFolder + "/model_editing");
		string dummy;
		string logFileName;
		string settingsFileName;

		setCurrentIntegratorParameterBoolean(gRR, "stiff", 0);

		//Create a log file name
		createTestSuiteFileNameParts(caseNumber, ".log", dummy, logFileName, settingsFileName);
		if (!createFolder(dataOutputFolder))
		{
			string msg("Failed creating output folder for data output: " + dataOutputFolder);
			throw(rr::Exception(msg));
		}
		//Create subfolder for data output
		dataOutputFolder = joinPath(dataOutputFolder, getTestSuiteSubFolderName(caseNumber));

		if (!createFolder(dataOutputFolder))
		{
			string msg("Failed creating output folder for data output: " + dataOutputFolder);
			throw(rr::Exception(msg));
		}

		SBMLTestSuiteSimulation_CAPI simulation(dataOutputFolder);

		simulation.UseHandle(gRR);

		//Read SBML models.....
		string modelFilePath(gTSModelsPath + "/model_editing");
		string modelFileName;

		simulation.SetCaseNumber(caseNumber);
		createTestSuiteFileNameParts(caseNumber, "-sbml-" + version + ".xml", modelFilePath, modelFileName, settingsFileName);

		//The following will load and compile and simulate the sbml model in the file
		simulation.SetModelFilePath(modelFilePath);
		simulation.SetModelFileName(modelFileName);
		simulation.ReCompileIfDllExists(true);
		simulation.CopyFilesToOutputFolder();
		setTempFolder(gRR, simulation.GetDataOutputFolder().c_str());
		setComputeAndAssignConservationLaws(gRR, false);

		libsbml::SBMLReader reader;
		std::string fullPath = modelFilePath + "/" + modelFileName;
		doc = *reader.readSBML(fullPath);

		if (!simulation.LoadSBMLFromFile())
		{
			throw(Exception("Failed loading sbml from file"));
		}


		//Check first if file exists first
		if (!fileExists(fullPath))
		{
			Log(Logger::LOG_ERROR) << "sbml file " << fullPath << " not found";
			throw(Exception("No such SBML file: " + fullPath));
		}

		RoadRunner* rri = (RoadRunner*)gRR;

		LoadSBMLOptions opt;

		// don't generate cache for models
		opt.modelGeneratorOpt = opt.modelGeneratorOpt | LoadSBMLOptions::RECOMPILE;

		opt.modelGeneratorOpt = opt.modelGeneratorOpt | LoadSBMLOptions::MUTABLE_INITIAL_CONDITIONS;

		opt.modelGeneratorOpt = opt.modelGeneratorOpt & ~LoadSBMLOptions::READ_ONLY;

		opt.modelGeneratorOpt = opt.modelGeneratorOpt | LoadSBMLOptions::OPTIMIZE_CFG_SIMPLIFICATION;

		opt.modelGeneratorOpt = opt.modelGeneratorOpt | LoadSBMLOptions::OPTIMIZE_GVN;


		rri->load(fullPath, &opt);

		//Then read settings file if it exists..
		string settingsOveride("");
		if (!simulation.LoadSettings(settingsOveride))
		{
			throw(Exception("Failed loading simulation settings"));
		}
		modification(rri);
		//Then Simulate model
		if (!simulation.Simulate())
		{
			throw(Exception("Failed running simulation"));
		}

		//Write result
		if (!simulation.SaveResult())
		{
			//Failed to save data
			throw(Exception("Failed saving result"));
		}

		if (!simulation.LoadReferenceData())
		{
			throw(Exception("Failed Loading reference data"));
		}

		simulation.CreateErrorData();
		result = simulation.Pass();
		result = simulation.SaveAllData() && result;
		result = simulation.SaveModelAsXML(dataOutputFolder) && result;
		if (!result)
		{
			Log(Logger::LOG_WARNING) << "\t\t =============== Test " << caseNumber << " failed =============\n";
		}
		else
		{
			Log(Logger::LOG_NOTICE) << "\t\tTest passed.\n";
		}
	}
	catch (std::exception& ex)
	{
		string error = ex.what();
		cerr << "Case " << caseNumber << ": Exception: " << error << endl;
		freeRRInstance(gRR);
		return false;
	}

	freeRRInstance(gRR);
	return result;
}

bool RunTestWithEdit(const string& version, int caseNumber, void(*edit)(RoadRunner*, libsbml::SBMLDocument*), std::string editName)
{
	bool result(false);
	RRHandle gRR;

	//Create instance..
	gRR = createRRInstanceEx(gTempFolder.c_str(), gCompiler.c_str());


	//Setup environment
	setTempFolder(gRR, gTempFolder.c_str());
	libsbml::SBMLDocument doc;

	if (!gRR)
	{
		return false;
	}

	try
	{
		Log(Logger::LOG_NOTICE) << "Running Test: " << caseNumber << endl;
		string dataOutputFolder(gTempFolder + "/" + editName);
		string dummy;
		string logFileName;
		string settingsFileName;

		setCurrentIntegratorParameterBoolean(gRR, "stiff", 0);

		//Create a log file name
		createTestSuiteFileNameParts(caseNumber, ".log", dummy, logFileName, settingsFileName);
		if (!createFolder(dataOutputFolder))
		{
			string msg("Failed creating output folder for data output: " + dataOutputFolder);
			throw(rr::Exception(msg));
		}
		//Create subfolder for data output
		dataOutputFolder = joinPath(dataOutputFolder, getTestSuiteSubFolderName(caseNumber));

		if (!createFolder(dataOutputFolder))
		{
			string msg("Failed creating output folder for data output: " + dataOutputFolder);
			throw(rr::Exception(msg));
		}

		SBMLTestSuiteSimulation_CAPI simulation(dataOutputFolder);

		simulation.UseHandle(gRR);

		//Read SBML models.....
		string modelFilePath(gTSModelsPath);
		string modelFileName;

		simulation.SetCaseNumber(caseNumber);
		createTestSuiteFileNameParts(caseNumber, "-sbml-" + version + ".xml", modelFilePath, modelFileName, settingsFileName);

		//The following will load and compile and simulate the sbml model in the file
		simulation.SetModelFilePath(modelFilePath);
		simulation.SetModelFileName(modelFileName);
		simulation.ReCompileIfDllExists(true);
		simulation.CopyFilesToOutputFolder();
		setTempFolder(gRR, simulation.GetDataOutputFolder().c_str());
		setComputeAndAssignConservationLaws(gRR, false);

		libsbml::SBMLReader reader;
		std::string fullPath = modelFilePath + "/" + modelFileName;
		doc = *reader.readSBML(fullPath);

		if (!simulation.LoadSBMLFromFile())
		{
			throw(Exception("Failed loading sbml from file"));
		}


		//Check first if file exists first
		if (!fileExists(fullPath))
		{
			Log(Logger::LOG_ERROR) << "sbml file " << fullPath << " not found";
			throw(Exception("No such SBML file: " + fullPath));
		}

		RoadRunner* rri = (RoadRunner*)gRR;

		LoadSBMLOptions opt;

		// don't generate cache for models
		opt.modelGeneratorOpt = opt.modelGeneratorOpt | LoadSBMLOptions::RECOMPILE;

		opt.modelGeneratorOpt = opt.modelGeneratorOpt | LoadSBMLOptions::MUTABLE_INITIAL_CONDITIONS;

		opt.modelGeneratorOpt = opt.modelGeneratorOpt & ~LoadSBMLOptions::READ_ONLY;

		opt.modelGeneratorOpt = opt.modelGeneratorOpt | LoadSBMLOptions::OPTIMIZE_CFG_SIMPLIFICATION;

		opt.modelGeneratorOpt = opt.modelGeneratorOpt | LoadSBMLOptions::OPTIMIZE_GVN;


		rri->load(fullPath, &opt);

		//Then read settings file if it exists..
		string settingsOveride("");
		if (!simulation.LoadSettings(settingsOveride))
		{
			throw(Exception("Failed loading simulation settings"));
		}
		//Perform the model editing action
		edit(castToRoadRunner(gRR), &doc);
		//Then Simulate model
		if (!simulation.Simulate())
		{
			throw(Exception("Failed running simulation"));
		}

		//Write result
		if (!simulation.SaveResult())
		{
			//Failed to save data
			throw(Exception("Failed saving result"));
		}

		if (!simulation.LoadReferenceData())
		{
			throw(Exception("Failed Loading reference data"));
		}

		simulation.CreateErrorData();
		result = simulation.Pass();
		result = simulation.SaveAllData() && result;
		result = simulation.SaveModelAsXML(dataOutputFolder) && result;
		if (!result)
		{
			Log(Logger::LOG_WARNING) << "\t\t =============== Test " << caseNumber << " failed =============\n";
		}
		else
		{
			Log(Logger::LOG_NOTICE) << "\t\tTest passed.\n";
		}
	}
	catch (std::exception& ex)
	{
		string error = ex.what();
		cerr << "Case " << caseNumber << ": Exception: " << error << endl;
		freeRRInstance(gRR);
		return false;
	}

	freeRRInstance(gRR);
	return result;
}

void readdAllReactions(RoadRunner *rri, libsbml::SBMLDocument *doc)
{
	libsbml::ListOfReactions *reactionsToAdd = doc->getModel()->getListOfReactions();
	std::vector<std::string> currReactionIds = rri->getReactionIds();
	for (int i = 0; i < reactionsToAdd->size(); i++)
	{
		libsbml::Reaction *next = reactionsToAdd->get(i);
		if (std::find(currReactionIds.begin(), currReactionIds.end(), next->getId()) ==
			currReactionIds.end())
			rri->addReaction(next->toSBML());
	}
}

void readdAllSpecies(RoadRunner *rri, libsbml::SBMLDocument *doc)
{
	libsbml::ListOfSpecies *speciesToAdd = doc->getModel()->getListOfSpecies();
	std::vector<std::string> currSpeciesIds = rri->getBoundarySpeciesIds();
	for (std::string s : rri->getFloatingSpeciesIds())
		currSpeciesIds.push_back(s);
	if (speciesToAdd->size() > 0)
	{
		libsbml::Species *next;
		for (int i = 0; i < speciesToAdd->size(); i++)
		{
			next = speciesToAdd->get(i);
			if(std::find(currSpeciesIds.begin(), currSpeciesIds.end(), next->getId()) == currSpeciesIds.end())
				rri->addSpecies(next->getId(), next->getCompartment(), next->getInitialConcentration(), "concentration", false);
		}
	}
}

void removeAndReaddAllSpecies(RoadRunner *rri, libsbml::SBMLDocument *doc)
{
	//Remove all species
	std::vector<std::string> floatingSpeciesIds = rri->getFloatingSpeciesIds();
	for (std::string sid : floatingSpeciesIds)
	{
		rri->removeSpecies(sid, false);
	}

	std::vector<std::string> boundarySpeciesIds = rri->getBoundarySpeciesIds();
	for (std::string sid : boundarySpeciesIds)
	{
		rri->removeSpecies(sid, false);
	}

	//Readd all species
	//libsbml::ListOfSpecies *speciesToAdd = doc->getModel()->getListOfSpecies();
	//if (speciesToAdd->size() > 0)
	//{
	//	libsbml::Species *next;
	//	for (int i = 0; i < speciesToAdd->size(); i++)
	//	{
	//		next = speciesToAdd->get(i);
	//		rri->addSpecies(next->getId(), next->getCompartment(), next->getInitialConcentration(), "concentration", false);
	//	}
	//}
	readdAllSpecies(rri, doc);

	readdAllReactions(rri, doc);
}

void removeAndReaddAllReactions(RoadRunner *rri, libsbml::SBMLDocument *doc)
{
	std::vector<std::string> reactionIds = rri->getReactionIds();
	for (std::string rid : reactionIds)
	{
		rri->removeReaction(rid, false);
	}
	readdAllReactions(rri, doc);
}

void removeAndReaddAllCompartments(RoadRunner *rri, libsbml::SBMLDocument *doc)
{
	std::vector<std::string> compartmentIds = rri->getCompartmentIds();
	for (std::string cid : compartmentIds)
	{
		rri->removeCompartment(cid, false);
	}

	libsbml::ListOfCompartments *compartmentsToAdd = doc->getModel()->getListOfCompartments();
	for (int i = 0; i < compartmentsToAdd->size(); i++)
	{
		libsbml::Compartment * next = compartmentsToAdd->get(i);
		rri->addCompartment(next->getId(), next->getVolume(), false);
	}
	readdAllSpecies(rri, doc);
	readdAllReactions(rri, doc);
}

SUITE(MODEL_EDITING_TEST_SUITE)
{
	TEST(ADD_REACTION_1)
	{
		CHECK(RunModelEditingTest(1, [](RoadRunner* rri) {
			rri->addReaction("reaction2", {"S2"}, {"S1"}, "k1*S2", true);
		}));
	}
	TEST(REMOVE_REACTION_1)
	{
		CHECK(RunModelEditingTest(2, [](RoadRunner* rri) {
			rri->removeReaction("reaction2");
		}));
	}
	TEST(ADD_REACTION_2)
	{
		CHECK(RunModelEditingTest(3, [](RoadRunner* rri) {
			rri->addReaction("reaction2", {"2*S2", "S1"}, {"S1"}, "k1*S1 + k1*S2", true);
		}));
	}
	TEST(REMOVE_REACTION_2)
	{
		CHECK(RunModelEditingTest(4, [](RoadRunner* rri) {
			rri->removeReaction("reaction2");
		}));
	}
	TEST(REMOVE_REACTION_3)
	{
		CHECK(RunModelEditingTest(5, [](RoadRunner* rri) {
			rri->removeSpecies("S2");
		}));
	}
	TEST(ADD_SPECIES_1)
	{
		CHECK(RunModelEditingTest(6, [](RoadRunner* rri) {
			rri->addSpecies("S3", "compartment", 0.0015, "substance");
		}));
	}
	TEST(ADD_REACTION_3)
	{
		CHECK(RunModelEditingTest(7, [](RoadRunner* rri) {
			rri->addSpecies("S3", "compartment", 0.015, "concentration", false);
			rri->addReaction("reaction3", {"S2"}, {"S3"}, "k2*S2");
		}));
	}
	TEST(ADD_REACTION_4)
	{
		CHECK(RunModelEditingTest(7, [](RoadRunner* rri) {
			rri->addSpecies("S3", "compartment", 0.015, "substance");
			rri->addReaction("reaction3", {"S2"}, {"S3"}, "k2*S2");
		}));
	}
	TEST(ADD_REACTION_5)
	{
		CHECK(RunModelEditingTest(8, [](RoadRunner* rri) {
			rri->addSpecies("S3", "compartment", 0.015, "substance", false);
			rri->addReaction("reaction3", {"S3"}, {"S1"}, "k2*S3");
		}));
	}
	TEST(REMOVE_SPECIES_1)
	{
		CHECK(RunModelEditingTest(9, [](RoadRunner* rri) {
			rri->removeSpecies("S2", false);
			rri->addSpecies("S3", "compartment", 0.00030, "concentration", false);
			rri->addReaction("reaction1", { "S1" }, { "S3" }, "k1*S1", false);
			rri->addReaction("reaction2", {"S3"}, {"S1"}, "k2*S3", true);
		}));
	}
    
	TEST(READD_SPECIES)
	{
		clog << endl << "==== CHECK_READD_SPECIES ====" << endl << endl;
		for (int i = 40; i <= 40; i++)
		{
			if (!RunTestWithEdit("l2v4", i, removeAndReaddAllSpecies, "removeAndReaddAllSpecies"))
			{
				std::string failureMessage = "SBML Test " + to_string(i) + " failed";
				UnitTest::CurrentTest::Results()->OnTestFailure(*UnitTest::CurrentTest::Details(), failureMessage.c_str());
			}
		}
	}
	TEST(READD_REACTION)
	{
		clog << endl << "==== CHECK_READD_REACTION ====" << endl << endl;
		for (int i = 40; i <= 40; i++)
		{
			if (!RunTestWithEdit("l2v4", i, removeAndReaddAllReactions, "removeAndReaddAllReactions"))
			{
				std::string failureMessage = "SBML Test " + to_string(i) + " failed";
				UnitTest::CurrentTest::Results()->OnTestFailure(*UnitTest::CurrentTest::Details(), failureMessage.c_str());
			}
		}
	}
	TEST(READD_COMPARTMENTS)
	{
		clog << endl << "==== CHECK_READD_COMPARTMENTS ====" << endl << endl;
		for (int i = 30; i <= 40; i++)
		{
			if (!RunTestWithEdit("l2v4", i, removeAndReaddAllCompartments, "removeAndReaddAllCompartments"))
			{
				std::string failureMessage = "SBML Test " + to_string(i) + " failed";
				UnitTest::CurrentTest::Results()->OnTestFailure(*UnitTest::CurrentTest::Details(), failureMessage.c_str());
			}
		}
	}
}