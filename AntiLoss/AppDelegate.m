//
//  AppDelegate.m
//  AntiLoss
//
//  Created by cbuu on 15/11/16.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "WXAPI/WXApi.h"
#import "manager/WXApiManager.h"
#import "manager/BTManager.h"
#import "manager/UserManager.h"
#import "JSONParseUtil.h"
#import <QMapKit/QMapKit.h>
@interface AppDelegate ()<WXApiManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
//    
//    UIViewController * vc = [LoginViewController new];
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
//    
//    [self.window makeKeyAndVisible];
    
    //[Bmob registerWithAppKey:@"ffaadab477c3600e3cead7cc64d3173f"];
    [QMapServices sharedServices].apiKey = @"V2MBZ-FD4KF-EKWJH-J7WM4-QSOF2-5PB57";
    [WXApi registerApp:@"wx99c248fdf022077c"];
    [WXApiManager sharedManager].delegate = self;
    [UserManager getInstance].mode = USER_MODE;
    
    [self setUpBlueTooth];
    return YES;
}

- (void)setUpBlueTooth
{
    [[BTManager getInstance] setUp];
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
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request
{
    WXMediaMessage * message = request.message;
    WXAppExtendObject * obj = message.mediaObject;
    NSString * deviceJson = obj.extInfo;
    NSDictionary * deviceInfo = [JSONParseUtil deviceFromJson:deviceJson];
    OpenCache * cache = [[OpenCache alloc]init];
    cache.deviceName = deviceInfo[@"deviceName"];
    cache.deviceMac = deviceInfo[@"deviceMac"];
    cache.imageID = deviceInfo[@"image"];
    [WXApiManager sharedManager].cache = cache;
    [UserManager getInstance].mode = HELP_MODE;
}



@end
