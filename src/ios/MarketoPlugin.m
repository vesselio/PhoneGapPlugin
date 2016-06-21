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


#import "MarketoPlugin.h"

@implementation MarketoPlugin

- (void)pluginInitialize {
    [super pluginInitialize];
    NSLog(@"MarketoSDK plugin");
}

- (void)onAppTerminate {
    NSLog(@"MarketoSDK, onAppTerminate");

}

- (void)onMemoryWarning {
    NSLog(@"MarketoSDK, onMemoryWarning");

}

- (void)onReset {
    NSLog(@"MarketoSDK, onReset");
}

- (void)dispose {
    NSLog(@"MarketoSDK, dispose");
}

//if action is initialize then it will initialize the marketo SDK
- (void)initialize:(CDVInvokedUrlCommand*)command
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CDVPluginResult* pluginResult = nil;
        NSString* munchkinID = [command.arguments objectAtIndex:0];
        NSString* secretKey = [command.arguments objectAtIndex:1];

        if([self isObjectnull: munchkinID] || [self isObjectnull: secretKey]){
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"munchkinID or secretKey was null"];
            return;
        }
        if (secretKey != nil && munchkinID !=nil) {
            [[Marketo sharedInstance] initializeWithMunchkinID:munchkinID appSecret:secretKey launchOptions:nil];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"munchkinID or secretKey was null"];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    });
}

//if action is initializeMarketoPush then it will initialize the Push notification service for the app
- (void) initializeMarketoPush:(CDVInvokedUrlCommand*)command{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector (registerUserNotificationSettings:)])
    {
#ifdef __IPHONE_8_0
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
#endif
    }
    else
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK ] callbackId:command.callbackId];
    });
}

//if action is resume then it will send the resume action to MarketoSDK
- (void)onStart:(CDVInvokedUrlCommand*)command
{
    // For iOS we handle it automatically. 
    // Added this call to keep it consistent with android.
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

//if action is pause then it will send the pause action to MarketoSDK
- (void)onStop:(CDVInvokedUrlCommand*)command
{
    // For iOS we handle it automatically. 
    // Added this call to keep it consistent with android.
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

//if action is settimeout then it will det the default time out to the value from json
- (void) settimeout:(CDVInvokedUrlCommand*)command{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CDVPluginResult* pluginResult = nil;
        if([self isObjectnull: [command.arguments objectAtIndex:0]]){
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"invalid timeout value ."];
            return;
        }
        NSNumber* timeOut = [NSNumber numberWithFloat:[[command.arguments objectAtIndex:0] floatValue]];
        if(timeOut!=0){
            [[Marketo sharedInstance] setTimeoutInterval:[timeOut intValue]];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"invalid timeout value ."];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    });

}

/**
* reportaction is a method which will create a MarketoActionMetaData object
* out of the JSONObject passed as a parameter
*
* @param JSONObject is a json data of Custom Action
*/

- (void) reportaction:(CDVInvokedUrlCommand*)command{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CDVPluginResult* pluginResult = nil;
        NSString* reportAction = [command.arguments objectAtIndex:0] ;
        NSString* reportData = [command.arguments objectAtIndex:1] ;
        NSError * error;
        if(![self isObjectnull:reportAction] && ![self isObjectnull:reportData]){
            NSDictionary *leadDictinary = [NSJSONSerialization JSONObjectWithData:[reportData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            if(error==nil && leadDictinary!=nil){
                MarketoActionMetaData *data =[[MarketoActionMetaData alloc]init];
                [data setType:[leadDictinary objectForKey:@"Action Type"]];
                [data setDetails:[leadDictinary objectForKey:@"Action Details"]];
                [data setMetric:[leadDictinary objectForKey:@"Action Metric"]];
                [data setLength:[leadDictinary objectForKey:@"Action Length"]];
                [[Marketo sharedInstance] reportAction:reportAction withMetaData:data];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            }else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Can not report data, issue with report data"];
            }
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Can not report data, issue with report data"];
        }
    });
}

/**
* associatelead is a method which will create a MarketoLead object
* out of the JSONObject passed as a parameter
*
* @param CDVInvokedUrlCommand contains json data related to lead
*/
- (void) associateLead:(CDVInvokedUrlCommand*)command{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CDVPluginResult* pluginResult = nil;
        NSString* leadData = [command.arguments objectAtIndex:0] ;
        NSError * error;
        if([self isObjectnull:leadData]){
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to associate lead"];
            return ;
        }
        NSDictionary *leadDictinary = [NSJSONSerialization JSONObjectWithData:[leadData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if(error==nil && leadDictinary!=nil){
            MarketoLead * lead=[[MarketoLead alloc] init];
            [lead setValue:leadDictinary forKeyPath:@"userAttributes"];
            [[Marketo sharedInstance] associateLead:lead];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to associate lead"];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    });
}

- (void) setSecureSignature:(CDVInvokedUrlCommand*)command{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CDVPluginResult* pluginResult = nil;
        NSString* accessKey = [command.arguments objectAtIndex:0] ;
        NSString* signature = [command.arguments objectAtIndex:1] ;
        NSString* email = [command.arguments objectAtIndex:2] ;
        NSString* timestamp = [command.arguments objectAtIndex:3] ;
        if([self isObjectnull:accessKey] || [self isObjectnull:signature] || [self isObjectnull:email] || [self isObjectnull:timestamp]){
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid MKTSecuritySignature."];
        }
        MKTSecuritySignature * mktSecuritySignature = [[MKTSecuritySignature alloc] initWithAccessKey:accessKey signature:signature timestamp:timestamp email:email];
        if(mktSecuritySignature!=nil ){
            [[Marketo sharedInstance] setSecureSignature:mktSecuritySignature];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid MKTSecuritySignature."];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    });
}

- (void) removeSecureSignature:(CDVInvokedUrlCommand*)command{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[Marketo sharedInstance] removeSecureSignature];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK ] callbackId:command.callbackId];
        });
}
- (void) getDeviceId:(CDVInvokedUrlCommand*)command{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      NSString * deviceId=  [[Marketo sharedInstance] getDeviceId];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:deviceId];;
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    });
}

- (void) isSecureModeEnabled:(CDVInvokedUrlCommand*)command{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isSecureModeEnabled =  [[Marketo sharedInstance] isSecureModeEnabled];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:isSecureModeEnabled?1:0];;
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    });
}

-(BOOL) isObjectnull:(id )value{
    if([value isEqual:[NSNull null] ] || !value){
        return YES;
    }
    return NO;
}
@end
