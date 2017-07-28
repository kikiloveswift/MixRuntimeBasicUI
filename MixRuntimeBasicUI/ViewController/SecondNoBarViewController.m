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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
