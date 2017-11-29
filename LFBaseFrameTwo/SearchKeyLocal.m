//
//  SearchKeyLocal.m
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "SearchKeyLocal.h"

@implementation SearchKeyLocal


- (instancetype)initWithTime:(NSString *)time searchStr:(NSString *)searchStr{
    
    if (self = [super init]) {
        _time = time;
        _searchStr = searchStr;
        
    }
    
    return self;
}

@end
