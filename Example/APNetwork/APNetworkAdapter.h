//
//  APNetworkAdapter.h
//  APNetwork
//
//  Created by ozr on 17/4/26.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APApiRequest.h"

@interface APNetworkAdapter : NSObject

+ (APApiRequest *) HTTPRequestWithURL:(NSString*) URL
                               method:(APRequestMethod) method
                               params:(NSDictionary*) params
                        responseClass:(Class) aClass
                              success:(void (^)(APApiRequest *task, id responseObject))success
                              failure:(void (^)(APApiRequest *task, NSError *error))failure;

@end
