//
//  SmallFunctionTool.h
//  YiYanYunGou
//
//  Created by admin on 16/3/25.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//获取屏幕 宽度、高度
#define SCREEN_FRAME ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//后台获取的幸运码转化为显示的数字时，需要加上啊值
#define Lucky_Number_Base 10000001
//后台获取的用户编码转化为显示的数字时，需要加上啊值
#define User_Code_Base 10000000
//计算幸运号是需要加上的编号
#define Compute_Lucky_Base 10000001


@interface SmallFunctionTool : NSObject

// 曹奕程创建，用于标识首页是否显示三张滑动图片   NO:不显示 YES:显示
@property (assign, nonatomic) BOOL isShowScrollImageView;


///单例模式
+ (SmallFunctionTool *)sharedInstance;

///获取设备的IP地址
+ (NSString *)getDeviceIPIpAddresses;

///正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;

///正则匹配邮箱
+ (BOOL)checkEmailStr:(NSString *)emailStr;

///正则匹配邮政编码
+ (BOOL)checkZipCodeStr:(NSString *)zipCode;

///创建并启动风火轮
- (void)createActivityIndicator:(UIView *)nowView AndKey:(NSString *)className;
///关闭风火轮
- (void)stopActivityIndicator:(NSString *)className;
///创建并启动风火轮，有部分需要位置偏移
- (void)createActivityIndicator:(UIView *)nowView AndKey:(NSString *)className AndOffset:(CGFloat)offset;

///手机号加密显示
+ (NSString *)lockMobileNumber:(NSString *)mobileNumber;

/*
 * 显示全国省市区县的通用方法，使用本地的Json数据
 */

///初始化本地省市区类方法
+ (void)initializeAllCityFunction;

///获取所有省份
+ (NSDictionary *)haveAllProvince;


///获取某个省份的所有市区信息
+ (NSDictionary *)haveAllCity:(NSString *)provinceCode;


///获取某个市区的所有区县的信息
+ (NSDictionary *)haveAllCounty:(NSString *)cityCode;


///屏蔽输入的表情字符
+ (NSString *)disable_emoji:(NSString *)text;


///校验文本输入框的文本字数，两种类型：0--最长20个字，1-最长40个字，2-最长140个字
+ (NSString *)checkOutText:(NSString *)textContent byType:(NSString *)type withTextName:(NSString *)textName;

///校验密码文本输框，必须为6-16位数字组成
+ (NSString *)checkOutPasswordText:(NSString *)textContent withTextName:(NSString *)textName;

//校验密码文本输框，必须为6-16位数字+字母组成
+ (NSString *)checkOutPasswordTexts:(NSString *)textContent withTextName:(NSString *)textName;

///普通按钮设置0.5秒点击一次
+ (void)singleClickButtonRestriction:(id)sender;



///图片点击后放大（uibutton）
+ (void)showBigImage:(UIButton *)buttonHaveImageView;

///图片点击后放大（uiimageview）
+ (void)scanBigImageWithImageView:(UIImageView *)currentImageview;


///无网络弹窗提示
+ (void)showNoNetworkConnectTip:(UIViewController *)showVC;


///添加黑幕不可点击的风火轮
- (void)createBlankScreenActivityIndicator:(UIView *)nowView AndKey:(NSString *)className AndOffset:(CGFloat)offset;

///关闭风火轮
- (void)stopBlankScreenActivityIndicator:(NSString *)className;



///昵称统一显示10位，中间两位是**
+ (NSString *)lockNickNameString:(NSString *)nickName;


///键盘最上部功能条的收起键盘的按钮
+ (UIToolbar *)addHideKeyboardButton:(UIViewController *)target;


///正则匹配邀请码（这里先设置成手机号）
+ (BOOL)checkInvitationCodeStr:(NSString *)invitationCode;

///验证身份证
+ (BOOL)verifyIDCardNumber:(NSString *)value;

//根据身份证判断性别
+ (NSString *)lockIdString:(NSString *)nickName;

///将当前时间转成string
+ (NSString *)transitionDateToString:(NSDate *)oneDate;

///比较string类型的时间和当前时间的差值(返回秒)
+ (long)timeDifferenceForNow:(NSString *)dateString;

///银行卡号加密显示
+ (NSString *)lockBankNumber:(NSString *)mobileNumber;


//将超大的金额改成万，不足够的正常显示，保存3位小数
+ (NSString *)changeBigNumber:(NSString *)bigNumber;
//将超大的金额改成万，不足够的正常显示，保存2位小数
+ (NSString *)changeBigNumberTwo:(NSString *)bigNumber;
//将超大的金额改成万，不足够的正常显示，保存0位小数
+ (NSString *)changeBigNumberZero:(NSString *)bigNumber;

//将超大的积分改成万，不足够的正常显示，保存3位小数
+ (NSString *)changeBigNumberIntegral:(NSString *)bigNumber;

///清除7天记录的登录状态
+ (void)clearAwayLoginState;


///创建某一种颜色的背景图片
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


@end
