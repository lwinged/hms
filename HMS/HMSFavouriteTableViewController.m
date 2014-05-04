//
//  HMSFavouriteTableViewController.m
//  HMS
//
//  Created by flav on 30/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSFavouriteTableViewController.h"
#import "HMSHelperIndexedList.h"
#import "HMSTabBarController.h"
#import "HMSAppDelegate.h"

@interface HMSFavouriteTableViewController ()
{
    NSMutableArray * _objects;
    NSMutableArray *indices;
    NSMutableArray * _hotels;
    HMSAppDelegate *appDelegate;
    
}

@end

@implementation HMSFavouriteTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the UIButton
    UIImage *editImg = [UIImage imageNamed:@"edit32.png"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:editImg forState:UIControlStateNormal];
    btn.frame = CGRectMake(0.0, 0.0, editImg.size.width, editImg.size.height);
    
    // Initialize the UIBarButtonItem
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    // Set the Target and Action for btn
    [btn addTarget:self action:@selector(editButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    

    // Then you can add the aBarButtonItem to the UINavigationBar
    self.navigationItem.rightBarButtonItem = aBarButtonItem;
    
    // Release buttonImage
    //[editImg release];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    _hotels = appDelegate.favoritesHotels;

    _objects = [[HMSHelperIndexedList addContentInIndexedList:[HMSHelperIndexedList createDictionnaryForIndexedList:_hotels :@"name"]] mutableCopy];
    indices = [_objects valueForKey:@"headerTitle"];

    
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Favourite";

}

- (void) editButtonTouched
{
    // edit/done button has been touched
        [self.tableView setEditing:!self.tableView.editing animated:YES];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell4" forIndexPath:indexPath];
    
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
        cell.textLabel.textColor = [UIColor colorWithRed:(145/255.0) green:(40/255.0) blue:(59/255.0) alpha:1.0];
    }
    else {
        cell.backgroundColor = [UIColor colorWithRed:(253/255.0) green:(253/255.0) blue:(254/255.0) alpha:1.0];
        cell.textLabel.textColor = [UIColor colorWithRed:(109/255.0) green:(7/255.0) blue:(26/255.0) alpha:1.0];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
                                                                  *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        // delete row
        NSString * name = [[[_objects objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
                           objectAtIndex:indexPath.row];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", name];
        NSArray *filteredArray = [_hotels filteredArrayUsingPredicate:predicate];
        [_hotels removeObjectIdenticalTo:filteredArray[0]];
        [[[_objects objectAtIndex:indexPath.section] objectForKey:@"rowValues"] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        //delete section
        if ([[[_objects objectAtIndex:indexPath.section] objectForKey:@"rowValues"] count] == 0)
        {
            [_objects removeObjectAtIndex:indexPath.section];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
    
        
    }
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showFavouriteDetail"])
    {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSString * name = [[[_objects objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
                           objectAtIndex:indexPath.row];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", name];
        NSArray *filteredArray = [_hotels filteredArrayUsingPredicate:predicate];
        
        HMSTabBarController * tabcontroller = [segue destinationViewController];
        tabcontroller.item = filteredArray[0];
        
    }
}


@end
