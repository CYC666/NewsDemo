//
//  WXUserDefaults.m
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "WXUserDefaults.h"

@implementation WXUserDefaults

static WXUserDefaults *instance;
+ (WXUserDefaults *)sharedInstance{
    @synchronized(self) {
        if (!instance) {
            instance = [[WXUserDefaults alloc]init];
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

//初始化工厂方法
- (instancetype)initWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId andRefreshToken:(NSString *)refreshToken andExternalNickname:(NSString *)externalNickname andExternalGender:(NSString *)externalGender{
    if (self = [super init]) {
        _accessToken = accessToken;
        _openId = openId;
        _refreshToken = refreshToken;
        _externalNickname = externalNickname;
        _externalGender = externalGender;
    }
    return self;
}


@end
