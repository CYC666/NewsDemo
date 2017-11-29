//
//  WXApiManager.m
//  YiYanYunGou
//
//  Created by admin on 16/5/20.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "WXApiManager.h"
#import "WXUserDefaults.h"
#import <AFNetworking.h>

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
}

#pragma mark - WXApiDelegate

// 授权后回调，（第二步：通过code获取access_token）
- (void)onResp:(BaseResp *)resp {

    // 向微信请求授权后，判断响应结果的类型
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
    
        // 初始化Manager
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WX_App_ID, WX_App_Secret, temp.code];
        
        // get请求
        [manager GET:accessUrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            //显示下载进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];//转换数据格式
            NSLog(@"请求access的response = %@", accessDict);
            
            
            NSString *accessToken = accessDict[@"access_token"];
            NSString *openID = accessDict[@"openid"];
            NSString *refreshToken = accessDict[@"refresh_token"];
            // 本地持久化，以便access_token的使用、刷新或者持续
            if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
                [WXUserDefaults sharedInstance].accessToken = accessToken;
                [WXUserDefaults sharedInstance].openId = openID;
                [WXUserDefaults sharedInstance].refreshToken = refreshToken;
            }
            
            //获取微信用户的个人信息
            [self wechatLoginByRequestForUserInfo];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"获取access_token时出错 = %@", error);
        }];
        
    } else if([resp isKindOfClass:[PayResp class]]){
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
//        
//        switch (resp.errCode) {
//            case WXSuccess:
//                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                break;
//                
//            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                break;
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        
        

//        WXSuccess           = 0,    /**< 成功    */
//        WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//        WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//        WXErrCodeSentFail   = -3,   /**< 发送失败    */
//        WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//        WXErrCodeUnsupport  = -5,   /**< 微信不支持    */

        switch (resp.errCode) {
            case WXSuccess:
                //调用协议中的委托方法，以便能在界面弹出提示（主要是解决在AppDelegate.m中的回调不能弹出提示窗的问题）
                if (_delegate && [_delegate respondsToSelector:@selector(managerWeixinPayCallbackToAlter:money:message:)]) {
                    [_delegate managerWeixinPayCallbackToAlter:YES money:_rechargeMoney message:@"充值成功"];
                    
                    //显示一次之后清理数据，保证数据不会错误到一下次的显示中
                    _rechargeMoney = @"未知金额";
                }
                break;
              
            case WXErrCodeUserCancel:
                //调用协议中的委托方法，以便能在界面弹出提示（主要是解决在AppDelegate.m中的回调不能弹出提示窗的问题）
                if (_delegate && [_delegate respondsToSelector:@selector(managerWeixinPayCallbackToAlter:money:message:)]) {
                    [_delegate managerWeixinPayCallbackToAlter:NO money:@"" message:@"用户主动取消支付"];
                }
                break;
                
            default:
                //调用协议中的委托方法，以便能在界面弹出提示（主要是解决在AppDelegate.m中的回调不能弹出提示窗的问题）
                if (_delegate && [_delegate respondsToSelector:@selector(managerWeixinPayCallbackToAlter:money:message:)]) {
                    [_delegate managerWeixinPayCallbackToAlter:NO money:@"" message:[NSString stringWithFormat:@"错误类型：%@",resp.errStr]];
                }
                break;
        }
        
    }

    
}


// 获取用户个人信息（UnionID机制）
- (void)wechatLoginByRequestForUserInfo {
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *accessToken = [WXUserDefaults sharedInstance].accessToken;
    NSString *openID = [WXUserDefaults sharedInstance].openId;
    
    NSString *userUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, accessToken, openID];
    
    // get请求
    [manager GET:userUrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //显示下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *userInfoDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];//转换数据格式
        NSLog(@"请求用户信息的response = %@", userInfoDict);
        
        [WXUserDefaults sharedInstance].externalNickname = userInfoDict[@"nickname"];
        NSNumber *externalGender = userInfoDict[@"sex"];
        if ([externalGender integerValue] == 1) {
            [WXUserDefaults sharedInstance].externalGender = @"男";
        } else {
            [WXUserDefaults sharedInstance].externalGender = @"女";
        }
        
        //调用登录视图中写好的委托方法，判断是否需要去绑定手机
        if (_delegate && [_delegate respondsToSelector:@selector(managerDidRecvLoginUserJudge:)]) {
            [_delegate managerDidRecvLoginUserJudge:openID];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取用户信息时出错 = %@", error);
    }];
    
}


@end
