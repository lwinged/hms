//
//  HMSAppDelegate.h
//  HMS
//
//  Created by flav on 19/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) NSArray * sharedHotels;
@property (strong, nonatomic) NSMutableArray * favoritesHotels;
@property (assign, nonatomic) BOOL saved;

@end
