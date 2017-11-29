//
//  ExpenseRecord.m
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/26.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ExpenseRecord.h"

@implementation ExpenseRecord

///初始化
- (instancetype)initWithoperatevalue:(NSString *)operatevalue createdate:(NSString *)createdate headicon:(NSString *)headicon nickname:(NSString *)nickname realname:(NSString *)realname commission:(NSString *)commission paymentmark:(NSString *)paymentmark {
    
    if (self = [super init]) {
        
        _operatevalue = [NSString stringWithFormat:@"%@",operatevalue];
        _createdate = [NSString stringWithFormat:@"%@",createdate];
        _headicon = [NSString stringWithFormat:@"%@",headicon];
        _nickname = [NSString stringWithFormat:@"%@",nickname];
        _realname = [NSString stringWithFormat:@"%@",realname];
        _commission = [NSString stringWithFormat:@"%@",commission];
        _paymentmark = [NSString stringWithFormat:@"%@",paymentmark];
        
    }
    
    return self;
    
}


///初始化 //可撤单状态0  1
- (instancetype)initWithoperatevalue:(NSString *)operatevalue
                          createdate:(NSString *)createdate
                            headicon:(NSString *)headicon
                            nickname:(NSString *)nickname
                            realname:(NSString *)realname
                          commission:(NSString *)commission
                         paymentmark:(NSNumber *)paymentmark
                       consumptionid:(NSString *)consumptionid{

    if (self = [super init]) {
        
        _operatevalue = [NSString stringWithFormat:@"%@",operatevalue];
        _createdate = [NSString stringWithFormat:@"%@",createdate];
        _headicon = [NSString stringWithFormat:@"%@",headicon];
        _nickname = [NSString stringWithFormat:@"%@",nickname];
        _realname = [NSString stringWithFormat:@"%@",realname];
        _commission = [NSString stringWithFormat:@"%@",commission];
        _paymentmark = [NSString stringWithFormat:@"%@",paymentmark];
        _consumptionid = [NSString stringWithFormat:@"%@",consumptionid];
    }
    
    return self;
    
}


@end
