//
//  APBaseApiRequest.h
//  AiPai
//
//  Created by ozr on 17/3/17.
//  Copyright © 2017年 ozr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APNetworkProtocol.h"

typedef NS_ENUM(NSInteger, APRequestMethod) {
    APRequestMethodGET = 0,
    APRequestMethodPOST,
    APRequestMethodHEAD,
    APRequestMethodPUT,
    APRequestMethodDELETE,
    APRequestMethodPATCH,
};

@protocol AFMultipartFormData;

@interface APBaseApiRequest : NSObject<APBaseApiRequestProtocol, APBaseRequestDataSource>

//cacheStore 类型
@property (nonatomic, weak) id<APCacheURLStoreProtocol> cacheStore;
//回调序列化
@property (nonatomic, strong) id<APResponseSerializerProtocol> responseSerializer;
//额外属性
@property (nonatomic, strong) NSDictionary *attributes;
//请求url
@property (nonatomic, strong) NSString *URL;
//请求类型
@property (nonatomic, assign) APRequestMethod method;
//请求参数
@property (nonatomic, strong) NSDictionary *params;
//请求超时参数
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
//是否cache结果
@property (nonatomic, assign) BOOL shouldCahcheResult;
//缓存数据
@property (nonatomic, strong) id cacheObject;
//返回json序列化后的对象类型
@property (nonatomic, strong) id responseClass;
//成功回调
@property (nonatomic, copy) void (^successBlock)(id);
//失败回调
@property (nonatomic, copy) void (^failureBlock)(id, NSError *);
//post 上传图片资源等，默认为空
@property (nonatomic, copy) void (^constructingBodyBlock)(id <AFMultipartFormData> formData);
//取消回调 默认为空
@property (nonatomic, copy) void (^cancelBlock)();
//  Username and password used for HTTP authorization. Should be formed as @[@"Username", @"Password"].默认为空
@property (nonatomic, strong) NSArray<NSString *> *requestAuthorizationHeaderFieldArray;
//  Additional HTTP request header field.默认为空
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *requestHeaderFieldValueDictionary;

@property (nonatomic, strong) NSMutableArray<id<APBaseRequestDelegate>> *requestDelegates;

@end

//额外参数之重复次数
extern NSString *const APApiRequestRepeatCountAttributeName;
