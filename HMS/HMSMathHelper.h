//
//  HMSMathHelper.h
//  HMS
//
//  Created by flav on 27/04/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMSMathHelper : NSObject

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

+ (double) distanceFromAToB:(double) lat1 :(double) long1 :(double) lat2 :(double) long2;

@end
