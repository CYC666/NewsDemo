//
//  MessagePrivateInfo.m
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "MessagePrivateInfo.h"

@implementation MessagePrivateInfo

- (instancetype)initWithlogid:(NSString *)logid title:(NSString *)title content:(NSString *)content userid:(NSString *)userid createdate:(NSString *)createdate readmark:(NSString *)readmark {
    
    if (self = [super init]) {
        _logid = [NSString stringWithFormat:@"%@",logid];
        _title = [NSString stringWithFormat:@"%@",title];
        _content = [NSString stringWithFormat:@"%@",content];
        _userid = [NSString stringWithFormat:@"%@",userid];
        _createdate = [NSString stringWithFormat:@"%@",createdate];
        _readmark = [NSString stringWithFormat:@"%@",readmark];
        
    }
    
    return self;
}

@end
