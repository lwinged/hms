//
//  HMSComment.h
//  HMS
//
//  Created by flav on 09/04/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMSComment : NSObject

@property (nonatomic,strong) NSString * author;
@property (nonatomic,strong) NSString * comment;
@property (nonatomic,strong) NSString * date;

-(id)initWithParams:(NSString *)author :(NSString *)comment :(NSString *)date;


@end