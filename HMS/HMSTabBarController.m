//
//  HMSTabBarController.m
//  HMS
//
//  Created by flav on 04/04/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSTabBarController.h"
#import "HMSHotelViewController.h"
#import "HMSCommentViewController.h"
#import "HMSAppDelegate.h"

@interface HMSTabBarController ()
{
    HMSAppDelegate *appDelegate;
}

@end

@implementation HMSTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self == %@", self.item];
    NSArray *filteredArray = [appDelegate.favoritesHotels filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count > 0)
        self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.title = [self.item name];
    
    HMSHotelViewController * hotelViewController = self.viewControllers[0];
    [hotelViewController setDetailItem:self.item];
    
    HMSHotel *commentView = (HMSHotel *) self.item;
    HMSCommentViewController * commentViewController = self.viewControllers[1];
   // [commentViewController setCommentItem:commentView.comments];
    [commentViewController setCommentItem:commentView.comments];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveHotel:(id)sender
{
    NSLog(@"Hotel saved");
    
    [appDelegate.favoritesHotels addObject:self.item];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
