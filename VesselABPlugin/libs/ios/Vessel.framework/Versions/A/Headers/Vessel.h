//
//  Vessel.h
//  Vessel
//
//  Copyright (c) 2013 Vessel. All rights reserved.
//

#import <Vessel/VesselAB.h>

/** The Vessel class is used to initialize the Vessel SDK for AB Testing. 
 */

@interface Vessel : NSObject

/** Returns the App Secret used to initialize Vessel SDK.
 */
@property (nonatomic, readonly) NSString *appSecret;

/** Returns a singleton that is an instance of Vessel SDK.
 @return Singleton instance of class Vessel.
*/
+ (Vessel*) sharedInstance;


/** Initializes Vessel SDK. This method should be called before calling any other Vessel SDK method.
 
 @param appSecret An app secret used to initialize the app.
 
 @return Returns a BOOL value that indicates whether the initialization was successful.
*/
+ (BOOL) initializeWithAppSecret:(NSString*)appSecret;

@end
