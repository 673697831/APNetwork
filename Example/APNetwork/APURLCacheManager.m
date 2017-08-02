//
//  APURLCacheManager.m
//  APNetwork
//
//  Created by ouzhirui on 2017/8/2.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import "APURLCacheManager.h"
#import "NSString+LZAdd.h"
#import <APStore.h>
#import <APKeyValueStore.h>
#import <YYModel.h>

static NSString *const kTableNameUrlCache = @"url_cache";

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

static NSString *const DEFAULT_DB_NAME = @"APNetwork.sqlite";

@interface APURLCacheManager ()

@property (nonatomic, strong) APKeyValueStore *keyValueStore;

@end

@implementation APURLCacheManager

#pragma mark -

+ (APURLCacheManager *) sharedManager
{
    static APURLCacheManager* manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [APURLCacheManager new];
    });
    
    return manager;
}

+ (NSString *)dbPath
{
    return [PATH_OF_DOCUMENT stringByAppendingPathComponent:DEFAULT_DB_NAME];
}

- (instancetype)init
{
    if (self = [super init]) {
        _keyValueStore = [APKeyValueStore storeWithDBPath:[self.class dbPath] encryptKey:nil];
    }
    
    return self;
}

#pragma mark - 

- (NSString *)urlStoreKeyWithUrl:(NSString *)url
                          params:(NSDictionary*)params
{
    BOOL hasQuery = NO;
    NSMutableString *mString = [NSMutableString stringWithString:url];
    for (NSString* key in params) {
        NSString *curStr = [NSString stringWithFormat:@"%@", params[key]];
        if (hasQuery)
            [mString appendFormat:@"&%@=%@", key, [curStr lz_customUrlEncode]];
        else
            [mString appendFormat:@"?%@=%@", key, [curStr lz_customUrlEncode]];
        
        hasQuery = YES;
    }
    return mString;
}

- (id)generatedJSONWithObj:(id)obj
{
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *jsonArray = [NSMutableArray new];
        for (id subObj in obj) {
            id subJson = [self generatedJSONWithObj:subObj];
            [jsonArray addObject:subJson];
        }
        
        return jsonArray;
    }
    
    return [obj yy_modelToJSONObject];
}

- (BOOL)putObject:(id)object
           withId:(NSString *)objectId
        intoTable:(NSString *)tableName
{
    id json = [self generatedJSONWithObj:object];
    if (json == nil) {
        return NO;
    }else
    {
        return [self.keyValueStore putObject:json withId:objectId intoTable:tableName];
    }
}

- (BOOL)insertObjects:(NSArray *)objects
          withIdArray:(NSArray *)idArray
            intoTable:(NSString *)tableName
{
    NSArray *jsonArray = [self generatedJSONWithObj:objects];
    return [self.keyValueStore insertObjectsByIdArray:idArray
                                            withArray:jsonArray
                                            fromTable:tableName];
}

- (id)getObjectWithJSON:(id)json
             modelClass:(Class)modelClass
{
    if ([json isKindOfClass:[NSArray class]]) {
        NSMutableArray *objectArray = [NSMutableArray new];
        for (id subJson in json) {
            id subObj = [self getObjectWithJSON:subJson modelClass:modelClass];
            if (subObj) {
                [objectArray addObject:subObj];
            }
        }
        
        return objectArray;
    }
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        if (modelClass == nil) {
            return json;
        }
        
        return [modelClass yy_modelWithJSON:json]?:json;
        
    }
    
    return json;
}

- (id)getObjectById:(NSString *)objectId
          fromTable:(NSString *)tableName
         modelClass:(Class)modelClass
          afterDate:(NSDate *)date
{
    id json = [self.keyValueStore getObjectById:objectId fromTable:tableName afterDate:date];
    return [self getObjectWithJSON:json modelClass:modelClass];
}

- (id)getAllObjectFromTable:(NSString *)tableName
                 modelClass:(Class)modelClass
                  afterDate:(NSDate *)date
{
    NSArray *jsonObjects = [self.keyValueStore getAllItemObjectsFromTable:tableName afterDate:date];
    return [self getObjectWithJSON:jsonObjects modelClass:modelClass];
}

- (void)deleteObjectWithObjectById:(NSString *)objectId fromTable:(NSString *)tableName beforeDate:(NSDate *)date
{
    [self.keyValueStore deleteObjectWithObjectById:objectId fromTable:tableName beforeDate:date];
}

- (void)deleteObjectFromTable:(NSString *)tableName beforeDate:(NSDate *)date
{
    [self.keyValueStore deleteObjectFromTable:tableName beforeDate:date];
}

#pragma mark - APCacheURLStoreProtocol

- (void)setObj:(id)object
           url:(NSString *)url
        params:(NSDictionary*)params
{
    if (object == nil || object == [NSNull null]) {
        return;
    }
    
    [self putObject:object withId:[self urlStoreKeyWithUrl:url params:params] intoTable:kTableNameUrlCache];
    
}

- (id)getCacheObjWithUrl:(NSString *)url
                  params:(NSDictionary*)params
               afterDate:(NSDate *)date
{
    return [self getCacheObjWithUrl:[self urlStoreKeyWithUrl:url params:params]
                             params:params
                              class:nil
                          afterDate:date];
}

- (id)getCacheObjWithUrl:(NSString *)url params:(NSDictionary *)params class:(Class)aClass afterDate:(NSDate *)date
{
    return [self getObjectById:[self urlStoreKeyWithUrl:url params:params]
                     fromTable:kTableNameUrlCache
                    modelClass:aClass
                     afterDate:date];
}

- (void)clearCacheWithUrl:(NSString *)url
                   params:(NSDictionary*)params
               beforeDate:(NSDate *)date
{
    [self deleteObjectWithObjectById:[self urlStoreKeyWithUrl:url params:params]
                           fromTable:kTableNameUrlCache
                          beforeDate:date];
}

- (void)clearAllCacheBeforeDate:(NSDate *)date
{
    [self deleteObjectFromTable:kTableNameUrlCache beforeDate:date];
}

@end
