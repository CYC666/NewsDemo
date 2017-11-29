//
//  ExpenseRecord.h
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/26.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpenseRecord : NSObject

//金额
@property (nonatomic) NSString *operatevalue;
//时间
@property (nonatomic) NSString *createdate;
//头像
@property (nonatomic) NSString *headicon;
//昵称
@property (nonatomic) NSString *nickname;
//真实姓名
@property (nonatomic) NSString *realname;
//让利比例
@property (nonatomic) NSString *commission;

/********************************************/
//可撤单状态0  1
@property (nonatomic) NSString *paymentmark;

//可撤单ID
@property (nonatomic) NSString *consumptionid;
/********************************************/


///初始化
- (instancetype)initWithoperatevalue:(NSString *)operatevalue
                          createdate:(NSString *)createdate
                            headicon:(NSString *)headicon
                            nickname:(NSString *)nickname
                            realname:(NSString *)realname
                          commission:(NSString *)commission
                         paymentmark:(NSString *)paymentmark;


///初始化 //可撤单状态0  1
- (instancetype)initWithoperatevalue:(NSString *)operatevalue
                          createdate:(NSString *)createdate
                            headicon:(NSString *)headicon
                            nickname:(NSString *)nickname
                            realname:(NSString *)realname
                          commission:(NSString *)commission
                         paymentmark:(NSNumber *)paymentmark
                       consumptionid:(NSString *)consumptionid;

@end
