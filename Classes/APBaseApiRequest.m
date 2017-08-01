//
//  APBaseApiRequest.h
//  AiPai
//
//  Created by ozr on 17/3/17.
//  Copyright © 2017年 ozr. All rights reserved.
//

#import "APBaseApiRequest.h"
#if __has_include(<YTKNetwork/YTKNetwork.h>)
#import <YTKNetwork/YTKNetwork.h>
#else
#import "YTKNetwork.h"
#endif

NSString * const APApiRequestRepeatCountAttributeName = @"com.aipai.network.request.repeatCount";

@interface APBaseRequest : YTKRequest

@property (nonatomic, weak) id<APBaseRequestDataSource> requestDataSource;

@end

@implementation APBaseRequest

- (NSString *)requestUrl
{
    return [self.requestDataSource baseRequestURL];
}

- (YTKRequestMethod)requestMethod
{
    return [self.requestDataSource baseRequestMethod];
}

- (NSDictionary *)requestArgument
{
    return [self.requestDataSource baseRequestParams];
}

- (NSTimeInterval)requestTimeoutInterval
{
    return [self.requestDataSource baseRequestTimeoutInterval];
}

@end

@interface APBaseApiRequest ()<YTKRequestAccessory>

@property (nonatomic, strong) APBaseRequest *baseRequest;

@end

@implementation APBaseApiRequest
{
    //    YTKRequest *_normalRequest;
    //    YTKBatchRequest *_batchRequestRequest;
    //    YTKChainRequest *_chainRequest;
}

- (instancetype)init
{
    if (self = [super init]) {
        _baseRequest = [APBaseRequest new];
        _baseRequest.requestDataSource = self;
        _requestDelegates = [NSMutableArray new];
        _shouldCahcheResult = YES;
        _timeoutInterval = 60;
    }
    
    return self;
}

- (id)cacheObject
{
    if (!self.cacheStore) {
        return nil;
    }
    
    return [self.cacheStore getCacheObjWithUrl:self.URL params:self.params class:self.responseClass afterDate:nil];
}

- (void)start
{
    id<APCacheURLStoreProtocol> cacheStore = nil;
    if (self.shouldCahcheResult && self.cacheStore!=nil) {
        cacheStore = self.cacheStore;
    }
    id<APResponseSerializerProtocol> responseSerializer = self.responseSerializer;
    NSMutableArray<id<APBaseRequestDelegate>> *requestDelegates = self.requestDelegates;
    
    void (^success)(id) = self.successBlock;
    void (^failure)(id, NSError *) = self.failureBlock;
    
    NSString *url = self.URL;
    NSArray<NSString *> *methodList = @[@"GET", @"POST", @"HEAD", @"PUT", @"DELETE", @"PATCH"];
    NSString *method = self.method > methodList.count?methodList[0]:methodList[self.method];
    NSDictionary *params = self.params;
    Class aClass = self.responseClass;
    
    [self startWithCacheStore:cacheStore responseSerializer:responseSerializer requestDelegates:requestDelegates success:success failure:false url:url method:method params:params aClass:aClass];
}

- (void)cancel
{
    [self.baseRequest stop];
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
    [self clearCompletionBlock];
    
    for (id <APBaseRequestDelegate>requestDelegate in self.requestDelegates) {
        [requestDelegate requestDidCancel:self];
    }
}

- (void)clearCompletionBlock
{
    self.cancelBlock = nil;
    self.successBlock = nil;
    self.failureBlock = nil;
    [self.baseRequest clearCompletionBlock];
    [self.requestDelegates removeAllObjects];
}

- (void)addBaseRequestDelegate:(id<APBaseRequestDelegate>)delegate
{
    [self.requestDelegates addObject:delegate];
}

#pragma mark - private method

- (BOOL)shouldReStartWithError:(NSError *)error
{
    if (!self.attributes) {
        return NO;
    }
    
    if (!error) {
        return NO;
    }
    
    if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == -1001) {
        
        //发现延时错误 计数 -1
        NSInteger repeatCount = [self.attributes[APApiRequestRepeatCountAttributeName] integerValue];
        repeatCount --;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.attributes];
        dic[APApiRequestRepeatCountAttributeName] = @(repeatCount);
        self.attributes = dic;
        
        NSLog(@"repeatCount ===%d", repeatCount);
        return repeatCount >= 0;
        
    }
    
    return NO;
}

- (void)startWithCacheStore:(id<APCacheURLStoreProtocol>)cacheStore
         responseSerializer:(id<APResponseSerializerProtocol>)responseSerializer
           requestDelegates:(NSArray<id<APBaseRequestDelegate>> *)requestDelegates
                    success:(void (^)(id))success
                    failure:(void (^)(id, NSError *))failure
                        url:(NSString *)url
                     method:(NSString *)method
                     params:(NSDictionary *)params
                     aClass:(Class)aClass
{
    APBaseRequest *baseRequest = [APBaseRequest new];
    baseRequest.requestDataSource = self;
    [baseRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = nil;
        id responseObject = nil;
        if (responseSerializer) {
            responseObject = [responseSerializer responseObjectForResponse:request.responseJSONObject responseClass:aClass error:&error];
        }else
        {
            responseObject = request.responseJSONObject;
        }
        
        if (error) {
            NSLog(@"LZRequest: FAILURE\nURL:%@ \nMETHOD:%@ "
                  @"\nPARAMS:\n%@\nResponse:%@\nError:%@",
                  url, method, params, request.responseJSONObject, error);
            if (failure) {
                failure(request.responseJSONObject, error);
            }
            
            for (id <APBaseRequestDelegate>requestDelegate in requestDelegates) {
                [requestDelegate requestDidFailed:self error:error];
            }
        }else
        {
            NSLog(@"LZRequest: SUCCESS\nURL:%@ \nMETHOD:%@ "
                  @"\nPARAMS:\n%@\nResponse:%@\nObject:%@",
                  url, method, params, request.responseJSONObject, responseObject);
            
            if (cacheStore) {
                [cacheStore setObj:responseObject url:url params:params];
            }
            if (success) {
                success(responseObject);
            }
            
            for (id <APBaseRequestDelegate>requestDelegate in requestDelegates) {
                [requestDelegate requestDidSuccess:self responseObject:responseObject];
            }
            
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"LZRequest: FAILURE\nURL:%@ \nMETHOD:%@ "
              @"\nPARAMS:\n%@\nResponse:%@\nError:%@",
              url, method, params, request.responseJSONObject, request.requestOperationError);
        
        //超时自动重连
        if ([self shouldReStartWithError:request.requestOperationError]) {
            [self start];
        }else
        {
            if (failure) {
                failure(nil, request.requestOperationError);
            }
            
            for (id <APBaseRequestDelegate>requestDelegate in requestDelegates) {
                [requestDelegate requestDidFailed:self error:request.requestOperationError];
            }
        }
        
    }];
}

#pragma mark - APBaseRequestDelegate

- (NSString *)baseRequestURL
{
    return self.URL;
}

- (NSInteger)baseRequestMethod
{
    return self.method;
}

- (NSDictionary *)baseRequestParams
{
    return self.params;
}

- (NSTimeInterval)baseRequestTimeoutInterval
{
    return self.timeoutInterval;
}

- (void)dealloc
{

}

@end

