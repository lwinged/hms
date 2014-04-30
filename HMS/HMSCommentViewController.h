//
//  HMSCommentViewController.h
//  HMS
//
//  Created by flav on 29/04/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "JSMessagesViewController.h"

@interface HMSCommentViewController : JSMessagesViewController <JSMessagesViewDataSource, JSMessagesViewDelegate>

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSDictionary *avatars;


@end
