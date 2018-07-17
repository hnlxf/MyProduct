//
//  MBlockModel.m
//  Test01
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MBlockModel.h"

static int a=1;
int b=1;
typedef void(^TestBlock)(int m);
@interface MBlockModel()
{
    int c;
}
@property (nonatomic,assign)int k;
@end


@implementation MBlockModel
-(void)test
{
    if (self.block) {
        self.block();
    }
}


/**
 a静态全局变量，无需加__block 可改变变量的值
 b全局变量，无需加__block 可改变变量的值
 c类内部私有全局变量，无需加__block 可改变变量的值
 d静态变量，无需加__block 可改变变量的值
 e局部变量(自动变量)，不加__block，值不改变
 a,b,c作用域广，被block 捕获，在block内执行++操作，结束后依旧可以保存值
 自动变量是以值的方式传递到block 的构造函数里面，block 只捕获block中会用到的变量，由于捕获到的只是自动变量的值，
 并非内存地址，所以block 内部不能改变自动变量的值。
 block 捕获的外部变量可以改变的值是：静态变量，静态全局变量，全局变量.函数参数
 静态变量传递给block 是内存地址值，所以可以在block 内部直接改变值。
 block 改变变量值有2种方式，1.传递内存地址指针到block，2.改变存储区方式（__block）.
 NSMutableString, NSMutableArray： block 截获NSMutableString、NSMutableArray类对象用的结构体实例指针
 */
-(void)testBlock
{
   
    //结果输出test1111,加__block 修饰符，值改变
    NSString *test = @"test1111";
    NSMutableString *str=[[NSMutableString alloc]initWithString:@"hello"];
    c=1;
   __block int e=1;
    static int d=1;
    TestBlock block = ^(int m){
       
//        test=@"33333333";
        a++;
        b++;
        c++;
         d++;
//        e++;
         m=5;
//         m=e;
        [str appendString:@"world"];
        dispatch_sync(dispatch_queue_create("jd.test", DISPATCH_QUEUE_SERIAL), ^{
            NSLog(@"内 %@ %d  %d  %d %d %d %@ %d %p",test,a,b,c,d,e,str,m,&e);
        });
    };
    
    a++;
    b++;
    c++;
    d++;
    e++;
    test = @"test2222";
    [str appendString:@"world"];
    NSLog(@"外 %@ %d %d %d %d %d %@",test,a,b,c,d,e,str);
    block(4);
    
//
//    2018-07-16 23:11:51.151153+0800 Test01[3750:99857] 外 test2222 2 2 2 2 2 helloworld
//    2018-07-16 23:11:51.151453+0800 Test01[3750:99857] 内 test1111 3  3  3 3 1 helloworldworld
}


@end
