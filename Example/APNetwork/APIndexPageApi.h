//
//  APIndexPageNetworkApi.h
//  APNetwork
//
//  Created by ozr on 17/4/26.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APApiRequest.h"

@interface APIndexPageApi : NSObject

- (APApiRequest *)requestPageDataWithSuccess:(void (^)(APApiRequest *task, id responseObject))success
                                     failure:(void (^)(APApiRequest *task, NSError *error))failure;


@end
