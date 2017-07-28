//
//  ThirdWithBarViewController.m
//  MixRuntimeBasicUI
//
//  Created by kong on 2017/7/25.
//  Copyright © 2017年 konglee. All rights reserved.
//

#import "ThirdWithBarViewController.h"

@interface ThirdWithBarViewController ()

@end

@implementation ThirdWithBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configSetting];
}

- (void)configSetting
{
    self.navigationController.navigationBarHidden = false;
    self.title = @"3带头";
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
