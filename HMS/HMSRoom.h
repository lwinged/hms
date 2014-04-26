//
//  HMSRoom.h
//  hms
//
//  Created by flav on 02/02/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Simple class to represent a room.
 */
@interface HMSRoom : NSObject <NSCoding>

/**
 The name of room
 */
@property (nonatomic,strong) NSString * name;

//
///**
// The price of room
// */
//@property (nonatomic,strong) NSDecimalNumber * price;
//
///**
// The number of bed
// */
//@property (nonatomic,assign) NSInteger bed;
//
///**
// The number of room available
// */
//@property (nonatomic,assign) NSInteger free;
//
///**
// The room description
// */
//@property (nonatomic,strong) NSString * description;

/**
 The kind of room
 */
@property (nonatomic,strong) NSString * type;

/**
 The photos of room
 */
@property (nonatomic, strong) NSMutableArray * photos;


/**
 Initialize a new HMSRoom object
 @param name The room name
 @param type The kind of room
 @param description The room description
 @param free The number of room available
 @param bed The number of bed
 @param price The price of room
 @returns a newly initialized object
 */
//-(id)initWithParams:(NSString *)name :(NSString *)type :(NSString *)description :(NSInteger)free :(NSInteger)bed :(NSDecimalNumber *) price;
-(id)initWithParams:(NSString *)name :(NSString *)type;


#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)coder;

- (id)initWithCoder:(NSCoder *)decoder;

@end
