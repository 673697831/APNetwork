//
//  APUrlBuilder.m
//  APNetwork
//
//  Created by ozr on 17/4/26.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import "APUrlBuilder.h"
#import "APURLCommonParams.h"

@interface APUrlBuilder ()

@property (nonatomic, strong) NSMutableString*  uri;
@property (nonatomic, assign) BOOL              hasQuery;
@property (nonatomic, copy)   NSString*         module;
@property (nonatomic, copy)   NSString*         func;

@end

@implementation APUrlBuilder

//主地址,可用于切换正式服测试服其他服
- (APUrlBuilder* (^)(const NSString* )) H;
{
    return ^id(NSString* host) {
        [self.uri appendFormat:@"%@", [host stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        return self;
    };
}

//路径path，问号之前的字符串
- (APUrlBuilder* (^)(const NSString* )) P
{
    return ^id(NSString* path) {
        [self.uri appendFormat:@"/%@", [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        return self;
    };
}

//属于哪个模块
- (APUrlBuilder* (^)(const NSString* )) M
{
    return ^id(NSString* module) {
        [self.uri appendFormat:@"/%@", [module stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.module = module;
        return self;
    };
}

//属于哪个函数
- (APUrlBuilder* (^)(const NSString* )) F
{
    return ^id(NSString* func) {
        [self.uri appendFormat:@"/%@", [func stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.func = func;
        return self;
    };
}

//参数列表，可以无限拼接上去
- (APUrlBuilder* (^)(NSString*, NSString* )) Q
{
    return ^id(NSString* key, NSString* value) {
        NSString* str = [NSString stringWithFormat:@"%@=%@", [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        if (self.hasQuery)
        {
            [self.uri appendFormat:@"&%@", str];
        }
        else
        {
            [self.uri appendFormat:@"?%@", str];
        }
        
        self.hasQuery = YES;
        
        return self;
    };
}

//输出url
- (NSString*) build
{
    APUrlBuilder *build = self;
    
//    if (self.module.length > 0) {
//        build = build.Q(@"module", self.module);
//    }
//    if (self.func.length > 0) {
//        build = build.Q(@"func", self.func);
//    }
    
    NSDictionary *dic = [APURLCommonParams buildParams];
    for (NSString *key in dic) {
        build = build.Q(key, dic[key]);
    }
    return build.uri;
}

- (instancetype) init
{
    if (self = [super init])
    {
        _uri = [NSMutableString string];
        _module = @"";
        _func = @"";
    }
    
    return self;
}


@end
