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
    //[self.tableView setSeparatorColor:[UIColor grayColor]]; //change color separator
    //[[UITableViewHeaderFooterView appearance] setTintColor:[UIColor colorWithRed:(145/255.0) green:(40/255.0) blue:(59/255.0) alpha:1.0]];
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
    
    cell.textLabel.text = [[[_objects objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
                           objectAtIndex:indexPath.row];
    
    if ([tableView respondsToSelector:@selector(setSectionIndexColor:)]) { //couleur text index bar
        tableView.sectionIndexColor = [UIColor colorWithRed:(109/255.0) green:(7/255.0) blue:(26/255.0) alpha:1.0];
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
        cell.backgroundColor = [UIColor whiteColor];
        cell.textColor = [UIColor colorWithRed:(145/255.0) green:(40/255.0) blue:(59/255.0) alpha:1.0];
    }
    else {
        cell.backgroundColor = [UIColor colorWithRed:(253/255.0) green:(253/255.0) blue:(254/255.0) alpha:1.0];
        cell.textColor = [UIColor colorWithRed:(109/255.0) green:(7/255.0) blue:(26/255.0) alpha:1.0];
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
