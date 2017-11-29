//
//  WXApiManager.h
//  YiYanYunGou
//
//  Created by admin on 16/5/20.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"


@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

//微信登录委托方法，将在登陆的view中被调用，以便实现新视图的切换
- (void)managerDidRecvLoginUserJudge:(NSString *)openId;

//微信支付回调后，弹出提示页面的方法
- (void)managerWeixinPayCallbackToAlter:(BOOL)isSuccess money:(NSString *)money message:(NSString *)message;


@end

@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

//保存微信充值的金额，由于返回的结果中没有，所以需要单独保存
@property (nonatomic) NSString *rechargeMoney;


+ (instancetype)sharedManager;

// 获取用户个人信息（UnionID机制）
- (void)wechatLoginByRequestForUserInfo;


@end
