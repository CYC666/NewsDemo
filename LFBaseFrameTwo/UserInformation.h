//
//  UserInformation.h
//  YiYanYunGou
//
//  Created by admin on 16/3/21.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformation : NSObject

// 属性
@property (copy, nonatomic) NSString *member_birth;
@property (copy, nonatomic) NSString *member_email;
@property (copy, nonatomic) NSString *member_gender;
@property (copy, nonatomic) NSString *member_id;
@property (copy, nonatomic) NSString *member_img;
@property (copy, nonatomic) NSString *member_mobile;
@property (copy, nonatomic) NSString *member_nickname;

@property (copy, nonatomic) NSString *mt_token;
@property (copy, nonatomic) NSString *visitor;



//单例模式
+ (UserInformation *)sharedInstance;

//清空所有数据，相当于退出账户
- (void)clearData;


//判断是否登录
- (BOOL)isLoginWithUserId;


@end
