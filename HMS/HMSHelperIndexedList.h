//
//  HMSHelperIndexedList.h
//  HMS
//
//  Created by flav on 21/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMSHelperIndexedList : NSObject


+ (NSDictionary *) createDictionnaryForIndexedList:(NSArray *) array :(NSString *) property;
+ (NSArray *) addContentInIndexedList: (NSDictionary *) dic;


@end
