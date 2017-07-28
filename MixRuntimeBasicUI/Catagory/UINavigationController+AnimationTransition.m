//
//  UINavigationController+AnimationTransition.m
//  MixRuntimeBasicUI
//
//  Created by kong on 2017/7/25.
//  Copyright © 2017年 konglee. All rights reserved.
//

#import "UINavigationController+AnimationTransition.h"
#import <objc/runtime.h>

@implementation UINavigationController (AnimationTransition)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originSel = @selector(pushViewController:animated:);
        SEL newSel = @selector(at_pushViewController:animated:);
        Method originMethod = class_getInstanceMethod(class, originSel);
        Method newMethod = class_getInstanceMethod(class, newSel);
        //给当前类添加
        BOOL isSuccess = class_addMethod(class, originSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        if (isSuccess)
        {
            class_replaceMethod(class, newSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        }
        else
        {
            method_exchangeImplementations(originMethod, newMethod);
        }
    });
}

- (void)at_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}


@end
