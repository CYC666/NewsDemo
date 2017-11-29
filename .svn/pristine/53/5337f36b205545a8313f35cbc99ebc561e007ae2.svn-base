//
//  UserInformation.m
//  YiYanYunGou
//
//  Created by admin on 16/3/21.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "UserInformation.h"

@implementation UserInformation

static UserInformation *instance;
+ (UserInformation *)sharedInstance{
    @synchronized(self) {
        if (!instance) {
            instance = [[UserInformation alloc]init];
        }
    }
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self) {
        if (!instance) {
            instance = [super allocWithZone:zone];
        }
    }
    return instance;
}

////此方法测试时使用的，非测试情况需要注释掉
//- (instancetype)init{
//    if (self = [super init]) {
//        _userId = @"aa732cea695a4125b6220beea6079314";
//        _mobile = @"18570371371";
//        _alias = @"laofu";
//        _email = @"1342511722@qq.com";
//        _idCode = @"7";
//        _gender = @"男";
//        _birthday = @"1989/8/22";
//        _province = @"广东省";
//        _city = @"深圳市";
//        _county = @"南山区";
//        _address = @"白石洲西二坊";
//        _headPortrait = @"";
//    }
//    return self;
//}


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
                      headURL:(NSString *)headURL{

    if (self = [super init]) {
        
        _phone= [NSString stringWithFormat:@"%@",phone];
        _accountbalance = [NSString stringWithFormat:@"%@",accountbalance];
        _carat = [NSString stringWithFormat:@"%@",carat];
        _currency= [NSString stringWithFormat:@"%@",currency];
        _memberid= [NSString stringWithFormat:@"%@",memberid];
        _name = [NSString stringWithFormat:@"%@",nickname];
        _recommphone = [NSString stringWithFormat:@"%@",recommphone];
        _userIntegral = [NSString stringWithFormat:@"%@",userIntegral];
        _userVIP = [NSString stringWithFormat:@"%@",userVIP];
        _sex = [NSString stringWithFormat:@"%@",sex];
        _headURL = [NSString stringWithFormat:@"%@",headURL];
        
    }
    return self;
    
}


//清空所有数据，相当于退出账户
- (void)clearData{
    
    //----------钻购------------
    _phone= nil;
    _accountbalance = nil;
    _carat =nil;
    _currency=nil;
    _memberid= nil;
    _name = nil;
    _recommphone = nil;
    _userIntegral = nil;
    _userVIP =nil;
    _sex = nil;
    _headURL =nil;
    
}
//判断是否登录了
- (BOOL)isLoginWithUserId{
    
    //注册的用户一定会有_UserId和_EnCode
    if ([_phone isEqualToString:@""] || _phone == nil) {
        return NO;
    } else {
        return YES;
    }
    
}

//清除临时图片数据
- (void)clearImageUrlData {
    _photoMenMian = nil;
    _photoYinYe = nil;
    _photoIDCardFront = nil;
    _photoIDCardBack = nil;
    _photograph = nil;
}

@end
