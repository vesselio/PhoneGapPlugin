#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import <Marketo/Marketo.h>

@interface MarketoPlugin : CDVPlugin

- (void) initialize:(CDVInvokedUrlCommand*)command;
- (void) initializeMarketoPush:(CDVInvokedUrlCommand*)command;
- (void) onStart:(CDVInvokedUrlCommand*)command;
- (void) onStop:(CDVInvokedUrlCommand*)command;
- (void) settimeout:(CDVInvokedUrlCommand*)command;
- (void) reportaction:(CDVInvokedUrlCommand*)command;
- (void) associateLead:(CDVInvokedUrlCommand*)command;
- (void) setSecureSignature:(CDVInvokedUrlCommand*)command;
- (void) removeSecureSignature:(CDVInvokedUrlCommand*)command;
- (void) getDeviceId:(CDVInvokedUrlCommand*)command;
- (void) isSecureModeEnabled:(CDVInvokedUrlCommand*)command;

@end
