//
//  SF001.m
//  Test01
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SF001.h"

@implementation SF001




//字符反转
char *  characterReversal(char *ch)
{
    //指向第一个字符
    char *begin=ch;
    //指向最后一个字符
    char *end=ch+strlen(ch)-1;
    while (begin<end) {
        char temp =*begin;
        //指针加一，不是指针指向对象内容的值加一
        *begin++=*end;
        //指针减一，不是指针指向对象内容的值减一
        *end--=temp;
    }
    return ch;
}

////整型数组反转
 void intReversal(int num[],int length)
{
//    int num[6]={1,2,3,4,5,6};
    int n=length;
    int *begin=num;//整型数组第一个元素的指针，数组名默认是第一个元素指针(*begin=1)
    int *end=num+n-1;//指向整型数组最后一个元素的指针，指针向后偏移n-1个位置，指向数组元素(*end=6)
    while (begin<end) {//当开始指针变量小于最后指针变量
        int temp=*begin;//临时变量保存第一个指针指向的内容
        *begin++=*end;//(等价于 *bengin=*end;begin++)指针自增一个，指向下一个元素，同时把下一个元素改成最后一个指针对象内容
        *end--=temp;//(等价于*end=temp;end--)指针自减一个，指向前一个元素，同时把前一个元素改成临时变量的内容（刚开始的元素赋值的临时变量)
//        begin++;
//        end--;
    }
    for (int i=0;i<n;i++)
    {
        printf("%d",num[i]);
    }
}




@end
