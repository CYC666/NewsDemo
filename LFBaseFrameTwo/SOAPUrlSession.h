//
//  SOAPUrlSession.h
//  YiYanYunGou
//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

//通过宏定义用printf()函数来替换原来的NSLog，（该修改仅针对开发模式生效）
#ifndef __OPTIMIZE__
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#endif

@interface SOAPUrlSession : NSObject


// bidApp发送POST请求
+ (void)postWithBody:(NSDictionary *)bodyDic method:(NSString *)method success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure;


//post字符串
+ (void)SOAPDataWithMethod:(NSString *)method parameter:(NSDictionary *)parameter success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure;

//上传图片data
+ (void)SOAPDataWithMethod:(NSString *)method idCode:(NSString *)idCode imageKey:(NSString *)imageKey imageData:(NSData *)imageData success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure;

//判断网络可达性
+ (BOOL)SOAPReachability;



//上传港汇城评论的图片
+ (void)SOAPDataWithMethod:(NSString *)method OrdersGoodsId:(NSString *)ordersGoodsId imageData:(NSData *)imageData success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure;

//AFNetworking  请求Java
+ (void)AFHTTPSessionManager:(NSString *)method parameter:(NSDictionary *)parameter success:(void (^)(id responseObject))successs failure:(void(^)(NSError *error))failure;

//上传图片
+ (void)AFHTTPDataManaager:(NSString *)method parameter:(NSDictionary *)parameter imageData:(NSData *)imageData success:(void (^)(id responseObject))successs failure:(void(^)(NSError *error))failure;

//上传多图
+ (void)AFHTTPDataManaager:(NSString *)method parameter:(NSDictionary *)parameter images:(NSArray *)images success:(void (^)(id responseObject))successs failure:(void(^)(NSError *error))failure;

@end
