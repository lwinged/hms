//
//  HMSComment.m
//  HMS
//
//  Created by flav on 09/04/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSComment.h"

@implementation HMSComment


-(id)initWithParams:(NSString *)author :(NSString *)comment:(NSString *)date
{
    
    self = [super init];
    
    if (self)
    {
        self.author = author;
        self.comment = comment;
        self.date = date;
    }
    
    return self;
}


@end
