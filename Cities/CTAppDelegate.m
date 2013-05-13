//
//  CTAppDelegate.m
//  Cities
//
//  Created by  on 2013/4/6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CTAppDelegate.h"
#import "CTDataSource.h"

@implementation CTAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    //UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    
    [tabBar setTintColor:[UIColor redColor]];
    //tabBarItem1.title = @"Home";

    
    return YES;
}
							
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[CTDataSource sharedDataSource] cleanCache];
}

@end
