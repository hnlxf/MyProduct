//
//  ViewController.m
//  Test01
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "Person.h"
#import "MBlockModel.h"

@interface ViewController ()
@property (nonatomic,strong)Person *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self kvoTest];
    
//    [self customKVO];
    
    
    
    [self myBlock];
    // Do any additional setup after loading the view, typically from a nib.
}

//消息转发机制
-(void)runTimeTest
{
    Student *stu=[[Student alloc]init];
    [stu read];
    [Student write];
    //    objc_msgSend(stu, @selector(read));
}

//kvo 机制
-(void)kvoTest
{

    _person=[[Person alloc]init];
    _person.age=12;
    _person.name=@"hello";
    [_person printInfo];
    
    [_person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    //重新赋值后，才调用observeValueForKeyPath
    _person.name=@"world";
    
    [_person printInfo];
    
    [_person removeObserver:self forKeyPath:@"name"];
    [_person printInfo];
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{

    NSLog(@"obsever  keyPath :%@  change:%@ object:%@",keyPath,change,object);
}

//自定义kvo
-(void)customKVO
{

    _person=[[Person alloc]init];
    _person.name=@"boy";
    [_person printInfo];
    [_person per_addObserver:self forKey:@"name" withBlock:^(id observedObject, NSString *observedKey, id oldValue, id newValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"old value %@  new value %@  objc %@",oldValue,newValue,observedObject);
        });
    }];
    
    _person.name=@"girl";
    
    [_person printInfo];
    [_person per_removeObserver:self forKey:@"name"];
    [_person printInfo];
}

//Block
-(void)myBlock
{
    MBlockModel *mb=[[MBlockModel alloc]init];
    //block 方法实现，只有先实现，才能回调到，不做实现，无响应
    mb.block = ^{
        NSLog(@"test block!");
    };
    //block 方法回调
    [mb test];
    
    [mb testBlock];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
