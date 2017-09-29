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
#include <pthread.h>



@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,NSPortDelegate>

@property (nonatomic, strong) UITableView *stableView;

@end


//结构体
typedef struct
{
    int girl_age;
}GF;

//结构体数组
struct Boys
{
    int age;
    int number;
    GF *gf; //这个是结构体指针
} Firend[10];





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
    
    NSDate *date = [NSDate date];
    NSTimeInterval timeintval = [date timeIntervalSince1970];
    [ViewController getEasternDateWithTimeStamp:timeintval withFormatter:nil];
    
    [ViewController testTimeInterval];
    [self getRunLoopMSG];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

//TODO: runloop
- (void)getRunLoopMSG
{
    /*
     struct _opaque_pthread_t {
        long __sig;
        struct __darwin_pthread_handler_rec  *__cleanup_stack;
        char __opaque[__PTHREAD_SIZE__];
    };
     */
    //获取当前线程
    pthread_t thread = pthread_self();
    printf("%ld, %s\n",thread -> __sig,thread -> __opaque);
    
    //获取当前runloop
    CFRunLoopRef runloopRef = CFRunLoopGetCurrent();
    
//    CFMutableSetRef modeSet = runloopRef -> _commonModes;
    
//    CFRunLoopObserverRef observer = CFRunLoopAddObserver(<#CFRunLoopRef rl#>, <#CFRunLoopObserverRef observer#>, <#CFRunLoopMode mode#>)

}

void runloopCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    printf("\n");
    switch (activity)
    {
        case kCFRunLoopEntry:
        {
            printf("1kCFRunLoopEntry 即将进入loop");
        }
            break;
        case kCFRunLoopExit:
        {
            printf("6kCFRunLoopExit 即将退出runloop");
        }
            break;
        case kCFRunLoopAfterWaiting:
        {
            printf("5kCFRunLoopAfterWaiting 刚从休眠中唤醒");
        }
            break;
        case kCFRunLoopBeforeTimers:
        {
            printf("2kCFRunLoopBeforeTimers 即将处理timer");
        }
            break;
        case kCFRunLoopBeforeSources:
        {
            printf("3kCFRunLoopBeforeSources 即将处理Source");
        }
            break;
        case kCFRunLoopBeforeWaiting:
        {
            printf("4kCFRunLoopBeforeWaiting 即将进入休眠");
        }
            break;

        default:
        {
            printf("kCFRunLoopAllActivities");
        }
            break;
    }
    
}
- (void)tapAction
{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(observeCurrentRunloop) object:nil];
    [thread start];
    
    
}
- (void)observeCurrentRunloop
{
    NSLog(@"***CurrentThread is %@",[NSThread currentThread]);
    if ([[NSThread currentThread] isMainThread])
    {
        NSLog(@"****BAD Main Thread");
    }
    NSRunLoop *myRunloop = [NSRunLoop currentRunLoop];
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL,NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runloopCallback, &context);
    if (observer)
    {
        CFRunLoopRef cfloop = [myRunloop getCFRunLoop];
        CFRunLoopAddObserver(cfloop, observer, kCFRunLoopDefaultMode);
    }
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];
    NSInteger loopCount = 10;
    do{
        [myRunloop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//        [myRunloop run];
//        [myRunloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        loopCount --;
        CFRunLoopStop([myRunloop getCFRunLoop]);
    } while (loopCount);
}



- (void)fireTimer:(NSTimer *)timer
{
    NSLog(@"\nfire~~~~\n");
}

//解释为啥runloop会退出
- (void)basicThreadMain
{
    BOOL done = NO;
    do
    {
        SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);
        //如果source明确的在runloop中停止了或者没有source或者没有timers 继续往下走，或者退出
        if (result == kCFRunLoopRunStopped || result == kCFRunLoopRunFinished)
        {
            done = YES;
        }
    }
    while (!done);
}

//退出Runloop






- (void)testMH
{
    for (int i = 0; i < 10; i ++)
    {
        //Firend[i].gf 是个结构体指针，单凡是指针使用之前必须得初始化 也就是为指针分配内存
        Firend[i].gf = (GF *)malloc(sizeof(GF *));
        if (Firend[i].gf == NULL)
        {
            return;
        }
        //Firend[i].gf 是个结构体指针，结构体指针获取成员，必须用 -> 指向符号
        Firend[i].gf->girl_age = i +20;
        //(*Firend[i].gf).girl_age = i + 20;//或者用这种 一个指针 指向结构体 就是结构体指针，*结构体指针，就是获取结构体
        printf("梦航第(%d)Firend gf age is %d\n",(i+1),Firend[i].gf->girl_age);
    }
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
//    Female *fmale = [[Female alloc] init];

    IMP fp = class_getMethodImplementation([Person class], @selector(printInfo));
    
    objc_property_t pr = class_getProperty([Person class], "_name");
    
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
//    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour| NSCalendarUnitSecond|NSCalendarUnitMinute;
//    NSDateComponents *components = [calendar components:unit fromDate: [NSDate date]];
    
//    components.era

    
    
    return false;
}

+ (NSTimeInterval)testTimeInterval
{
    NSString *str = @"2017-08-28T20:55:52.5939154-05:00";
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
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
//    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:timeStr];
    
    //转为当地时区
    NSTimeZone *nowTimeZone = [NSTimeZone timeZoneWithName:@"EST"];
    NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:date];
    NSDate *newDate = [date dateByAddingTimeInterval:timeOffset];
    //这个newDate可不是美东时区的Date date永远都是0时区的，具体的时区 是你指定的时区 或加 或减而形成的，下面是一些解释
    
    NSTimeInterval timeInterval = [newDate timeIntervalSince1970];
   
    NSDateFormatter *datefor1 = [NSDateFormatter new];
    datefor1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //因为newDate是0时区的Date,你已经通过199行代码，已经减过了，所以 你再次转为字符串 需要用0时区的格式来格式化
//    datefor1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSString *tstr = [datefor1 stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    NSLog(@"tstr is %@",tstr);

    return timeInterval;
}

+(NSString *)getEasternDateWithTimeStamp:(NSTimeInterval)timeStampStr withFormatter:(NSString *)Formatter
{
//    long long date = timeStampStr/1000;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timeStampStr];
    
    //转为美东时区
    NSTimeZone *nowTimeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
//    NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:detaildate];
//    NSDate *newDate = [detaildate dateByAddingTimeInterval:timeOffset];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = nowTimeZone;
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
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
