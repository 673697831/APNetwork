//
//  Header.h
//  Pods
//
//  Created by ozr on 17/3/13.
//
//

@protocol APBaseRequestDelegate <NSObject>

- (void)requestDidSuccess:(id)sender responseObject:(id)responseObject;
- (void)requestDidFailed:(id)sender error:(NSError *)error;
- (void)requestDidCancel:(id)sender;

@end

@protocol APBaseRequestDataSource <NSObject>

- (NSString *)baseRequestURL;
- (NSInteger)baseRequestMethod;
- (NSDictionary *)baseRequestParams;
- (NSTimeInterval)baseRequestTimeoutInterval;

@end

@protocol APBaseApiRequestProtocol <NSObject>

@optional

- (void)addBaseRequestDelegate:(id<APBaseRequestDelegate>)delegate;

@required

- (void)start;
- (void)cancel;
- (void)clearCompletionBlock;

@end

@protocol APCacheURLStoreProtocol <NSObject>

- (void)setObj:(id)object
           url:(NSString *)url
        params:(NSDictionary*)params;
- (id)getCacheObjWithUrl:(NSString *)url
                  params:(NSDictionary*)params
               afterDate:(NSDate *)date;
- (id)getCacheObjWithUrl:(NSString *)url
                  params:(NSDictionary*)params
                   class:(Class) aClass
               afterDate:(NSDate *)date;
- (void)clearCacheWithUrl:(NSString *)url
                   params:(NSDictionary*)params
               beforeDate:(NSDate *)date;
- (void)clearAllCacheBeforeDate:(NSDate *)date;

@end

@protocol APResponseSerializerProtocol <NSObject>

- (id)responseObjectForResponse:(id) json
                  responseClass:(Class) aClass
                          error:(NSError *__autoreleasing *)error;

@end
