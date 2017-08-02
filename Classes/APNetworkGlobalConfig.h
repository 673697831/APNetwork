//
//  APNetworkGlobalConfig.h
//  Pods
//
//  Created by ouzhirui on 2017/8/2.
//
//

#import <Foundation/Foundation.h>

@interface APNetworkGlobalConfig : NSObject

+ (APNetworkGlobalConfig *)shareConfig;

@property (nonatomic, assign) BOOL debugLogEnabled;

@end
