//
//  AppDelegate.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/15.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    CommonViewController *commonVC = [[CommonViewController alloc]init];
    UINavigationController *commonNavi = [[UINavigationController alloc]initWithRootViewController:commonVC];
    
    HealthViewController *healthVC = [[HealthViewController alloc]init];
    UINavigationController *healthNavi = [[UINavigationController alloc]initWithRootViewController:healthVC];
    
    PPGViewController *ppGVC = [[PPGViewController alloc]init];
    UINavigationController *ppGNavi = [[UINavigationController alloc]initWithRootViewController:ppGVC];
    
    DiaryViewController *diaryVC = [[DiaryViewController alloc]init];
    UINavigationController *diaryNavi = [[UINavigationController alloc]initWithRootViewController:diaryVC];
    
    
    
    NSArray *titleArr = @[@"普通",@"健康",@"测心跳",@"日记"];
    SLLYMenuViewController *menuVC = [[SLLYMenuViewController alloc]initWithFrontView:commonNavi andButtonTitleArr:titleArr];
    menuVC.viewControllersArr = @[commonNavi,healthNavi,ppGNavi,diaryNavi];
    UINavigationController *menuNavi = [[UINavigationController alloc]initWithRootViewController:menuVC];
    
    self.window.rootViewController = menuNavi;
    [self.window makeKeyAndVisible];
  
    return YES;
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
