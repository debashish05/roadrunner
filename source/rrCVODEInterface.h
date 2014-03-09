#ifndef rrCvodeInterfaceH
#define rrCvodeInterfaceH

#include "Integrator.h"
#include "rrRoadRunnerOptions.h"
#include "Configurable.h"

#include <string>
#include <vector>

/**
 * CVode vector struct
 */
typedef struct _generic_N_Vector *N_Vector;

namespace rr
{

using std::string;

class ExecutableModel;
class RoadRunner;

/**
 * @internal
 * The integrator implemented by CVODE.
 */
class CvodeInterface : public Integrator, public Configurable
{
public:
    CvodeInterface(ExecutableModel* oModel, const SimulateOptions* options);

    virtual ~CvodeInterface();

    /**
     * creates a new xml element that represent the current state of this
     * Configurable object and all if its child objects.
     */
    virtual _xmlNode *createConfigNode();

    /**
     * Given an xml element, the Configurable object should pick its needed
     * values that are stored in the element and use them to set its
     * internal configuration state.
     */
    virtual void loadConfig(const _xmlDoc* doc);


    /**
     * set the options the integrator will use.
     */
    virtual void setSimulateOptions(const SimulateOptions* options);


    void testRootsAtInitialTime();
    bool haveVariables();

    double oneStep(double timeStart, double hstep);
    void assignNewVector(ExecutableModel *model);
    void assignNewVector(ExecutableModel *oModel, bool bAssignNewTolerances);

    // Restart the simulation using a different initial condition
    void                        reStart(double timeStart, ExecutableModel* model);

private:

    double                      mMaxStep;
    int                         mRootCount;
    int                         mCount;

    static const int            mDefaultMaxNumSteps;


    int                         mStateVectorSize;
    N_Vector                    mStateVector;

    N_Vector                    mAbstolArray;

    void*                       mCVODE_Memory;

    static const int            mDefaultMaxAdamsOrder;
    static const int            mDefaultMaxBDFOrder;
    double                      mLastTimeValue;
    double                      mLastEvent;
    ExecutableModel*            mModel;
    int                         mOneStepCount;
    bool                        mFollowEvents;

    /**
     * copy the values from the cvode state vector into the executable model.
     */
    void assignResultsToModel();


    void                        assignPendingEvents(double timeEnd, double tout);


    void                        handleRootsForTime(double timeEnd,
                                    std::vector<unsigned char> &previousEventStatus);

    int                         rootInit(int numRoots);
    int                         reInit (double t0);
    int                         allocateCvodeMem ();

    /**
     * Set up the cvode state vector size and various other cvode
     * init tasks. Specific to the model.
     *
     * Only called once
     */
    void initializeCVODEInterface(ExecutableModel *oModel);

    void                        setAbsTolerance(int index, double dValue);

    int                         mMaxAdamsOrder;
    int                         mMaxBDFOrder;
    double                      mInitStep;
    double                      mMinStep;

    int                         mMaxNumSteps;


    /**
     * return the options rel tol if acceptible, otherwise, use
     * the cvode defaults.
     */
    double getRelativeTolerance();

    /**
     * return the options abs tol if acceptable, otherwise, use
     * default values.
     */
    double getAbsoluteTolerence();

    /**
     * pointer to an options struct, this is typically
     * owned by the RoadRunner object.
     */
    SimulateOptions options;

    /**
     * get state vector rate function called by cvode.
     */
    friend void ModelFcn(int n, double time, double* y, double* ydot, void* userData);

    /**
     * event status function called by cvode.
     */
    friend void EventFcn(double time, double* y, double* gdot, void* userData);

    static void* createCvode(const SimulateOptions *options);

};
}

#endif
