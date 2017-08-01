//
//  APProgressHUD.m
//  APNetwork
//
//  Created by ozr on 17/4/27.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import "APProgressHUD.h"

@interface APProgressHUD ()<APBaseRequestDelegate, APBaseRequestDelegate>

@property (nonatomic, strong) id<APBaseApiRequestProtocol> request;

@end

@implementation APProgressHUD

+ (void)showHudWithView:(UIView *)view toRequest:(id<APBaseApiRequestProtocol>)request
{
    __weak APProgressHUD *hud= [APProgressHUD showHUDAddedTo:view animated:YES];
    hud.request = request;
    [request addBaseRequestDelegate:hud];
}


- (void)requestDidSuccess:(id)sender responseObject:(id)responseObject
{
    self.request = nil;
    self.mode = MBProgressHUDModeText;
    self.labelText = @"完成";
    [self hide:YES afterDelay:2];
}

- (void)requestDidFailed:(id)sender error:(NSError *)error
{
    self.request = nil;
    self.mode = MBProgressHUDModeText;
    self.labelText = error.localizedDescription;
    [self hide:YES afterDelay:2];
}

- (void)requestDidCancel:(id)sender
{
    self.request = nil;
    [self hide:YES];
}

@end
