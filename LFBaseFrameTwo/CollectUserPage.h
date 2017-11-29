//
//  CollectUserPage.h
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/26.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectUserPage : NSObject

//主键编号
@property (nonatomic) NSString *userid;
//昵称（商户才有的）
@property (nonatomic) NSString *nickname;
//真实姓名
@property (nonatomic) NSString *realname;
//头像
@property (nonatomic) NSString *headicon;
//手机
@property (nonatomic) NSString *mobile;
//省份
@property (nonatomic) NSString *provincename;
//城市
@property (nonatomic) NSString *cityname;
//区县
@property (nonatomic) NSString *countyname;
//详细地址
@property (nonatomic) NSString *address;
//创建时间
@property (nonatomic) NSString *createdate;




///初始化
- (instancetype)initWithuserid:(NSString *)userid
                      nickname:(NSString *)nickname
                      realname:(NSString *)realname
                      headicon:(NSString *)headicon
                        mobile:(NSString *)mobile
                  provincename:(NSString *)provincename
                      cityname:(NSString *)cityname
                    countyname:(NSString *)countyname
                       address:(NSString *)address
                    createdate:(NSString *)createdate;


@end
