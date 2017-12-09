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



// ================================侯尧项目====================================

//  获取首页文章
+ (void)getNewsWithArt_type:(NSString *)art_type
                art_subwsid:(NSString *)art_subwsid
                       page:(NSString *)page
            art_subws_order:(NSString *)art_subws_order
                showed_list:(NSMutableArray *)showed_list
                    success:(void (^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;


//  获取验证码
+ (void)getCodeAction:(NSString *)phone
              success:(void (^)(id responseObject))success
              failure:(void(^)(NSError *error))failure;

//  登录
+ (void)loginAction:(NSString *)phone
               code:(NSString *)code
            success:(void (^)(id responseObject))success
            failure:(void(^)(NSError *error))failure;

//  获取个人中心页个人信息
+ (void)loadPersonalInfoActionSuccess:(void (^)(id responseObject))success
            failure:(void(^)(NSError *error))failure;

//  获取个人设置页面个人信息
+ (void)loadPersonalDetialInfoActionSuccess:(void (^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure;

//  获取订阅列表
+ (void)loadDingListActionSuccess:(void (^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure;

//  是否订阅
+ (void)setDingActionWithMwsub_wsid:(NSString *)mwsub_wsid
                              mwsub_id:(NSString *)mwsub_id
                       art_subws_order:(NSString *)art_subws_order  // (订阅传0，取消传1）
                               success:(void (^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure;

//  收藏某一篇文章
+ (void)collectActionWithMegmt_id:(NSString *)megmt_id
                      megmt_artid:(NSString *)megmt_artid
                      mwsub_webid:(NSString *)mwsub_webid
                         favorite:(NSString *)favorite      // 0-收藏 1-取消
                          success:(void (^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure;

//  浏览某一篇文章
+ (void)didSeeActionWithartid:(NSString *)artid
                        webid:(NSString *)webid
                      success:(void (^)(id responseObject))success
                      failure:(void(^)(NSError *error))failure;

//  删除浏览某一篇文章
+ (void)deleteSeeActionWithartid:(NSString *)artid
                         success:(void (^)(id responseObject))success
                         failure:(void(^)(NSError *error))failure;




//  搜索文章
+ (void)searchArtWithPage:(NSString *)page
                     keys:(NSString *)keys        // 文章关键字
                  success:(void (^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure;


//  搜索网页
+ (void)searchWebWithPage:(NSString *)page
                 web_keys:(NSString *)web_keys        // 网页关键字
                  success:(void (^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure;


//  获取收藏、历史列表
+ (void)getCollectWithPage:(NSString *)page
                megmt_type:(NSString *)megmt_type        //  历史1 收藏2
                   success:(void (^)(id responseObject))success
                   failure:(void(^)(NSError *error))failure;

//  上传头像
+ (void)upLoadImageActionWitImage:(UIImage *)image
                      success:(void (^)(id responseObject))success
                      failure:(void(^)(NSError *error))failure;

//  修改个人资料
+ (void)changePersonalInfoMbr_img:(NSString *)mbr_img
                     mbr_nickname:(NSString *)mbr_nickname
                       mbr_mobile:(NSString *)mbr_mobile
                       mbr_gender:(NSString *)mbr_gender
                        mbr_birth:(NSString *)mbr_birth
                        mbr_email:(NSString *)mbr_email
                          success:(void (^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure;

//  意见反馈
+ (void)sendIdeaCode:(NSString *)code
                desc:(NSString *)desc        
             success:(void (^)(id responseObject))success
             failure:(void(^)(NSError *error))failure;

// 猜你喜欢
+ (void)yourLikeCur_Page:(NSString *)cur_page
                 success:(void (^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure;


// 获取猜你喜欢详情
+ (void)getYourLikeDetialId:(NSString *)Id
                    success:(void (^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;


// 消息列表
+ (void)messageCur_Page:(NSString *)cur_page
                success:(void (^)(id responseObject))success
                failure:(void(^)(NSError *error))failure;

// 今日学习
+ (void)todayStudyCur_Page:(NSString *)cur_page
                   success:(void (^)(id responseObject))success
                   failure:(void(^)(NSError *error))failure;


// 获取今日学习详情
+ (void)todayStudyDetialId:(NSString *)Id
                    success:(void (^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;


// 最新加入和热门推荐
+ (void)hotAneNewWebsType:(NSString *)websType
                 cur_page:(NSString *)cur_page
                  success:(void (^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure;

// 最新加入和热门推荐前四个
+ (void)hotAneNewWebsHeaderType:(NSString *)websType      // (0 最新，1热门)
                        success:(void (^)(id responseObject))success
                        failure:(void(^)(NSError *error))failure;


// 版本更新
+ (void)updateVersionVer_info:(NSString *)ver_info
                      success:(void (^)(id responseObject))success
                      failure:(void(^)(NSError *error))failure;

















+ (void)tess;







// ================================侯尧项目====================================


// bidApp发送POST请求
+ (void)postWithBody:(NSDictionary *)bodyDic method:(NSString *)method headers:(NSDictionary *)headers success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure;


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
