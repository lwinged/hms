//
//  HMSDetailViewController.m
//  HMS
//
//  Created by flav on 19/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSDetailViewController.h"
#import "HMSHelperIndexedList.h"
#import "HMSHotel.h"
#import "HMSTabBarController.h"


@interface HMSDetailViewController ()
{
    NSArray * _objects;
    NSArray *indices;
}

- (void)configureView;

@end

@implementation HMSDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
       // NSLog(@"jupdate");
        //self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
        
    _objects = [HMSHelperIndexedList addContentInIndexedList:[HMSHelperIndexedList createDictionnaryForIndexedList:_detailItem :@"name"]];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
    
    //cell.detailTextLabel.text = tempName; //NOMBMRE D'ETOILE HERE
    cell.textLabel.text = [[[_objects objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
                           objectAtIndex:indexPath.row];
    cell.textColor = [UIColor colorWithRed:(139/255.0) green:(108/255.0) blue:(66/255.0) alpha:1.0]; //DARKCOLOR
    
    return cell;
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
    if ([[segue identifier] isEqualToString:@"showHotel"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSString * hotelName = [[[_objects objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
                           objectAtIndex:indexPath.row];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", hotelName];
        NSArray *filteredArray = [_detailItem filteredArrayUsingPredicate:predicate];
        
        HMSTabBarController * tabcontroller = [segue destinationViewController];
        tabcontroller.item = [filteredArray objectAtIndex:0];
        
        
    }
}


@end
