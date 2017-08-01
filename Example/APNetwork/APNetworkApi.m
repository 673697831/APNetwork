//
//  APNetworkApi.m
//  APNetwork
//
//  Created by ozr on 17/4/26.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import "APNetworkApi.h"

@implementation APNetworkApi

+ (APNetworkApi *) sharedInstance
{
    static APNetworkApi* instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [APNetworkApi new];
    });
    
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _indexPageApi = [APIndexPageApi new];
    }
    
    return self;
}

@end
