//
//  Person.m
//  Test01
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>


@implementation Person



-(void)printInfo
{
    NSString *isa=NSStringFromClass(object_getClass(self));
    NSString *sup=NSStringFromClass(class_getSuperclass(object_getClass(self)));
    NSLog(@"is %@  superclass %@",isa,sup);
    NSLog(@"self  %@ self class %@",self ,[self superclass]);
    
    IMP ageimp=(class_getMethodImplementation(object_getClass(self), @selector(setAge:)));
    
    NSLog(@" age settter func  %p",ageimp);
    NSLog(@"name setter func %p",class_getMethodImplementation(object_getClass(self), @selector(setName:)));
    
    
}

//监听之前
//2018-07-15 14:29:14.984957+0800 Test01[1960:56188] is Person  superclass NSObject
//2018-07-15 14:29:14.985351+0800 Test01[1960:56188] self  <Person: 0x60000022d1e0> self class NSObject
//2018-07-15 14:29:14.986148+0800 Test01[1960:56188]  age settter func  0x10704fbb0
//2018-07-15 14:29:14.987194+0800 Test01[1960:56188] name setter func 0x10704fb50

//2018-07-15 14:29:51.424575+0800 Test01[1960:56188] obsever  keyPath :name  change:{
//    kind = 1;
//    new = world;
//    old = hello;
//} object:<Person: 0x60000022d1e0>

//监听之后
//2018-07-15 14:29:55.407086+0800 Test01[1960:56188] is NSKVONotifying_Person  superclass Person
//2018-07-15 14:29:55.407949+0800 Test01[1960:56188] self  <Person: 0x60000022d1e0> self class NSObject
//2018-07-15 14:29:55.409022+0800 Test01[1960:56188]  age settter func  0x10704fbb0
//2018-07-15 14:29:55.409393+0800 Test01[1960:56188] name setter func 0x10739c666

//移除监听之后
//2018-07-15 14:29:55.409950+0800 Test01[1960:56188] is Person  superclass NSObject
//2018-07-15 14:29:55.410437+0800 Test01[1960:56188] self  <Person: 0x60000022d1e0> self class NSObject
//2018-07-15 14:29:55.410733+0800 Test01[1960:56188]  age settter func  0x10704fbb0
//2018-07-15 14:29:55.411066+0800 Test01[1960:56188] name setter func 0x10704fb50


@end
