//
//  HMSMasterViewController.h
//  HMS
//
//  Created by flav on 19/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMSMasterViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>


- (void) reloadDataTableView:(BOOL)animated;


@end
