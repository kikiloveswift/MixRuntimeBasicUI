//
//  Person.h
//  MixRuntimeBasicUI
//
//  Created by kong on 2017/7/26.
//  Copyright © 2017年 konglee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

- (void)printInfo;

@end
