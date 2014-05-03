//
//  HMSMasterViewController.h
//  HMS
//
//  Created by flav on 19/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SBPickerSelector.h>

@interface HMSMasterViewController : UITableViewController<SBPickerSelectorDelegate>
@property (weak, nonatomic) IBOutlet UIButton *countryButton;


@end
