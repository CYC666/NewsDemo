//
//  BusinessScopeCollection.m
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/24.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "BusinessScopeCollection.h"
#import "BusinessScope.h"

@implementation BusinessScopeCollection

static BusinessScopeCollection *instance;
+ (BusinessScopeCollection *)sharedInstance{
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        if (!instance) {
            instance = [[BusinessScopeCollection alloc]init];
        }
    });
    return instance;
}
+ (id)allocWithZone:(struct _NSZone *)zone{
    //使用GCD实现多线程下的单例
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        if (!instance) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

- (id)init{
    if (self = [super init]) {
        //初始化属性变量
        _allScopeArray = [NSMutableArray array];

    }
    return self;
}

@end
