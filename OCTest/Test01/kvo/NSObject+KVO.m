//
//  NSObject+KVO.m
//  Test01
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString * const KVOClassPrefix = @"KVOClassPrefix_";
NSString *const  KVOAsociateObservers =@"KVOAsociateObservers";

@interface KVOObserverInfo:NSObject
@property (nonatomic,weak)NSObject *observer;
@property (nonatomic,copy)NSString *key;
@property (nonatomic,copy)PerObservingBlock block;
@end


@implementation KVOObserverInfo
-(instancetype)initWitObserver:(NSObject*)observer key:(NSString *)key block:(PerObservingBlock)block
{
    self=[super init];
    if (self) {
        _observer=observer;
        _key=key;
        _block=block;
    }
    return self;
}

@end




@implementation NSObject (KVO)

//属性的set方法名获取
static NSString *setterForGetter(NSString *getter)
{
    if (getter.length<=0) {
        return nil;
    }
    NSString *firstLetter=[[getter substringToIndex:1]uppercaseString];
    NSString *remainingLetters=[getter substringFromIndex:1];
    NSString *setter=[NSString stringWithFormat:@"set%@%@:",firstLetter,remainingLetters];
    return setter;
}

static NSString * getterForSetter(NSString *setter)
{
    if (setter.length<=0||![setter hasPrefix:@"set"]||![setter hasSuffix:@":"]) {
        return nil;
    }
    NSRange range=NSMakeRange(3, setter.length-4);
    NSString *key=[setter substringWithRange:range];
    NSString *fisrtLetter=[[key substringToIndex:1]lowercaseString];
    key=[key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:fisrtLetter];
    return key;
}

static Class kvo_class(id self ,SEL _cmd)
{
    return class_getSuperclass(object_getClass(self));
}

static void  kvo_setter(id self,SEL _cmd,id newValue)
{
    NSString *setterName=NSStringFromSelector(_cmd);
    NSString *getterName=getterForSetter(setterName);
    if (!getterName) {
        NSString *reason=[NSString stringWithFormat:@"Object %@ does not have setter %@",self,setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
        return;
    }
    
    id oldValue=[self valueForKey:getterName];
    struct objc_super superclazz={
        .receiver=self,
        .super_class=class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendSuperCasted)(void *,SEL,id)=(void *)objc_msgSendSuper;
    objc_msgSendSuperCasted(&superclazz,_cmd,newValue);
    
    
    NSMutableArray *observers=objc_getAssociatedObject(self, (__bridge const void *)(KVOAsociateObservers));
    for (KVOObserverInfo *each in observers) {
        if ([each.key isEqualToString:getterName]) {
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               each.block(self, getterName, oldValue, newValue);
           });
        }
    }
    
}

-(void)per_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(PerObservingBlock)block
{
    NSString *setter=setterForGetter(key);
    SEL setterSelector=NSSelectorFromString(setter);
    Method setterMethod=class_getInstanceMethod([self class], setterSelector);
    if (!setterMethod) {
        NSString *reason=[NSString stringWithFormat:@"Object %@ does not have a setter for key %@",self,key];
        @throw  [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
        return;
    }
    
    Class classzz=object_getClass(self);
    NSString *classzzName=NSStringFromClass(classzz);
    if (![classzzName hasPrefix:KVOClassPrefix]) {
        
        classzz=[self makeKVOClassWithOriginalClassName:classzzName];
        object_setClass(self, classzz);
    }
    
    if (![self hasSelector:setterSelector]) {
        const char *types=method_getTypeEncoding(setterMethod);
        class_addMethod(classzz, setterSelector, (IMP)kvo_setter, types);
    }
    
    KVOObserverInfo *info=[[KVOObserverInfo alloc]initWitObserver:observer key:key block:block];
    NSMutableArray *observers=objc_getAssociatedObject(self, (__bridge const void *)(KVOAsociateObservers));
    if (!observers) {
        observers=[NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(KVOAsociateObservers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [observers addObject:info];
    
}

-(void)per_removeObserver:(NSObject *)observer forKey:(NSString *)key
{
    NSMutableArray *observers=objc_getAssociatedObject(self, (__bridge const void *)(KVOAsociateObservers));
    KVOObserverInfo * infoToRemove;
    for (KVOObserverInfo *info in observers) {
        if (info.observer==observer&&[info.key isEqual:key]) {
            infoToRemove=info;
            break;
        }
    }
    
    [observers removeObject:infoToRemove];
    Class cl=[self class];
    object_setClass(self,cl);
}


-(Class)makeKVOClassWithOriginalClassName:(NSString *)originalClassName
{
    NSString *kvoClassName=[KVOClassPrefix stringByAppendingString:originalClassName];
    Class classzz=NSClassFromString(kvoClassName);
    if (classzz) {
        return classzz;
    }
    
    Class originalClasszz=object_getClass(self);
    Class kvoClasszz=objc_allocateClassPair(originalClasszz, kvoClassName.UTF8String, 0);
    Method classzzMethod=class_getInstanceMethod(originalClasszz, @selector(class));
    const  char *types=method_getTypeEncoding(classzzMethod);
    class_addMethod(kvoClasszz, @selector(class), (IMP)kvo_class,types);
    
    objc_registerClassPair(kvoClasszz);
    return kvoClasszz;
}


-(BOOL)hasSelector:(SEL)selector
{

    Class clazz=object_getClass(self);
    unsigned int methodCount=0;
    Method * methodList=class_copyMethodList(clazz, &methodCount);
    for (unsigned int i =0; i<methodCount; i++) {
        SEL thisSelector=method_getName(methodList[i]);
        if (thisSelector==selector) {
            free(methodList);
            return YES;
        }
    }
    free(methodList);
    return NO;
}



@end
