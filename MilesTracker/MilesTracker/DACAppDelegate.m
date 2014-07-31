//
//  DACAppDelegate.m
//  MilesTracker
//
//  Created by Mac User on 6/26/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "DACAppDelegate.h"
#import "DACViewController.h"
#import "CurrentTripsTableViewController.h"
#import "DACMenuController.h"
#import "Vehicles.h"
#import <Parse/Parse.h>
#import <FlurrySDK/Flurry.h>
#import <Analytics/Analytics.h>
#import <LSNewsletterInvite/LSNewsletterInvite.h>
#import <IOSPlot/PCPieChart.h>
#import "Trip.h"

@implementation DACAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        
//    [LSNewsletterInvite appLaunched:YES viewController:viewController andSettings:nil];
    [SEGAnalytics setupWithConfiguration:[SEGAnalyticsConfiguration configurationWithWriteKey:@"YOUR_WRITE_KEY"]];
    [Vehicles registerSubclass];
    [Trip registerSubclass];

    
    // Override point for customization after application launch.
    [Parse setApplicationId:@"YWyvnZvxEgzUUzVHI4aR5zWQ4yjxchX3HYyYxeU4"
                  clientKey:@"LwBMTp0SePIV0rKqNU3yFjMEJcVcDv3muQSCUWbw"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
//     setTintColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:204/255.0f alpha:1.0]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTintColor:[UIColor orangeColor]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:17/255.0f green:69/255.0f blue:114/255.0f alpha:1.0]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:204/255.0f alpha:1.0]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:17/255.0f green:69/255.0f blue:114/255.0f alpha:1.0]];
    UIView *goldenView = [[UIView alloc] init];
    goldenView.backgroundColor = [UIColor colorWithRed:247/255.0f green:226/255.0f blue:111/255.0f alpha:1.0];
    [[UITableViewCell appearance] setSelectedBackgroundView:goldenView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor orangeColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"Avenir-Light" size:20]
                                                           }];
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
