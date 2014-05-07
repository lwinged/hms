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
#import "AFHTTPSessionManager.h"

#import "HMSMasterViewController.h"
#import "HMSSidePanelController.h"


@implementation HMSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //NSLog(@"start");
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //Tracy - text in the status bar turn into white
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *task = [manager GET:@"http://vm-0.lwinged.kd.io/info.json" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSError *e = nil;
        
         NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
        
        _sharedHotels = [HMSModelHelper createListOfHotels:jsonArray];
  
        HMSSidePanelController * panel = (HMSSidePanelController *) self.window.rootViewController;
        UINavigationController *nav = (UINavigationController *) panel.centerPanel;
        
       // NSLog(@"shared hotel %@", _sharedHotels);

        if ([nav.viewControllers[0] isKindOfClass:[HMSMasterViewController class]])
            {
                HMSMasterViewController * masterViewController =  nav.viewControllers[0];
                [masterViewController reloadDataTableView:YES];
            }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
       // NSLog(@"MyError: %@", error);
    }];
    
    [task resume];
    
  
    _saved = YES;
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *favoritesPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"favorites.plist"];
    NSString *searchPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"search.plist"];
    NSString *currentPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"current.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    
    if ([fileManager fileExistsAtPath:searchPath] == TRUE)
        _sharedHotels = [NSKeyedUnarchiver unarchiveObjectWithFile:searchPath];
    
    if ([fileManager fileExistsAtPath:favoritesPath] == FALSE)
        _favoritesHotels = [[NSMutableArray alloc] init];
    else
        _favoritesHotels = [NSKeyedUnarchiver unarchiveObjectWithFile:favoritesPath];
    
    if ([fileManager fileExistsAtPath:currentPath] == FALSE)
        _searchHotel = @"France";
    else
        _searchHotel = [NSKeyedUnarchiver unarchiveObjectWithFile:currentPath];
 
    
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is 	about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use his method to pause the game.
    
    if (_saved)
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *favoritesPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"favorites.plist"];
        NSString *searchPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"search.plist"];
        NSString *currentPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"current.plist"];
        
        [NSKeyedArchiver archiveRootObject:_favoritesHotels toFile:favoritesPath];
        [NSKeyedArchiver archiveRootObject:_sharedHotels toFile:searchPath];
        [NSKeyedArchiver archiveRootObject:_searchHotel toFile:currentPath];

        _saved = NO;
    }


    //NSLog(@"all app pause kill");
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if (_saved)
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *favoritesPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"favorites.plist"];
        NSString *searchPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"search.plist"];
        NSString *currentPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"current.plist"];

        
        [NSKeyedArchiver archiveRootObject:_favoritesHotels toFile:favoritesPath];
        [NSKeyedArchiver archiveRootObject:_sharedHotels toFile:searchPath];
        [NSKeyedArchiver archiveRootObject:_searchHotel toFile:currentPath];

        _saved = NO;
    }
     //   NSLog(@"background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
       // NSLog(@"foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      //NSLog(@"active");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

   // NSLog(@"finish");
}

@end
