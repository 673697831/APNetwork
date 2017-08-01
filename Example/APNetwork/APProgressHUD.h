//
//  APProgressHUD.h
//  APNetwork
//
//  Created by ozr on 17/4/27.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "APApiRequest.h"

@interface APProgressHUD : MBProgressHUD

+ (void)showHudWithView:(UIView *)view toRequest:(id<APBaseApiRequestProtocol>)request;

@end
