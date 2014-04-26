//
//  HMSHelperIndexedList.m
//  HMS
//
//  Created by flav on 21/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSHelperIndexedList.h"

@implementation HMSHelperIndexedList

static NSString *letters = @"abcdefghijklmnopqrstuvwxyz";

+ (NSDictionary *) createDictionnaryForIndexedList:(NSArray *) array :(NSString *) property
{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    char l[2];
    l[1] = '\0';
    
    for (NSUInteger i = 0; i < letters.length; ++i)
    {
        l[0] = [letters characterAtIndex:i];
        NSString *letter = [[NSString alloc] initWithCString:l encoding:NSASCIIStringEncoding];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[c] %@", property, letter];
        NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0)
        {
            NSArray *propertyArray = [filteredArray valueForKey:property];
            NSOrderedSet *mySet = [[NSOrderedSet alloc] initWithArray:propertyArray];
            propertyArray = [[NSMutableArray alloc] initWithArray:[mySet array]];
            [dic setObject:propertyArray forKey:[letter uppercaseString]];
        }
        
    }
    return dic;
}


+ (NSArray *) addContentInIndexedList: (NSDictionary *) dic
{
    NSMutableArray *content = [[NSMutableArray alloc] init];
    
    for (NSString * key in dic)
    {
        NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
        [row setValue:key forKey:@"headerTitle"];
        [row setValue:dic[key] forKey:@"rowValues"];
        [content addObject:row];
    }
    
    return content;
}



@end
