//
//  APIndexPageNetworkApi.m
//  APNetwork
//
//  Created by ozr on 17/4/26.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import "APIndexPageApi.h"
#import "APUrlBuilder.h"
#import "APNetworkAdapter.h"

@implementation APIndexPageApi

- (APApiRequest *)requestPageDataWithSuccess:(void (^)(APApiRequest *task, id responseObject))success
                                     failure:(void (^)(APApiRequest *task, NSError *error))failure
{
    return [APNetworkAdapter HTTPRequestWithURL:UriBuilder.H(@"http://m.aipai.com").P(@"aipaiApi/indexPage/pageData").Q(@"module", @"indexPage").Q(@"func", @"pageData").build
                                         method:APRequestMethodGET
                                         params:nil
                                  responseClass:nil
                                        success:^(APApiRequest *task, id responseObject)
    {
        if (success) {
            success(task, responseObject);
        }
        
    }
                                        failure:^(APApiRequest *task, NSError *error)
    {
        if (failure) {
            failure(task, error);
        }
        
    }];
}

- (APApiRequest *)requestConfigWithSuccess:(void (^)(APApiRequest *task, id responseObject))success
                                   failure:(void (^)(APApiRequest *task, NSError *error))failure
{
    APApiRequest *request = [APNetworkAdapter HTTPRequestWithURL:@"https://api.ricedonate.com/ricedonate/htdocs/ricedonate/public/config.php?type=get&keychain=8AEE13F8-AB9A-4DCB-B6C9-D11FBC2FB7A1&device=x86_64&os=ios&cv=0&sv=1.2.0&os_ver=8.4&sign=2b7e26b0cc7f4381e69a936c497b4b03"
                                         method:APRequestMethodGET
                                         params:nil
                                  responseClass:nil
                                        success:^(APApiRequest *task, id responseObject)
            {
                if (success) {
                    success(task, responseObject);
                }
                
            }
                                        failure:^(APApiRequest *task, NSError *error)
            {
                if (failure) {
                    failure(task, error);
                }
                
            }];
    
    request.shouldCahcheResult = YES;
    return request;
}

@end
