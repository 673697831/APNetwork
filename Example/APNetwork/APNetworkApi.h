//
//  APNetworkApi.h
//  APNetwork
//
//  Created by ozr on 17/4/26.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIndexPageApi.h"

@interface APNetworkApi : NSObject

@property (nonatomic, strong) APIndexPageApi *indexPageApi;

+ (APNetworkApi *) sharedInstance;

@end
