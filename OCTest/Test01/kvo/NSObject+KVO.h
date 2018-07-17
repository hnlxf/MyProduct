//
//  NSObject+KVO.h
//  Test01
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//
/*
 自定义kvo
 */
#import <Foundation/Foundation.h>

typedef void (^PerObservingBlock)(id observedObject,NSString *observedKey,id oldValue,id newValue);

@interface NSObject (KVO)

-(void)per_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(PerObservingBlock)block;
-(void)per_removeObserver:(NSObject *)observer forKey:(NSString *)key;

@end
