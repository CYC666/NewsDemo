//
//  EncryptForInterface.h
//  YiYanYunGou
//
//  Created by admin on 16/3/22.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>


@interface EncryptForInterface : NSObject

//加密
+ (NSString *)encryptWithText:(NSString *)sText;
//解密
+ (NSString *)decryptWithText:(NSString *)sText;


@end
