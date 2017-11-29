//
//  UIButton+addproty.m
//  YiYanYunGou
//
//  Created by admin on 16/4/14.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "UIButton+addproty.h"
#import <objc/runtime.h>

@implementation UIButton (addproty)
static char strAddrKeyA = 'a';
static char strAddrKeyB = 'b';
static char strAddrKeyC = 'c';
static char strAddrKeyD = 'd';
static char strAddrKeyE = 'e';
static char strAddrKeyF = 'f';

- (NSString *)relatedID{
    
    return objc_getAssociatedObject(self, &strAddrKeyA);
}
- (void)setRelatedID:(NSString *)relatedID{
    
    objc_setAssociatedObject(self, &strAddrKeyA, relatedID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (NSIndexPath *)indexPathBut{
    
    return objc_getAssociatedObject(self, &strAddrKeyB);
}
- (void)setIndexPathBut:(NSIndexPath *)indexPathBut{
    
    objc_setAssociatedObject(self, &strAddrKeyB, indexPathBut, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (NSString *)unitPrice{
    
    return objc_getAssociatedObject(self, &strAddrKeyC);
}
- (void)setUnitPrice:(NSString *)unitPrice{
    
    objc_setAssociatedObject(self, &strAddrKeyC, unitPrice, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)indexForParents{
    
    return objc_getAssociatedObject(self, &strAddrKeyD);
}
- (void)setIndexForParents:(NSString *)indexForParents{
    
    objc_setAssociatedObject(self, &strAddrKeyD, indexForParents, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (NSString *)indexForNow{
    
    return objc_getAssociatedObject(self, &strAddrKeyE);
}
- (void)setIndexForNow:(NSString *)indexForNow{
    
    objc_setAssociatedObject(self, &strAddrKeyE, indexForNow, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (NSString *)orderState{
    
    return objc_getAssociatedObject(self, &strAddrKeyF);
}
- (void)setOrderState:(NSString *)orderState{
    
    objc_setAssociatedObject(self, &strAddrKeyF, orderState, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



@end
