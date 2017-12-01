//
//  SellEnumModel.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/9/25.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SellEnumModel.h"

@implementation SellEnumModel


- (NSString *)TypeId {
    
    if (_TypeId == nil) {
        _TypeId = @"";
    }
    return _TypeId;
    
}

- (NSString *)TypeName {
    
    if (_TypeName == nil) {
        _TypeName = @"";
    }
    return _TypeName;
    
}

- (NSString *)SortCode {
    
    if (_SortCode == nil) {
        _SortCode = @"";
    }
    return _SortCode;
    
}






@end
