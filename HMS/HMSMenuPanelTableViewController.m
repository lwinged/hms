//
//  HMSMenuPanelTableViewController.m
//  HMS
//
//  Created by flav on 21/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSMenuPanelTableViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "HMSShakerViewController.h"

@interface HMSMenuPanelTableViewController ()
{
    NSArray * _objects;
}

@end

@implementation HMSMenuPanelTableViewController

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
    
    _objects = [[NSArray alloc] initWithObjects:@"Search", @"Shaker", @"Favourite", nil];
    
    // under status bar
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3" forIndexPath:indexPath];
    
    cell.textLabel.text = _objects[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:(200/255.0) green:(173/255.0) blue:(127/255.0) alpha:1.0]; //ligthColor
    cell.textColor = [UIColor whiteColor];
    
    //cell.textColor = [UIColor colorWithRed:(139/255.0) green:(108/255.0) blue:(66/255.0) alpha:1.0]; //darkColor
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"%@",_objects[indexPath.row]);

    if (indexPath.row == 0)
    {
     self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"];
        
    }
   else if (indexPath.row == 1)
    {
        
    [self.sidePanelController.centerPanel.navigationController setNavigationBarHidden:YES animated:YES];

    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"shakerViewController"]];

    }
    else
        self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"favouriteViewController"]];

    [[self sidePanelController] toggleLeftPanel:nil];
    
    
    
}


@end
