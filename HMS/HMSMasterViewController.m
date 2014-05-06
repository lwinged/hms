//
//  HMSMasterViewController.m
//  HMS
//
//  Created by flav on 19/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSMasterViewController.h"
#import "HMSDetailViewController.h"
#import "HMSHelperIndexedList.h"
#import "HMSHotel.h"
#import "HMSAppDelegate.h"

#import "HMSColorElement.h"

@interface HMSMasterViewController () {
    NSArray * _objects;
    NSArray *indices;
    NSArray * _hotels;
    HMSAppDelegate *appDelegate;
}
@end

@implementation HMSMasterViewController

- (void)awakeFromNib //TRACY - NAVIGATIONBAR AND TABBAR
{
    [super awakeFromNib];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UITabBar appearance] setTintColor: [UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor: [HMSColorElement hms_darkRedColor]];
   
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Menlo" size:17.0]];
    
    [[UINavigationBar appearance] setTintColor: [UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:19.0]}];
    [[UINavigationBar appearance] setBarTintColor: [HMSColorElement hms_darkRedColor]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; //remove separator line
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Search";
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    _hotels = appDelegate.sharedHotels;
    
    _objects = [HMSHelperIndexedList addContentInIndexedList:[HMSHelperIndexedList createDictionnaryForIndexedList:_hotels :@"city"]];
    
    indices = [_objects valueForKey:@"headerTitle"];
   
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _objects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_objects objectAtIndex:section] objectForKey:@"rowValues"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
   
    cell.textLabel.text = [[[_objects objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
    objectAtIndex:indexPath.row];
    
    if ([tableView respondsToSelector:@selector(setSectionIndexColor:)]) { //couleur text index bar
        tableView.sectionIndexColor = [HMSColorElement hms_darkRedColor];
    }
    
    return cell;
}


- (NSInteger)realRowNumberForIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView //TRACY - TABLE VIEW COLOR CELL HANDLER
{
	NSInteger retInt = 0;
	if (!indexPath.section)
	{
		return indexPath.row;
	}
	for (int i=0; i < indexPath.section;i++)
	{
		retInt += [tableView numberOfRowsInSection:i];
	}
    
	return retInt + indexPath.row;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath //TRACY - TABLE VIEW COLOR CELL HANDLER
{
    
    NSInteger realRow = [self realRowNumberForIndexPath:indexPath inTableView:tableView];
    if (realRow % 2) {
        cell.backgroundColor = [HMSColorElement hms_lightRedColor]; //lightColor
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [HMSColorElement hms_darkRedColor]; //darkColor
        
    }
    
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
	return [[_objects objectAtIndex:section] objectForKey:@"headerTitle"];
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [_objects valueForKey:@"headerTitle"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [indices indexOfObject:title];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        NSString * city = [[[_objects objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
         objectAtIndex:indexPath.row];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"city", city];
        NSArray *filteredArray = [_hotels filteredArrayUsingPredicate:predicate];
        
        [[segue destinationViewController] setTitle:city];
        
        [[segue destinationViewController] setDetailItem:filteredArray];
    }
}

- (void) reloadDataTableView:(BOOL)animated
{
    _hotels = appDelegate.sharedHotels;
    _objects = [HMSHelperIndexedList addContentInIndexedList:[HMSHelperIndexedList createDictionnaryForIndexedList:_hotels :@"city"]];
    indices = [_objects valueForKey:@"headerTitle"];
    
    [self.tableView reloadData];

    if (animated)
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfSections)] withRowAnimation:UITableViewRowAnimationBottom];
}



@end
