//
//  HMSRoom.m
//  hms
//
//  Created by flav on 02/02/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSRoom.h"

@implementation HMSRoom

//-(id)initWithParams:(NSString *)name :(NSString *)type :(NSString *)description :(NSInteger)free :(NSInteger)bed :(NSDecimalNumber *) price
//{
//
//    self = [super init];
//    
//    if (self)
//    {
//        self.name = name;
//        self.type = type;
//        self.description = description;
//        self.free = free;
//        self.bed = bed;
//        self.price = price;
//    }
//    
//    return self;
//}


-(id)initWithParams:(NSString *)name :(NSString *)type
{
    
    self = [super init];
    
    if (self)
    {
        self.name = name;
        self.type = type;
        self.photos = [[NSMutableArray alloc] init];
    }
    
    return self;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name   forKey:@"name"];
    [coder encodeObject:self.type   forKey:@"type"];
    [coder encodeObject:self.photos   forKey:@"photos"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        
       _name = [decoder decodeObjectForKey:@"name"];
       _type =  [decoder decodeObjectForKey:@"type"];
       _photos = [decoder decodeObjectForKey:@"photos"];
        
    }
    return self;
}

@end
