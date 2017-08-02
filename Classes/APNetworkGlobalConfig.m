//
//  APNetworkGlobalConfig.m
//  Pods
//
//  Created by ouzhirui on 2017/8/2.
//
//

#import "APNetworkGlobalConfig.h"

@implementation APNetworkGlobalConfig

+ (APNetworkGlobalConfig *)shareConfig
{
    static APNetworkGlobalConfig* config;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [APNetworkGlobalConfig new];
    });
    
    return config;
}

@end
