//
//  Student.h
//  Test01
//
//  Created by apple on 2018/7/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject
@property(nonatomic,assign)NSInteger age;
@property (nonatomic,copy)NSString *name;

-(void)read;
+(void)write;
@end
