//
//  Person.m
//  MixRuntimeBasicUI
//
//  Created by kong on 2017/7/26.
//  Copyright © 2017年 konglee. All rights reserved.
//

#import "Person.h"

struct TestMethod
{
    char *m1;
    int num;
};

struct B
{
    struct B *pb;
    int a;
    int b;
};

typedef struct TestMethod *mthod;

@interface NSObject()
{
    NSString *_password;
}

@property (nonatomic, assign) NSUInteger salary;


@end

@implementation Person

- (instancetype)init
{
    if (self = [super init])
    {
        struct TestMethod t1 = {"wer",10};
        mthod m1 = &t1;
        int b = (*m1).num;
        printf("b = %d",b);
        
        NSLog(@"__LP64__ =%d",__LP64__);
        NSLog(@"OBJC_OLD_DISPATCH_PROTOTYPES = %d",OBJC_OLD_DISPATCH_PROTOTYPES);
        
        [self testStruct];
    }
    return self;
}

- (void)printInfo
{
    NSLog(@"PRINT");
}

- (void)testStruct
{
    struct B bb1;
    bb1.a = 2;
    bb1.b = 3;
    bb1.pb = &bb1;
    
    
}

@end
