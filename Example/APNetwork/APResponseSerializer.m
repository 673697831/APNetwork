//
//  APResponseSerializer.m
//  APNetwork
//
//  Created by ozr on 17/4/26.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import "APResponseSerializer.h"

@implementation APResponseSerializer

- (id)responseObjectForResponse:(id) json
                  responseClass:(Class) aClass
                          error:(NSError *__autoreleasing *)error
{
    return json;
}

@end
