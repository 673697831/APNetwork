//
//  APDownloadImageRequest.h
//  AiPai
//
//  Created by ozr on 17/3/17.
//  Copyright © 2017年 ozr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APNetworkProtocol.h"

@interface APDownloadImageRequest : NSObject<APBaseApiRequestProtocol>

- (instancetype)initWithImageUrl:(NSString *)imageUrl;

@property (nonatomic, copy) NSString *imageUrl;
//成功回调
@property (nonatomic, copy) void (^successBlock)(id);
//失败回调
@property (nonatomic, copy) void (^failureBlock)(id, NSError *);
//取消回调 默认为空
@property (nonatomic, copy) void (^cancelBlock)();

@end