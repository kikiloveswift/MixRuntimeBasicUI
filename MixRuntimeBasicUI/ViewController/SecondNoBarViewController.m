//
//  SecondNoBarViewController.m
//  MixRuntimeBasicUI
//
//  Created by kong on 2017/7/25.
//  Copyright © 2017年 konglee. All rights reserved.
//

#import "SecondNoBarViewController.h"
#import "ThirdWithBarViewController.h"

@interface SecondNoBarViewController ()

@end

@implementation SecondNoBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configSetting];
    [self openURL];
}

- (void)openURL
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alipay://"]];
}

- (void)configSetting
{
    self.navigationController.navigationBarHidden = true;
}
- (IBAction)popAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pushAction:(id)sender
{
    ThirdWithBarViewController *thVC = [ThirdWithBarViewController new];
    [self.navigationController pushViewController:thVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
