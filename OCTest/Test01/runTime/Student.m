//
//  Student.m
//  Test01
//
//  Created by apple on 2018/7/14.
//  Copyright © 2018年 apple. All rights reserved.
//
/*
 消息转发机制
 */

#import "Student.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Teacher.h"
@interface Student()
@property (nonatomic,strong)Teacher *teacher;
@end

@implementation Student
@dynamic name;
//-(void)read
//{
//
//    NSLog(@"hello world");
//}

void addwelcome()
{
   
   NSLog(@"wwww");
}


 void addHello()
{
    
    NSLog(@"aaaaaa");
}

void addWrite()
{
    
    NSLog(@"wwwwwwwwwwww");
}


-(void)reRead:(NSString *)name
{
    
    NSLog(@"rrrrrrrrrrr");
    
}

//1、动态方法解析
//+(BOOL)resolveInstanceMethod:(SEL)sel
//{
//    NSLog(@"resolveClassMethod %@",NSStringFromSelector(sel));
//
//    if (sel==@selector(read)) {
//        class_addMethod([self class], sel,(IMP)addHello, 0);
//        return YES;
//    }
//
//    return [super resolveInstanceMethod:sel];
//}

+(BOOL)resolveClassMethod:(SEL)sel
{
    NSLog(@"resolveClassMethod %@",NSStringFromSelector(sel));
    if (sel==@selector(write)) {
        class_addMethod([self superclass], sel, (IMP)addWrite, 0);
        return YES;
    }
    return [super resolveClassMethod:sel];
}

//2、继续转发
-(id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector==@selector(read)) {
        Teacher *teacher=[[Teacher alloc]init];
        return teacher;
    }
    return [super forwardingTargetForSelector:aSelector];

}


//-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
//{
//    NSString *methd=NSStringFromSelector(aSelector);
//    if ([methd isEqualToString:@"read"]) {
//        NSMethodSignature *sing=[NSMethodSignature signatureWithObjCTypes:"v@:@"];
//        return sing;
//    }
//    return nil;
//}


//3、消息重定向，完全转发
//-(void)forwardInvocation:(NSInvocation *)anInvocation
//{
//    SEL sel=@selector(read);
//
//    NSMethodSignature *sing=[NSMethodSignature signatureWithObjCTypes:"v@:@"];
//    anInvocation=[NSInvocation invocationWithMethodSignature:sing];
//    [anInvocation setTarget:self];
//
//    [anInvocation setSelector:@selector(read)];
//    NSString *name=@"特奥会";
//    [anInvocation setArgument:&name atIndex:2];
//    if ([self respondsToSelector:sel]) {
//        [anInvocation invokeWithTarget:self];
//        return;
//    }
//    else{
//        Teacher *teacher=[[Teacher alloc]init];
//        if ([teacher respondsToSelector:sel]) {
//            [anInvocation invokeWithTarget:teacher];
//            return;
//        }
//
//    }
//
//    [super forwardInvocation:anInvocation];
//}

@end
