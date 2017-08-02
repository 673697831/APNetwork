//
//  APURLCacheManager.h
//  APNetwork
//
//  Created by ouzhirui on 2017/8/2.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <APNetwork.h>

@interface APURLCacheManager : NSObject<APCacheURLStoreProtocol>

+ (APURLCacheManager *) sharedManager;

@end
