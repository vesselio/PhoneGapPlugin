//
//  VesselAB.h
//  Vessel
//
//  Copyright (c) 2013 Vessel. All rights reserved.
//


/** The variation returned by the Vessel server is one of the values from VesselABTestVariation enumeration.
 */
typedef NS_ENUM(NSInteger, VesselABTestVariation) {
    /** Unknown variation */
    VesselABTestVariationUnknown = 0,
    /** Variation A */
    VesselABTestVariationA,
    /** Variation B */
    VesselABTestVariationB,
    /** Variation C */
    VesselABTestVariationC,
    /** Variation D */
    VesselABTestVariationD,
    /** Variation E */
    VesselABTestVariationE,
};

/** The current Vessel AB test status has one of the values from VesselABTestStatus enumeration.
 */
typedef NS_ENUM(NSInteger, VesselABTestStatus) {
    /** Test not loaded yet */
    VesselABTestNotInitiated = 0,
    /** Test is in the process of loading */
    VesselABTestLoading,
    /** Test is loaded */
    VesselABTestLoaded,
    /** Test isn't available */
    VesselABTestNotAvailable
};

/** VesselABTestChangedNotification is posted when a test parameters change on the server side.
 */
extern NSString *const VesselABTestChangedNotification;

/** The userInfo dictionary associated with the VesselABTestLoadStatusChangedNotification has the current AB test status which can be accessed by VesselABTestLoadStatusKey string.
 */
extern NSString *const VesselABTestLoadStatusKey;


/** The VesselAB class is used to access variation variables, report checkpoints and sessions.
 */
@interface VesselAB : NSObject

/** The variation returned by the Vessel server. The property has one of the values from the VesselABTestVariation enumeration.
 */
@property (readonly, atomic) VesselABTestVariation variation;

/** The current Vessel AB test status. The property has one of the values from the VesselABTestStatus enumeration.
 */
@property (readonly, atomic) VesselABTestStatus testLoadStatus;

/** Current loaded test name
 */
@property (readonly, atomic) NSString *testName;

/** Current loaded test ID
 */
@property (readonly, atomic) NSNumber *testID;

/** Returns a singleton that is an instance of VesselAB SDK.
 @return Singleton instance of class VesselAB.
 */
+ (VesselAB*) sharedInstance;

/** Returns a variation returned by the Vessel server.
 
 @param success This block is called when the test is retrieved successfully from the Vessel server.
 @param failure This block is called when the test fails to load.
 */
+ (void) getTestWithSuccessBlock:(void (^)(NSString *testName, VesselABTestVariation variation))success failureBlock:(void (^)())failure;

/** Returns the variation for a particular test name. If the test assigned to the device doesn't match testName then VesselABTestVariationUnknown is returned.
 @param testName variation assigned to the test
 */
+ (VesselABTestVariation) variationForTestName:(NSString*)testName;

/** Returns the variation for a particular test ID. If the test assigned to the device doesn't match test ID then VesselABTestVariationUnknown is returned.
 @param testID variation assigned to the test
 */
+ (VesselABTestVariation) variationForTestID:(int)testID;

/** Forces the SDK to get the latest AB test parameters from Vessel.
 */
+ (void) forceABTestUpdate;

/** Loads the disk cached test into memory
 */
+ (void) reloadTest;

/** Returns the value associated with a variation variable. If there is none associated or the test failed to load then the defaultValue is returned.
 
 @param variationVariable The variation variable whose value is to the retrieved.
 @param defaultValue In case there is no variation variable named variationVariable or if the test failed to load then the defaultValue is returned.
 */
+ (NSString*) valueForVariationVariable:(NSString*)variationVariable defaultValue:(NSString*)defaultValue;

/** Reports a checkpoint to the Vessel server
 
 @param checkpointName The checkpoint to be reported.
 */
+ (void) checkpointVisited:(NSString*)checkpointName;

/** Starts a new session.
 
 @param sessionName The session that is to be started.
 */
+ (void) startSession:(NSString*)sessionName;

/** Ends a started session.
 
 @param sessionName The session to be ended. Note that the session has to be started to end it.
 */
+ (void) endSession:(NSString*)sessionName;

/** Ends all sessions that have been started but haven't been ended yet.
 */
+ (void) endAllSessions;

/** Discards all sessions that have been started but haven't been ended yet.
 */
+ (void) discardAllSessions;

/** Returns the user identifier set for the sessions and checkpoints.
 */
+ (NSString*) userId;

/** Sets a user identifier for the sessions and checkpoints.
 
@param userId A string to be associated with sessions and checkpoints.
 */
+ (void) setUserId:(NSString*)userId;

@end
