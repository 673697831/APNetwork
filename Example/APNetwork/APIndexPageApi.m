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
                                         params:@{
                                                  @"gameIdList":@[],
                                                  @"os":@"2",
                                                  @"versionCode":@"333",
                                                  }
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

@end
