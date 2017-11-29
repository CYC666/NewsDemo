//
//  UserInformation.h
//  YiYanYunGou
//
//  Created by admin on 16/3/21.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformation : NSObject

//根据后台的JSON数据设置属性

//UserId，前端唯一标示
@property (nonatomic) NSString *UserId;
//id编号
@property (nonatomic) NSString *EnCode;
//真实姓名
@property (nonatomic) NSString *RealName;
//角色类型（0-个人，10-商户，20-业务员）
@property (nonatomic) NSString *RoleType;
//身份证号码
@property (nonatomic) NSString *IDCard;
//昵称
@property (nonatomic) NSString *NickName;
//头像
@property (nonatomic) NSString *HeadIcon;
//性别
@property (nonatomic) NSString *Gender;
//生日
@property (nonatomic) NSString *Birthday;
//手机号
@property (nonatomic) NSString *Mobile;
//邮箱
@property (nonatomic) NSString *Email;
//第三方绑定
@property (nonatomic, copy) NSString *OpenId;  // 微信
@property (nonatomic, copy) NSString *OpenId2; // QQ
//现居地址
//省
@property (nonatomic) NSString *ProvinceId;
@property (nonatomic) NSString *ProvinceName;
//市
@property (nonatomic) NSString *CityId;
@property (nonatomic) NSString *CityName;
//县
@property (nonatomic) NSString *CountyId;
@property (nonatomic) NSString *CountyName;
//详细地址
@property (nonatomic) NSString *Address;

//商户类型
@property (nonatomic) NSString *EntryType;
@property (nonatomic) NSString *EntryTypeName;
@property (nonatomic) NSString *AnnualFee;  // 商家年费 0表示未交  1表示已交

//用户账户相关信息
//当前余额
@property (nonatomic) NSString *Balance;
//冻结资金
@property (nonatomic) NSString *Freeze;
//当前账户积分
@property (nonatomic) NSString *Integral;
//累计收益总额
@property (nonatomic) NSString *IncomeTotal;
//累计提现总额
@property (nonatomic) NSString *WithdrawTotal;
//累计积分总额
@property (nonatomic) NSString *IntegralTotal;
//描述
@property (nonatomic) NSString *Description;

//商户审核状态（0：默认，1：审核中，2：审核通过，-1：审核未通过）
@property (nonatomic) NSString *AuditMark;
//有效标志位（0：无效，1-有效）
@property (nonatomic) NSString *EnabledMark;

//提现密码
@property (nonatomic) NSString *WithdrawPassword;

//个人消费总额
@property (nonatomic) NSString *BusinessTotal;

// 银豆
@property (nonatomic) NSString *SilverBeans;

// 让利比例
@property (nonatomic) NSString *Commission;






//----------------------------商户申请上传的几张图片，临时存储-----------------------------

//门面照片
@property (nonatomic) NSString *photoMenMian;
//营业执照照片
@property (nonatomic) NSString *photoYinYe;
//承诺书照片
@property (nonatomic) NSString *photoChengNuoShu;
//身份证正面
@property (nonatomic) NSString *photoIDCardFront;
//身份证反面
@property (nonatomic) NSString *photoIDCardBack;
//业务员合照按钮
@property (nonatomic) NSString *photograph;

//室内
@property (nonatomic) NSString *shinei;
@property (nonatomic) NSString *shineiB;

//营业时间
@property (copy, nonatomic) NSString *businessHours;

//--------------------------end:商户申请上传的几张图片，临时存储---------------------------


//--------------------------钻购商城---------------------------
//账户余额
@property (nonatomic) NSString *accountbalance;
//克拉
@property (nonatomic) NSString *carat;
//通宝
@property (nonatomic) NSString *currency;
//会员号
@property (nonatomic) NSString *memberid;
//用户别名
@property (nonatomic) NSString *name;
//账号
@property (nonatomic) NSString *phone;
//关联手机号（我的圈子那个）
@property (nonatomic) NSString *recommphone;
//用户积分
@property (nonatomic) NSString *userIntegral;
//用户会员等级
@property (nonatomic) NSString *userVIP;
//头像文件
@property (nonatomic) NSString *headURL;
//性别
@property (nonatomic) NSString *sex;

//--------------------------end:钻购商城---------------------------


//单例模式
+ (UserInformation *)sharedInstance;

//初始化工厂方法
//- (instancetype)initWithUserId:(NSString *)UserId
//                        EnCode:(NSString *)EnCode
//                      RealName:(NSString *)RealName
//                      RoleType:(NSString *)RoleType
//                        IDCard:(NSString *)IDCard
//                      NickName:(NSString *)NickName
//                      HeadIcon:(NSString *)HeadIcon
//                        Gender:(NSString *)Gender
//                      Birthday:(NSString *)Birthday
//                        Mobile:(NSString *)Mobile
//                         Email:(NSString *)Email
//                    ProvinceId:(NSString *)ProvinceId
//                  ProvinceName:(NSString *)ProvinceName
//                        CityId:(NSString *)CityId
//                      CityName:(NSString *)CityName
//                      CountyId:(NSString *)CountyId
//                    CountyName:(NSString *)CountyName
//                       Address:(NSString *)Address
//                     EntryType:(NSString *)EntryType
//                 EntryTypeName:(NSString *)EntryTypeName
//                       Balance:(NSString *)Balance
//                        Freeze:(NSString *)Freeze
//                      Integral:(NSString *)Integral
//                   IncomeTotal:(NSString *)IncomeTotal
//                 WithdrawTotal:(NSString *)WithdrawTotal
//                 IntegralTotal:(NSString *)IntegralTotal
//                   Description:(NSString *)Description
//                     AuditMark:(NSString *)AuditMark
//                   EnabledMark:(NSString *)EnabledMark
//              WithdrawPassword:(NSString *)WithdrawPassword
//                 BusinessTotal:(NSString *)BusinessTotal
//                 businessHours:(NSString *)businessHours
//                        OpenId:(NSString *)OpenId
//                       OpenId2:(NSString *)OpenId2
//                   SilverBeans:(NSString *)SilverBeans
//                    Commission:(NSString *)Commission
//                     AnnualFee:(NSString *)AnnualFee;

//初始化工厂方法
- (instancetype)initWithphone:(NSString *)phone
               accountbalance:(NSString *)accountbalance
                        carat:(NSString *)carat
                     currency:(NSString *)currency
                     memberid:(NSString *)memberid
                     nickname:(NSString *)nickname
                  recommphone:(NSString *)recommphone
                 userIntegral:(NSString *)userIntegral
                      userVIP:(NSString *)userVIP
                          sex:(NSString *)sex
                      headURL:(NSString *)headURL;

//清空所有数据，相当于退出账户
- (void)clearData;
//判断是否登录
- (BOOL)isLoginWithUserId;


//清除临时图片数据
- (void)clearImageUrlData;

@end
