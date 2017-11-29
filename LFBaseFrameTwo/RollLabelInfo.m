//
//  RollLabelInfo.m
//  YiYanYunGou
//
//  Created by admin on 16/9/30.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "RollLabelInfo.h"

@implementation RollLabelInfo


- (instancetype)initWithAnewsid:(NSString *)newsid
                       category:(NSString *)category
                       fullhead:(NSString *)fullhead
                          times:(NSString *)times{
    
    if (self = [super init]) {
        _newsid = newsid;
        _category = category;
        _fullhead = fullhead;
         _times = times;
        
    }
    
    return self;
    
}

@end
