//
//  Person.h
//  Test01
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+KVO.h"

@interface Person : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)NSInteger age;
-(void)printInfo;
@end
