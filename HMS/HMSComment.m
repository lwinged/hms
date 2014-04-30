//
//  HMSComment.m
//  HMS
//
//  Created by flav on 09/04/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSComment.h"

@implementation HMSComment


-(id)initWithParams:(NSString *)author :(NSString *)comment
{
    
    self = [super init];
    
    if (self)
    {
        self.author = author;
        self.comment = comment;
    }
    
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.author   forKey:@"author"];
    [coder encodeObject:self.comment  forKey:@"comment"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        
       _author = [decoder decodeObjectForKey:@"author"];
       _comment = [decoder decodeObjectForKey:@"comment"];
        
    }
    return self;
}


@end
