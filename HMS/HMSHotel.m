//
//  HMSHotel.m
//  hms
//
//  Created by flav on 22/01/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSHotel.h"


@implementation HMSHotel

- (id)initWithParams:(NSString *)name :(NSString *)country :(NSString *)city :(NSString *) description :(NSInteger)stars :(double)latitude :(double)longitude
{
    
    self = [super init];
    
    if (self)
    {
        self.name = name;
        self.country = country;
        self.city = city;
        self.stars = stars;
        self.description = description;
        self.rooms = [[NSMutableArray alloc] init];
        self.photos = [[NSMutableArray alloc] init];
        self.comments = [[NSMutableArray alloc] init];
        self.latitude = latitude;
        self.longitude = longitude;
    }
    
    return self;
}


- (void) addRoom:(HMSRoom *)room
{
    [self.rooms insertObject:room atIndex:0];
}

#pragma mark - NSCoding	

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name   forKey:@"name"];
    [coder encodeObject:self.country   forKey:@"country"];
    [coder encodeObject:self.city   forKey:@"city"];
    [coder encodeObject:self.description   forKey:@"description"];
    [coder encodeInteger:self.stars   forKey:@"stars"];
    [coder encodeObject:self.rooms   forKey:@"rooms"];
    [coder encodeObject:self.photos   forKey:@"photos"];
    [coder encodeObject:self.comments   forKey:@"comments"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        
       _name = [decoder decodeObjectForKey:@"name"];
       _country = [decoder decodeObjectForKey:@"country"];
       _city =  [decoder decodeObjectForKey:@"city"];
       _description = [decoder decodeObjectForKey:@"description"];
       _stars =  [decoder decodeIntegerForKey:@"stars"];
       _rooms = [decoder decodeObjectForKey:@"rooms"];
       _photos = [decoder decodeObjectForKey:@"photos"];
       _comments = [decoder decodeObjectForKey:@"comments"];


    }
    return self;
}


@end
