#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>


@interface VesselPlugin : CDVPlugin

- (void)initialize:(CDVInvokedUrlCommand*)command;
- (void)reloadTest:(CDVInvokedUrlCommand*)command;
- (void)resume:(CDVInvokedUrlCommand*)command;
- (void)pause:(CDVInvokedUrlCommand*)command;
- (void)startSession:(CDVInvokedUrlCommand*)command;
- (void)endSession:(CDVInvokedUrlCommand*)command;
- (void)checkPointVisited:(CDVInvokedUrlCommand*)command;
- (void)setABListener:(CDVInvokedUrlCommand*)command;
- (void)getValue:(CDVInvokedUrlCommand*)command;

@end