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


//清空所有数据，相当于退出账户
- (void)clearData{
    
    
    _member_birth= nil;
    _member_email = nil;
    _member_gender = nil;
    _member_id = nil;
    _member_img = nil;
    _member_mobile = nil;
    _member_nickname = nil;
    _member_email = nil;
    
    _mt_token =nil;
    _visitor=nil;
    
    //存入NSUserDefaults文件中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"" forKey:@"mt_token"];
    [userDefaults setObject:@"" forKey:@"visitor"];
    [userDefaults synchronize]; //立即同步
    
}
//判断是否登录了
- (BOOL)isLoginWithUserId{
    
    //注册的用户一定会有_UserId和_EnCode
    if ([_mt_token isEqualToString:@""] || _mt_token == nil) {
        return NO;
    } else {
        return YES;
    }
    
}




@end
