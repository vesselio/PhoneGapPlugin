/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "VesselPlugin.h"
#import <Vessel/Vessel.h>
#import <Vessel/VesselAB.h>
/* #import "CDV.h"
*/
@implementation VesselPlugin

 - (void)pluginInitialize {
    [super pluginInitialize];
    NSLog(@"VesselSDK plugin");
}


- (void)onAppTerminate {
    NSLog(@"VesselSDK, onAppTerminate");

}

- (void)onMemoryWarning {
    NSLog(@"VesselSDK, onMemoryWarning");

}

- (void)onReset {
    NSLog(@"VesselSDK, onReset");
}

- (void)dispose {
    NSLog(@"VesselSDK, dispose");
}

- (void)initialize:(CDVInvokedUrlCommand*)command
{

    CDVPluginResult* pluginResult = nil;
    NSString* secretKey = [command.arguments objectAtIndex:0];

    if (secretKey != nil) {
        [Vessel initializeWithAppSecret:secretKey];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"secretKey was null"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)reloadTest:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    [VesselAB reloadTest];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)resume:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)pause:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)startSession:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* sessionName = [command.arguments objectAtIndex:0];

    if (sessionName != nil) {
        [VesselAB startSession:sessionName];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"sessionName was null"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)endSession:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* sessionName = [command.arguments objectAtIndex:0];

    if (sessionName != nil) {
        [VesselAB endSession:sessionName];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"sessionName was null"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)checkPointVisited:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* checkpointVisited = [command.arguments objectAtIndex:0];

    if (checkpointVisited != nil) {
        [VesselAB checkpointVisited:checkpointVisited];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"checkpointVisited was null"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)setABListener:(CDVInvokedUrlCommand*)command
{
    __block  NSString *testVariation = nil;
    __block CDVPluginResult* pluginResult = nil;
    
    [VesselAB getTestWithSuccessBlock:^(NSString *testName, VesselABTestVariation variation) {
        testVariation = [self formatTypeToString:variation];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //Call your function or whatever work that needs to be done on a background thread
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:testVariation];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                
            });
        });
        
    } failureBlock:^ {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //Call your function or whatever work that needs to be done on a background thread
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Test is not available"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                
            });
        });
        
    }];
}


- (void)getValue:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* key = [command.arguments objectAtIndex:0];
    NSString* defaultValue = [command.arguments objectAtIndex:1];
    NSString* value = [VesselAB valueForVariationVariable:key defaultValue:defaultValue];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (NSString*)formatTypeToString:(VesselABTestVariation)formatType {
    NSString *result = nil;

    switch(formatType) {
        case VesselABTestVariationA:
            result = @"VesselABTestVariationA";
            break;
        case VesselABTestVariationB:
            result = @"VesselABTestVariationB";
            break;
        case VesselABTestVariationC:
            result = @"VesselABTestVariationC";
            break;
        case VesselABTestVariationD:
            result = @"VesselABTestVariationD";
            break;
        case VesselABTestVariationE:
            result = @"VesselABTestVariationE";
            break;
        default:
            result = @"VesselABTestVariationUnknown";
    }

    return result;
}

@end
