//
//  MBlockModel.h
//  Test01
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^MBlock)(void);
@interface MBlockModel : NSObject
@property (nonatomic,copy)MBlock block;

-(void)test;
-(void)testBlock;
@end
