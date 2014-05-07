//
//  HMSMasterViewController.h
//  HMS
//
//  Created by flav on 19/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SBPickerSelector.h>

@interface HMSMasterViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, SBPickerSelectorDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *countryButton;

- (void) reloadDataTableView:(BOOL)animated;

@property(nonatomic, retain) UIColor *sectionIndexColor;


@end
