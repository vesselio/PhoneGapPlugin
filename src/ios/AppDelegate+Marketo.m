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

#define XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8    __has_include(<UserNotifications/UserNotifications.h>)

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
#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
        completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"Local notification request authorization succeeded!");
            }
        }];
#endif
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

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Unable to get push token ******-> %@", error);
}

#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8

// The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog(@"Notification is triggered");

    // You can either present alert, sound or increase badge while the app is in foreground too with iOS 10
    // Must be called when finished, when you do not want foreground show, pass UNNotificationPresentationOptionNone to the completionHandler()
    completionHandler(UNNotificationPresentationOptionAlert);
    // completionHandler(UNNotificationPresentationOptionBadge);
    // completionHandler(UNNotificationPresentationOptionSound);
}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)())completionHandler {
    [[Marketo sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
//    completionHandler();
}

//  Unlike the application:didReceiveRemoteNotification: method, which is called only when your app is running in the foreground, the system calls this method when your app is running in the foreground or background. 

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    [[Marketo sharedInstance] handlePushNotification:userInfo];
}

#endif


@end
