//
//  AppDelegate+Marketo.m
//  PhoneGapSample
//
//  Created by Rohit Mahto on 16/06/16.
//
//

#import "AppDelegate+Marketo.h"
#import <Marketo/Marketo.h>
@implementation AppDelegate (Marketo)


// To handle deeplink received from Marketo.
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[Marketo sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // register to receive notifications
    [application registerForRemoteNotifications];
}

#endif

// Will update the Push Token received from apns.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[Marketo sharedInstance] registerPushDeviceToken:deviceToken];
}

// To handle Push notifications received from marketo.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[Marketo sharedInstance] handlePushNotification:userInfo];
}

// To handle Local notifications received from marketo.
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[Marketo sharedInstance] application:application didReceiveLocalNotification:notification];
}



@end
