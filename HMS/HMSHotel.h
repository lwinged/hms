//
//  HMSHotel.h
//  hms
//
//  Created by flav on 22/01/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HMSRoom.h"
#import "HMSComment.h"

/**
 Simple class to represent a Hotel.
 */
@interface HMSHotel : NSObject <NSCoding>

/**
 The name of the hotel
 */
@property (nonatomic,strong) NSString * name;

/**
 The country - hotel location
 */
@property (nonatomic, strong) NSString * country;

/**
 The city - hotel location
 */
@property (nonatomic, strong) NSString * city;

/**
 The hotel description
 */
@property (nonatomic, strong) NSString * description;

/**
 The stars of hotel
 */
@property (nonatomic, assign) NSInteger stars;

/**
 The kind of rooms in this hotel
 */
@property (nonatomic, strong) NSMutableArray * rooms;

/**
 The photos of the hotel
 */
@property (nonatomic, strong) NSMutableArray * photos;


@property (nonatomic, strong) NSMutableArray * comments;

@property (nonatomic, assign) float latitude;

@property (nonatomic, assign) float longitude;


/**
 Initialize a new HMSHotel object
 @param name The hotel name
 @param country the country (location)
 @param city the city (location)
 @param description the hotel description
 @param stars the hotel stars
 @returns a newly initialized object
 */
- (id)initWithParams:(NSString *)name :(NSString *)country :(NSString *)city :(NSString *) description :(NSInteger)stars :(double)latitude :(double)longitude;

/**
 Add a room in this hotel
 @param room a room
 */
- (void) addRoom:(HMSRoom *)room;


#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)coder;

- (id)initWithCoder:(NSCoder *)decoder;

@end
