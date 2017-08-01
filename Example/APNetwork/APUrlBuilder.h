//
//  APUrlBuilder.h
//  APNetwork
//
//  Created by ozr on 17/4/26.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UriBuilder [APUrlBuilder new]

@interface APUrlBuilder : NSObject

//主地址,可用于切换正式服测试服其他服
- (APUrlBuilder* (^)(const NSString* )) H;
//路径path，问号之前的字符串
- (APUrlBuilder* (^)(const NSString* )) P;
//参数列表，可以无限拼接上去
- (APUrlBuilder* (^)(NSString*, NSString* )) Q;
//输出url
- (NSString*) build;

@end
