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
    NSArray* _thumbnails;
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
    
    _objects = [[NSArray alloc] initWithObjects: @"Search", @"Shaker", @"Favorite", nil];
    _thumbnails = [[NSArray alloc] initWithObjects: @"loupe32.png", @"shaker32.png", @"heart32.png", nil]; //add icon
    
    
    // under status bar
    self.tableView.contentInset = UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f);
    self.tableView.backgroundColor = [UIColor colorWithRed:(145/255.0) green:(40/255.0) blue:(59/255.0) alpha:1.0]; //background color
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]; //remove separator line
    
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Menlo" size:17.0]];
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
    
    //UIImage *background = [UIImage imageNamed:@"cellstylebg.png"];
    //UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    //cellBackgroundView.image = background;
    //cell.backgroundView = cellBackgroundView;
    
    cell.imageView.image = [UIImage imageNamed:[_thumbnails objectAtIndex:indexPath.row]];
    cell.textLabel.text = _objects[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:(109/255.0) green:(7/255.0) blue:(26/255.0) alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    
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
