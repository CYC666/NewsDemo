//
//  UIImageView+addproty.m
//  YiYanYunGou
//
//  Created by admin on 16/8/19.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "UIImageView+addproty.h"
#import <objc/runtime.h>

@implementation UIImageView (addproty)

static char strAddrKeyZ = 'z';



- (NSString *)relatedID{
    
    return objc_getAssociatedObject(self, &strAddrKeyZ);
}
- (void)setRelatedID:(NSString *)relatedID{
    
    objc_setAssociatedObject(self, &strAddrKeyZ, relatedID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
