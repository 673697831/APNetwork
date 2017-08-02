//
//  APNetworkAdapter.m
//  APNetwork
//
//  Created by ozr on 17/4/26.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import "APNetworkAdapter.h"

@implementation APNetworkAdapter

+ (APApiRequest *) HTTPRequestWithURL:(NSString*) URL
                               method:(APRequestMethod) method
                               params:(NSDictionary*) params
                        responseClass:(Class) aClass
                              success:(void (^)(APApiRequest *task, id responseObject))success
                              failure:(void (^)(APApiRequest *task, NSError *error))failure
{
    APApiRequest *request = [APApiRequest new];
    request.URL = URL;
    request.method = method;
    request.params = params;
    request.responseClass = aClass;
    request.shouldCahcheResult = NO;
    request.timeoutInterval = 10;
    request.attributes = @{APApiRequestRepeatCountAttributeName:@(3)};
    __weak typeof(request) weakRequest = request;
    request.successBlock = ^(id response) {
        __strong typeof(request) strongRequest = weakRequest;
        if (success) {
            success(strongRequest, response);
        }
    };
    
    request.failureBlock = ^(id response, NSError *error)
    {
        __strong typeof(request) strongRequest = weakRequest;
        if (failure) {
            failure(strongRequest, error);
        }
        
    };
    
    return request;
}

@end
