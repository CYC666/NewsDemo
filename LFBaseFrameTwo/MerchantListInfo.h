//
//  MerchantListInfo.h
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/29.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantListInfo : NSObject

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
//总的营业额
@property (nonatomic) NSString *consumptiontotal;
//店铺与当前手机的距离
@property (nonatomic) NSString *distance;
// 营业时间
@property (nonatomic) NSString *businessHours;


/****************************经纬度**********/
@property (nonatomic) NSString *precision;
@property (nonatomic) NSString *latitude;
/****************************经纬度**********/


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
                    createdate:(NSString *)createdate
              consumptiontotal:(NSString *)consumptiontotal
                      distance:(NSString *)distance
                 businessHours:(NSString *)businessHours;

/****************************经纬度**********/
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
                    createdate:(NSString *)createdate
              consumptiontotal:(NSString *)consumptiontotal
                      distance:(NSString *)distance
                     precision:(NSNumber *)precision
                      latitude:(NSNumber *)latitude
                 businessHours:(NSString *)businessHours;
/****************************经纬度**********/
@end
