//
//  HMSAppDelegate.m
//  HMS
//
//  Created by flav on 19/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSAppDelegate.h"
#import "HMSModelHelper.h"
#import "HMSHotel.h"

@implementation HMSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
   // NSLog(@"start");

    NSString *master = @"[{\"name\":\"Hotel California\", \"country\":\"USA\", \"city\":\"California\", \"description\":\"Such a lovely place\", \"stars\":\"4\", \"rooms\":[{\"name\":\"King Size\", \"type\":\"deluxe\", \"photos\":[\"hotel4\" ]},{\"name\":\"Queen Size\", \"type\":\"deluxe\", \"photos\":[\"hotel5\"]},{\"name\":\"Prince Size\", \"type\":\"deluxe\", \"photos\":[]}], \"photos\":[\"hotel1\", \"hotel2\", \"hotel3\"],\"comments\":[{\"author\":\"Tevy\", \"comments\":\"Such a lovely face\", \"date\":\"13/04/14\" },{\"author\":\"Timmy\", \"comments\":\"Plenty of room at the hotel California.\", \"date\":\"12/05/14\" },{\"author\":\"Tommy\", \"comments\":\"Any time of year, you can find it here!\", \"date\":\"08/04/15\" }], \"latitude\":5, \"longitude\":4},{\"name\":\"Hotel Winner\", \"country\":\"France\", \"city\":\"Paris\", \"description\":\"Nice and ...nice.\", \"stars\":\"3\", \"rooms\":[{\"name\":\"Room 01\", \"type\":\"normal\", \"photos\":[\"hotel5\"]}], \"photos\":[\"hotel1\"], \"comments\":[{\"author\":\"Nel\", \"comments\":\"This is a really nice place. Really...\", \"date\":\"16/11/14\" }], \"latitude\":5, \"longitude\":4},{\"name\":\"Hotel Winner2\", \"country\":\"France\", \"city\":\"Paris\",\"description\":\"Nice and ...nice.\", \"stars\":\"3\", \"rooms\":[{\"name\":\"Room 01\", \"type\":\"normal\", \"photos\":[]}], \"photos\":[\"hotel1\"], \"comments\":[{\"author\":\"Nel\", \"comments\":\"This is a really nice place. Really...\", \"date\":\"16/11/14\" }], \"latitude\":5, \"longitude\":4},{\"name\":\"Hotel Scheisse\", \"country\":\"Germany\", \"city\":\"Berlin\", \"description\":\"Jawohl!!!\", \"stars\":\"5\", \"rooms\":[{\"name\":\"Banana\", \"type\":\"deluxe\", \"photos\":[\"hotel1\"]}], \"photos\":[\"hotel1\"], \"comments\":[{\"author\":\"Lex\", \"comments\":\"Ja, ja! This place is nice and comfy. Could be better without that iron wall isolating this hotel from the city. But Ich bin ein Berliner, huh?\", \"date\":\"11/07/14\" },{\"author\":\"Lux\", \"comments\":\"Ich bin eine schone badekappe!!\", \"date\":\"12/07/14\" }], \"latitude\":5, \"longitude\":4}]";
    
    NSError *e = nil;
    NSArray *myTab = [NSJSONSerialization JSONObjectWithData:[master dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&e];
    
    _sharedHotels = [HMSModelHelper createListOfHotels:myTab];
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
