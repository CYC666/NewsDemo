//
//  WXUserDefaults.h
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 admin. All rights reserved.
//

/*
 * 存入微信登录的单例对象
 */

#import <Foundation/Foundation.h>

#define WX_App_ID @"wx74425f5021cc397b"
#define WX_App_Secret @"e5c4f7be493ff773a91f577109562d50"
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"

@interface WXUserDefaults : NSObject

//微信登录的标示
@property (nonatomic) NSString *accessToken;
//登录唯一标示
@property (nonatomic) NSString *openId;
//微信登录的更新标示
@property (nonatomic) NSString *refreshToken;
//微信获取的用户昵称
@property (nonatomic) NSString *externalNickname;
//微信获取的用户性别
@property (nonatomic) NSString *externalGender;

//单例模式
+ (WXUserDefaults *)sharedInstance;


//初始化工厂方法
- (instancetype)initWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId andRefreshToken:(NSString *)refreshToken andExternalNickname:(NSString *)externalNickname andExternalGender:(NSString *)externalGender;


@end
