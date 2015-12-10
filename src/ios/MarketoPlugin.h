#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import <Marketo/Marketo.h>

@interface MarketoPlugin : CDVPlugin

- (void)initialize:(CDVInvokedUrlCommand*)command;
- (void)resume:(CDVInvokedUrlCommand*)command;
- (void)pause:(CDVInvokedUrlCommand*)command;
- (void) settimeoutinterval:(CDVInvokedUrlCommand*)command;
- (void) reportaction:(CDVInvokedUrlCommand*)command;
- (void) associatelead:(CDVInvokedUrlCommand*)command;
- (void) setSecureSignature:(CDVInvokedUrlCommand*)command;
- (void) removeSecureSignature:(CDVInvokedUrlCommand*)command;
- (void) getDeviceId:(CDVInvokedUrlCommand*)command;

@end
