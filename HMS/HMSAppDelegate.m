//
//  HMSAppDelegate.m
//  HMS
//
//  Created by flav on 19/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSAppDelegate.h"
#import "HMSHotel.h"

@implementation HMSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
   // NSLog(@"start");

    HMSHotel *hotel = [[HMSHotel alloc] initWithParams:@"Mon hotel" :@"France" :@"Paris" :@"hotel de Paris" :3 :41.002371 :-102.052066];
    [hotel.photos addObject:@"hotel1"];
    [hotel.photos addObject:@"hotel2"];
    [hotel.photos addObject:@"hotel3"];
    
    HMSRoom * room = [[HMSRoom alloc] initWithParams:@"ma chambre" :@"Deluxe"];
    [room.photos addObject:@"hotel4"];
    
    HMSRoom * room1 = [[HMSRoom alloc] initWithParams:@"ma room" :@"Normal"];
    [room1.photos addObject:@"hotel5"];
    
    [hotel addRoom:room];
    [hotel addRoom:room1];
    
    
    HMSComment * comment = [[HMSComment alloc] initWithParams:@"moi" :@"l'hotel est tres bien"];
    HMSComment * comment1 = [[HMSComment alloc] initWithParams:@"pas moi" :@"l'hotel n'est pas tres bien"];
    
    [hotel.comments addObject:comment];
    [hotel.comments addObject:comment1];
    
    HMSHotel *hotel1 = [[HMSHotel alloc] initWithParams:@"Mon hotel 2 " :@"France" :@"Pontoise" :@"hotel de Pontoise" :3 :21.002371 :-102.052066];
    HMSHotel *hotel2 = [[HMSHotel alloc] initWithParams:@"Mon hotel 3 " :@"France" :@"Oaris" :@"hotel de Oaris" :3 :41.002371 :-10.052066];
    HMSHotel *hotel3 = [[HMSHotel alloc] initWithParams:@"Aon hotel 4 " :@"France" :@"Pontoise" :@"hotel de Oontoise" :3 :4.002371 :-12.052066];
    
   
    _sharedHotels = [[NSArray alloc] initWithObjects:hotel, hotel1, hotel2, hotel3, nil];
    _favoritesHotels = [[NSMutableArray alloc] init];

    //[NSKeyedArchiver archiveRootObject:self.item toFile:@"favorites"];
    //    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:@"favorites"];
    //    NSLog(@"%@", obj);
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"all app pause kill");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
        NSLog(@"background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        NSLog(@"foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      NSLog(@"active");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    NSLog(@"finish");
}

@end
