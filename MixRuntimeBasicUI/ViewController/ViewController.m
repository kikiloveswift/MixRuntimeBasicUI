//
//  ViewController.m
//  MixRuntimeBasicUI
//
//  Created by kong on 2017/7/25.
//  Copyright © 2017年 konglee. All rights reserved.
//

#import "ViewController.h"
#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height

#import "SecondNoBarViewController.h"
#import "ThirdWithBarViewController.h"
#import "Person.h"
#import <objc/runtime.h>

#import "Female.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *stableView;

@end



@implementation ViewController

void objc_setClassHandler(int (*userSuppliedHandler)(const char *))
{
    NSLog(@"coming");
}

//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class cls = [self class];
//        Method m_o = class_getInstanceMethod(cls, @selector(objc_setClassHandler:));
//        Method m_r = class_getInstanceMethod(cls, @selector(u_objc_setClassHandler:));
//        BOOL isSuccess = class_addMethod(cls, @selector(u_objc_setClassHandler:), method_getImplementation(m_o), method_getTypeEncoding(m_o));
//        if (isSuccess)
//        {
//            class_replaceMethod(cls, @selector(objc_setClassHandler:), method_getImplementation(m_r), method_getTypeEncoding(m_r));
//        }
//        else
//        {
//            method_exchangeImplementations(m_o, m_r);
//        }
//        
//    });
//}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configSetting];
    [self initUI];
    [self testIvar];
}

- (void)configSetting
{
    self.navigationController.navigationBarHidden = false;
}

- (void)initUI
{
    _stableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KWidth, 180) style:UITableViewStylePlain];
    _stableView.delegate = self;
    _stableView.rowHeight = 60.0f;
    _stableView.dataSource = self;
    [self.view addSubview:_stableView];
}

#pragma Mark --Runtime
- (void)testIvar
{
    Person *person = [Person new];
    person.name = @"kl";
    //获取实例变量
    Ivar iv = class_getInstanceVariable([person class], "_name");
    //获取类的实例变量
    Ivar iv1 = class_getClassVariable([person class], "_name");
    NSLog(@"iv1 is %@",iv1);// NULL
    id obj = object_getIvar(person, iv);
    NSLog(@"obj is %@",obj); //kl
    
    //更变变量的值
    object_setIvar(person, iv, @"12");
    NSLog(@"person's name is %@",person.name);
    
//    NSString *value;
//    object_getInstanceVariable(person, "_name", (void *)&value);
//    NSLog(@"value is %@",value);
    
    Class A = objc_getClass("Person");
    
    Class B = objc_getMetaClass("Peson");
    
    NSLog(@"A is %@,B is %@",A,B);
//    objc_setClassHandler(fun("name"));
    
    NSArray *arr = ClassGetSubclasses([Person class]);
    NSLog(@"arr is %@",arr);
    
    Female *fmale = [[Female alloc] init];
    
    
}

NSArray *ClassGetSubclasses(Class parentClass)
{
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    classes = (Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++)
    {
        Class superClass = classes[i];
        do
        {
            superClass = class_getSuperclass(superClass);
        } while(superClass && superClass != parentClass);
        
        if (superClass == nil)
        {
            continue;
        }
        
        [result addObject:classes[i]];
    }
    
    free(classes);
    
    return result;
}




+ (BOOL)isWinterOrSummerTime
{
    //冬 == yes  夏天 == no
//    NSDate *da = [NSDate date];
//    NSUInteger uday = [[NSCalendar currentCalendar] firstWeekday];
//    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitSecond|NSCalendarUnitMinute;
//    NSDateComponents *components = [calendar components:unit fromDate: [NSDate date]];
    
//    components.era

    
    
    return false;
}

+ (NSTimeInterval)testTimeInterval
{
    NSString *str = @"2017-07-25T08:34:19.307Z";
    NSRange range = [str rangeOfString:@"."];
    //取到 2017-07-23T08:50:16
    NSString *timeStr = [str copy];
    if (range.length > 0)
    {
        timeStr = [str substringToIndex:range.location];
    }
    if ([timeStr containsString:@"T"])
    {
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    }
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:timeStr];
    
    //转为当地时区
    NSTimeZone *nowTimeZone = [NSTimeZone timeZoneWithName:@"EST"];
    NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:date];
    NSDate *newDate = [date dateByAddingTimeInterval:timeOffset];
    
    
    NSTimeInterval timeInterval = [newDate timeIntervalSince1970];
    return timeInterval;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *identify = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            SecondNoBarViewController *sVC = [SecondNoBarViewController new];
            [self.navigationController pushViewController:sVC animated:YES];
        }
            break;
        case 1:
        {
            ThirdWithBarViewController *thVC = [ThirdWithBarViewController new];
            [self.navigationController pushViewController:thVC animated:YES];
            
        }
            break;

        default:
            break;
    }
}

@end
