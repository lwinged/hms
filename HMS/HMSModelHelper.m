//
//  HMSModelHelper.m
//  HMS
//
//  Created by Tevy CHANH on 30/04/14.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSModelHelper.h"

@implementation HMSModelHelper

+ (NSArray *) createListOfHotels:(NSArray *) myTab;
{
    NSMutableArray *_sharedHotels = [[NSMutableArray alloc] init];
    NSInteger nbElem = [myTab count];
    for (NSInteger i = 0; i < nbElem; ++i)
    {
        NSMutableDictionary *current_hotel = [myTab objectAtIndex:i];
    
        HMSHotel *hotel = [[HMSHotel alloc] initWithParams: [current_hotel valueForKey:@"name"]:[current_hotel valueForKey:@"country"] : [current_hotel valueForKey:@"city"]: [current_hotel valueForKey:@"description"] : [[current_hotel valueForKey:@"stars"] integerValue] :[[current_hotel valueForKey:@"latitude"] doubleValue] :[[current_hotel valueForKey:@"longitude"] doubleValue]];
    
        NSArray *current_list = current_hotel[@"photos"];
        for (NSInteger j = 0; j < [current_list count]; ++j){ [hotel.photos addObject:current_list[j]]; }
    
        current_list = current_hotel[@"rooms"];
        for (NSInteger j = 0; j < [current_list count] ; ++j)
        {
            HMSRoom *room = [[HMSRoom alloc] initWithParams: [current_list[j] valueForKey:@"name"] :[current_list[j] valueForKey:@"type"]];
            NSArray *photo_tmp = [current_list[j] valueForKey:@"photos"];
    
            for (NSInteger k = 0; k < [photo_tmp count]; ++k){ [room.photos addObject:photo_tmp[k]]; }
            [hotel addRoom:room];
        }
        
        current_list = current_hotel[@"comments"];
        for (NSInteger j = 0; j < [current_list count]; j++)
        {
            NSDictionary *dico_tmp = [current_list objectAtIndex:j];
        
            HMSComment * comment = [[HMSComment alloc] initWithParams:[dico_tmp valueForKey:@"author"] :[dico_tmp valueForKey:@"comments"]: [dico_tmp valueForKey:@"date"]];
            [hotel.comments addObject:comment];
        }
        [_sharedHotels addObject:hotel];
    }
    return (_sharedHotels);
}

@end
