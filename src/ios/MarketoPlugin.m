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

- (void)initialize:(CDVInvokedUrlCommand*)command
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CDVPluginResult* pluginResult = nil;
        NSString* munchkinID = [command.arguments objectAtIndex:0];
        NSString* secretKey = [command.arguments objectAtIndex:1];

        if (secretKey != nil && munchkinID !=nil) {
            [[Marketo sharedInstance] initializeWithMunchkinID:munchkinID appSecret:secretKey launchOptions:nil];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"munchkinID or secretKey was null"];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    });
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

- (void) settimeoutinterval:(CDVInvokedUrlCommand*)command{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CDVPluginResult* pluginResult = nil;
        NSNumber* timeOut = [NSNumber numberWithFloat:[[command.arguments objectAtIndex:0] floatValue]];
        if(timeOut!=0){
            [[Marketo sharedInstance] setTimeoutInterval:[timeOut intValue]];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    });

}

- (void) reportaction:(CDVInvokedUrlCommand*)command{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CDVPluginResult* pluginResult = nil;
        NSString* reportAction = [command.arguments objectAtIndex:0] ;
        NSString* reportData = [command.arguments objectAtIndex:1] ;
        NSError * error;
        if((reportAction!=nil && reportAction.length!=0) || (reportData!=nil && reportData.length!=0)){
            NSDictionary *leadDictinary = [NSJSONSerialization JSONObjectWithData:[reportData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            if(error!=nil || leadDictinary!=nil){
                MarketoActionMetaData *data =[[MarketoActionMetaData alloc]init];
                [data setValue:[leadDictinary objectForKey:@"data"] forKeyPath:@"actionMetadata"];
                [[Marketo sharedInstance] reportAction:[leadDictinary objectForKey:@"event"] withMetaData:data];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            }else{
                NSLog(@"Can not report data , issue with json data");
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            }
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }else{
            NSLog(@"Can not report data , issue with report data");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
    });
}

- (void) associatelead:(CDVInvokedUrlCommand*)command{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CDVPluginResult* pluginResult = nil;
        NSString* leadData = [command.arguments objectAtIndex:0] ;
        NSError * error;
        NSDictionary *leadDictinary = [NSJSONSerialization JSONObjectWithData:[leadData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if(error!=nil || leadDictinary!=nil){
            MarketoLead * lead=[[MarketoLead alloc] init];
            [lead setValue:leadDictinary forKeyPath:@"userAttributes"];
            [[Marketo sharedInstance] associateLead:lead];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }else{
            NSLog(@"Can not parce lead , issue with json data");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    });
}




@end
