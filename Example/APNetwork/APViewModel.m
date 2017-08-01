//
//  APViewModel.m
//  APNetwork
//
//  Created by ozr on 17/4/27.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import "APViewModel.h"
#import "APNetworkApi.h"

@implementation APViewModel

- (APApiRequest *)loadIndexPageWithSuccess:(void (^)(APApiRequest *task, id responseObject))success
                                   failure:(void (^)(APApiRequest *task, NSError *error))failure
{
    return [[APNetworkApi sharedInstance].indexPageApi requestPageDataWithSuccess:^(APApiRequest *task, id responseObject) {
        
        
        if (success) {
            success(task, responseObject);
        }
    } failure:^(APApiRequest *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

@end
