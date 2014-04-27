//
//  HMSMathHelper.m
//  HMS
//
//  Created by flav on 27/04/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSMathHelper.h"

@implementation HMSMathHelper

+ (double) distanceFromAToB:(double) lat1 :(double) long1 :(double) lat2 :(double) long2
{
    double distance = 0;
    double R = 6371;
    
    distance = acos(sin(DEGREES_TO_RADIANS(lat1)) * sin(DEGREES_TO_RADIANS(lat2)) + cos(DEGREES_TO_RADIANS(lat1)) * cos(DEGREES_TO_RADIANS(lat2)) * cos(DEGREES_TO_RADIANS(long1) - DEGREES_TO_RADIANS(long2))) * R;
    
    return (distance);
}


@end
