//
//  APViewController.m
//  APNetwork
//
//  Created by 673697831 on 04/26/2017.
//  Copyright (c) 2017 673697831. All rights reserved.
//

#import "APViewController.h"
#import "APViewModel.h"
#import "APApiRequest.h"
#import "APApiRequest+HUD.h"

@interface APViewController ()

@property (nonatomic, strong) APViewModel *viewModel;

@end

@implementation APViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.viewModel = [APViewModel new];
    
    APApiRequest *request = [self.viewModel loadIndexPageWithSuccess:nil failure:nil];
    request.hudFromView = self.view;
    [request start];
}

@end
