//
//  APApiRequest.m
//  APNetwork
//
//  Created by ozr on 17/4/26.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import "APApiRequest.h"
#import "APResponseSerializer.h"

@implementation APApiRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.responseSerializer = [APResponseSerializer new];
    }
    
    return self;
}

@end
