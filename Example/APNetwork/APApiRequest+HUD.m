//
//  APApiRequest+HUD.m
//  APNetwork
//
//  Created by ozr on 17/4/27.
//  Copyright © 2017年 673697831. All rights reserved.
//

#import "APApiRequest+HUD.h"
#import "APProgressHUD.h"

@implementation APApiRequest (HUD)

@dynamic hudFromView;

- (void)setHudFromView:(UIView *)hudFromView
{
    [APProgressHUD showHudWithView:hudFromView toRequest:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
