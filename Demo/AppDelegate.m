//
//  AppDelegate.m
//  Demo
//
//  Created by he15his on 15/10/17.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import <LeanCloudSocial/AVOSCloudSNS.h>
#import "JDNewestObject.h"

#define kAVOSCloudAppID  @"i5VaSBHNe4VRt2BOD0K1QfTm"
#define kAVOSCloudAppKey @"7FEb0I8jheW5W6lL1poOwFfj"

#define kQQAppID  @"100512940"
#define kQQAppKey @"afbfdff94b95a2fb8fe58a8e24c4ba5f"

#define kWechatAppID  @"wxa3eacc1c86a717bc"
#define kWechatppKey @"b5bf245970b2a451fb8cebf8a6dff0c1"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [JDNewestObject registerSubclass];
    [AVOSCloud setApplicationId:kAVOSCloudAppID
                      clientKey:kAVOSCloudAppKey];
    //注册登录key
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:kQQAppID andAppSecret:kQQAppKey andRedirectURI:nil];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSWeiXin withAppKey:kWechatAppID andAppSecret:kWechatppKey andRedirectURI:nil];
    [AVOSCloud setAllLogsEnabled:YES];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [AVOSCloudSNS handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
