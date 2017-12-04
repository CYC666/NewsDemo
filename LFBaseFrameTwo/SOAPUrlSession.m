//
//  SOAPUrlSession.m
//  YiYanYunGou
//
//  Created by admin on 16/3/23.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "SOAPUrlSession.h"
#import "EncryptForInterface.h"
#import "AppDelegate.h"


//上传图片的边界 参数可以随便设置
#define boundary @"AaB03x"

@implementation SOAPUrlSession

//  获取首页文章 ok
+ (void)getNewsWithArt_type:(NSString *)art_type        // 文章类型
                art_subwsid:(NSString *)art_subwsid     // 订阅网站的ID
                       page:(NSString *)page
                    success:(void (^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure {
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mt_token = [userDefaults objectForKey:@"mt_token"];
    NSString *visitor = [userDefaults objectForKey:@"visitor"];
    
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
    [manager.requestSerializer setValue:mt_token forHTTPHeaderField:@"TKID"];
    [manager.requestSerializer setValue:visitor forHTTPHeaderField:@"VISITOR"];
    
    
    NSLog(@"header = %@", manager.requestSerializer.HTTPRequestHeaders);
    
    if (art_type == nil) {
        art_type = @"-1";
    }
    if (art_subwsid == nil) {
        art_subwsid = @"-1";
    }
    
    NSDictionary* bodyParameters = @{
                                     @"art_type":art_type,
                                     @"cur_page":page,
                                     @"art_subwsid":art_subwsid,
                                     };
    NSLog(@"%@", bodyParameters);
    
    
    NSString *urlStr = @"http://47.92.86.242/bidapp/Api/index.php/Articles/selectArticles";
    NSLog(@"方法名: %@", urlStr);
    
    [manager POST:urlStr parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        //将Json格式的String转换为dictionary
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSError *err;
        
        if (jsonData ==nil) {
            NSLog(@"错误: %@",err);
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            
            
            if(err) {
                NSLog(@"异常：%@",err);
            } else {
                if (success && dict) {
                    success(dict);
                    NSLog(@"%@",dict);
                }
            }
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"HTTP Request failed: %@", error);
        
        failure(error);
    }];
    
    
}

//  获取验证码
+ (void)getCodeAction:(NSString *)phone
              success:(void (^)(id responseObject))success
              failure:(void(^)(NSError *error))failure{
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
    
    
    NSDictionary* bodyParameters = @{
                                     @"captchas_input":@"1",
                                     @"mobile":phone,
                                     @"filename":@"1",
                                     };
    NSString *urlStr = @"http://47.92.86.242/bidapp/Api/index.php/Login/getSmsVerfication";
    
    [manager POST:urlStr parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"方法名: %@", urlStr);
        
        //将Json格式的String转换为dictionary
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSError *err;
        
        if (jsonData ==nil) {
            NSLog(@"错误: %@",err);
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            
            
            if(err) {
                NSLog(@"异常：%@",err);
            } else {
                if (success && dict) {
                    success(dict);
                    NSLog(@"%@",dict);
                }
            }
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"HTTP Request failed: %@", error);
        
        failure(error);
    }];
    
    
}


//  登录 ok
+ (void)loginAction:(NSString *)phone
               code:(NSString *)code
            success:(void (^)(id responseObject))success
            failure:(void(^)(NSError *error))failure {
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
    
    
    NSDictionary* bodyParameters = @{
                                     @"mobile":phone,
                                     @"verfication":code,
                                     };
    NSString *urlStr = @"http://47.92.86.242/bidapp/Api/index.php/Login/loginBySms";
    
    [manager POST:urlStr parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"方法名: %@", urlStr);
        
        //将Json格式的String转换为dictionary
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSError *err;
        
        if (jsonData ==nil) {
            NSLog(@"错误: %@",err);
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            
            
            if(err) {
                NSLog(@"异常：%@",err);
            } else {
                if (success && dict) {
                    success(dict);
                    NSLog(@"%@",dict);
                }
            }
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"HTTP Request failed: %@", error);
        
        failure(error);
    }];
    
    
}


//  获取个人中心页个人信息 ok
+ (void)loadPersonalInfoActionSuccess:(void (^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure {
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mt_token = [userDefaults objectForKey:@"mt_token"];
    NSString *visitor = [userDefaults objectForKey:@"visitor"];
    
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:mt_token forHTTPHeaderField:@"TKID"];
    [manager.requestSerializer setValue:visitor forHTTPHeaderField:@"VISITOR"];
    
    NSDictionary* bodyParameters = nil;
    NSString *urlStr = @"http://47.92.86.242/bidapp/Api/index.php/Members/getMemberInfo";
    
    [manager  POST:urlStr parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"方法名: %@", urlStr);
        
        //将Json格式的String转换为dictionary
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSError *err;
        
        if (jsonData ==nil) {
            NSLog(@"错误: %@",err);
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            
            
            if(err) {
                NSLog(@"异常：%@",err);
            } else {
                if (success && dict) {
                    success(dict);
                    NSLog(@"%@",dict);
                }
            }
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"HTTP Request failed: %@", error);
        
        failure(error);
    }];
    
    
}

//  获取个人设置页面个人信息 ok
+ (void)loadPersonalDetialInfoActionSuccess:(void (^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure {
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mt_token = [userDefaults objectForKey:@"mt_token"];
    NSString *visitor = [userDefaults objectForKey:@"visitor"];
    
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:mt_token forHTTPHeaderField:@"TKID"];
    [manager.requestSerializer setValue:visitor forHTTPHeaderField:@"VISITOR"];
    
    NSDictionary* bodyParameters = nil;
    NSString *urlStr = @"http://47.92.86.242/bidapp/Api/index.php/Members/getMbrBasicInfo";
    
    [manager  POST:urlStr parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"方法名: %@", urlStr);
        
        //将Json格式的String转换为dictionary
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSError *err;
        
        if (jsonData ==nil) {
            NSLog(@"错误: %@",err);
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            
            
            if(err) {
                NSLog(@"异常：%@",err);
            } else {
                if (success && dict) {
                    success(dict);
                    NSLog(@"%@",dict);
                }
            }
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"HTTP Request failed: %@", error);
        
        failure(error);
    }];
    
    
}


//  获取订阅列表 ok
+ (void)loadDingListActionSuccess:(void (^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure {
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mt_token = [userDefaults objectForKey:@"mt_token"];
    NSString *visitor = [userDefaults objectForKey:@"visitor"];
    
    //    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:mt_token forHTTPHeaderField:@"TKID"];
    [manager.requestSerializer setValue:visitor forHTTPHeaderField:@"VISITOR"];
    
    NSDictionary* bodyParameters = @{
                                     @"cur_page":@"1",
                                     };
    
    NSString *urlStr = @"http://47.92.86.242/bidapp/Api/index.php/Subscribe/selectSubscribeSites";

    [manager GET:urlStr parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"方法名: %@", urlStr);
        
        //将Json格式的String转换为dictionary
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSError *err;
        
        if (jsonData ==nil) {
            NSLog(@"错误: %@",err);
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            
            
            if(err) {
                NSLog(@"异常：%@",err);
            } else {
                if (success && dict) {
                    success(dict);
                    NSLog(@"%@",dict);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败: %@", error);
        
        failure(error);
        
    }];


    
    
    
}


//  是否订阅 ok
+ (void)setDingActionWithMwsub_wsid:(NSString *)mwsub_wsid        // 网页id
                           mwsub_id:(NSString *)mwsub_id          // 订阅id
                    art_subws_order:(NSString *)art_subws_order   // (订阅传0，取消传1）
                            success:(void (^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure {
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mt_token = [userDefaults objectForKey:@"mt_token"];
    NSString *visitor = [userDefaults objectForKey:@"visitor"];
    
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:mt_token forHTTPHeaderField:@"TKID"];
    [manager.requestSerializer setValue:visitor forHTTPHeaderField:@"VISITOR"];
    
    if (mwsub_wsid == nil || [mwsub_wsid isEqualToString:@"<null>"] || [mwsub_wsid isEqualToString:@"(null)"] || [mwsub_wsid isEqualToString:@""]) {
        mwsub_wsid = @"";
    }
    
    if (mwsub_id == nil || [mwsub_id isEqualToString:@"<null>"] || [mwsub_id isEqualToString:@"(null)"] || [mwsub_id isEqualToString:@""]) {
        mwsub_id = @"";
    }
    
    NSDictionary* bodyParameters = @{
                                     @"mwsub_wsid":mwsub_wsid,
                                     @"mwsub_id":mwsub_id,
                                     @"art_subws_order":art_subws_order,
                                     };
    
    
    NSLog(@"%@", bodyParameters);
    
    NSString *urlStr = @"http://47.92.86.242/bidapp/Api/index.php/Subscribe/subscribeByCurMbr";
    NSLog(@"方法名: %@", urlStr);
    
    [manager POST:urlStr parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        //将Json格式的String转换为dictionary
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSError *err;
        
        if (jsonData ==nil) {
            NSLog(@"错误: %@",err);
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            
            
            if(err) {
                NSLog(@"异常：%@",err);
            } else {
                if (success && dict) {
                    success(dict);
                    NSLog(@"%@",dict);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败: %@", error);
        
        failure(error);
        
    }];
    
    
}


//  收藏某一篇文章 ok
+ (void)collectActionWithMegmt_id:(NSString *)megmt_id
                      megmt_artid:(NSString *)megmt_artid
                      mwsub_webid:(NSString *)mwsub_webid
                         favorite:(NSString *)favorite      // 0-收藏 1-取消
                          success:(void (^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure {
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mt_token = [userDefaults objectForKey:@"mt_token"];
    NSString *visitor = [userDefaults objectForKey:@"visitor"];
    
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
    [manager.requestSerializer setValue:mt_token forHTTPHeaderField:@"TKID"];
    [manager.requestSerializer setValue:visitor forHTTPHeaderField:@"VISITOR"];
    
    NSLog(@"header = %@", manager.requestSerializer.HTTPRequestHeaders);
    
    NSDictionary* bodyParameters;
    
    if (favorite.integerValue == 1) {
        
        // 取消收藏
        bodyParameters = @{
                           @"megmt_id":megmt_id,
                           @"favorite":favorite,
                           };
        

    } else {
        
        // 收藏
        bodyParameters = @{
                           @"megmt_artid":megmt_artid,
                           @"favorite":favorite,
                           @"megmt_webid":mwsub_webid,
                           };
        
    }
    NSLog(@"%@", bodyParameters);
    
    
    NSString *urlStr = @"http://47.92.86.242/bidapp/Api/index.php/Engagements/addToFavorite";
    NSLog(@"方法名: %@", urlStr);
    
    [manager POST:urlStr parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        //将Json格式的String转换为dictionary
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSError *err;
        
        if (jsonData ==nil) {
            NSLog(@"错误: %@",err);
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            
            
            if(err) {
                NSLog(@"异常：%@",err);
            } else {
                if (success && dict) {
                    success(dict);
                    NSLog(@"%@",dict);
                }
            }
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"HTTP Request failed: %@", error);
        
        failure(error);
    }];
    
    
}

//  搜索文章
+ (void)searchArtWithPage:(NSString *)page
                     keys:(NSString *)keys        // 文章关键字
                  success:(void (^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure {
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mt_token = [userDefaults objectForKey:@"mt_token"];
    NSString *visitor = [userDefaults objectForKey:@"visitor"];
    
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
    [manager.requestSerializer setValue:mt_token forHTTPHeaderField:@"TKID"];
    [manager.requestSerializer setValue:visitor forHTTPHeaderField:@"VISITOR"];
    
    NSLog(@"header = %@", manager.requestSerializer.HTTPRequestHeaders);
    
    NSDictionary *bodyParameters;
    
    
    bodyParameters = @{
                       @"cur_page":page,
                       @"key":keys,
                       };
    
    
    NSLog(@"%@", bodyParameters);
    
    
    NSString *urlStr = @"http://47.92.86.242/bidapp/Api/index.php/Search/selectArticlesByKeys";
    NSLog(@"方法名: %@", urlStr);
    
    [manager GET:urlStr parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        //将Json格式的String转换为dictionary
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSError *err;
        
        if (jsonData ==nil) {
            NSLog(@"错误: %@",err);
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            
            
            if(err) {
                NSLog(@"异常：%@",err);
            } else {
                if (success && dict) {
                    success(dict);
                    NSLog(@"%@",dict);
                }
            }
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"HTTP Request failed: %@", error);
        
        failure(error);
    }];
    
    
}


//  搜索网页
+ (void)searchWebWithPage:(NSString *)page
                 web_keys:(NSString *)web_keys        // 网页关键字
                  success:(void (^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure {
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mt_token = [userDefaults objectForKey:@"mt_token"];
    NSString *visitor = [userDefaults objectForKey:@"visitor"];
    
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
    [manager.requestSerializer setValue:mt_token forHTTPHeaderField:@"TKID"];
    [manager.requestSerializer setValue:visitor forHTTPHeaderField:@"VISITOR"];
    
    NSLog(@"header = %@", manager.requestSerializer.HTTPRequestHeaders);
    
    NSDictionary *bodyParameters;
    
    
    bodyParameters = @{
                       @"cur_page":page,
                       @"key":web_keys,
                       };
    
    
    NSLog(@"%@", bodyParameters);
    
    
    NSString *urlStr = @"http://47.92.86.242/bidapp/Api/index.php/Search/selectWsByKeyWords";
    NSLog(@"方法名: %@", urlStr);
    
    [manager GET:urlStr parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        //将Json格式的String转换为dictionary
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSError *err;
        
        if (jsonData ==nil) {
            NSLog(@"错误: %@",err);
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            
            
            if(err) {
                NSLog(@"异常：%@",err);
            } else {
                if (success && dict) {
                    success(dict);
                    NSLog(@"%@",dict);
                }
            }
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"HTTP Request failed: %@", error);
        
        failure(error);
    }];
    
    
}



+ (void)tess {
    
    

    
    
    
}

























#pragma mark ========================================分割=============================================




// 侯尧项目网络请求
+ (void)postWithBody:(NSDictionary *)bodyDic method:(NSString *)method headers:(NSDictionary *)headers success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
    
    
    NSDictionary* bodyParameters = @{
                                     @"captchas_input":@"1",
                                     @"mobile":@"13705038428",
                                     @"filename":@"1",
                                     };
    NSString *urlStr = @"http://47.92.86.242/bidapp/Api/index.php/Login/getSmsVerfication";
    
    [manager POST:urlStr parameters:bodyParameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSLog(@"方法名: %@",method);

        //将Json格式的String转换为dictionary
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];


        NSError *err;

        if (jsonData ==nil) {
            NSLog(@"错误: %@",err);
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];


            if(err) {
                NSLog(@"异常：%@",err);
            } else {
                if (success && dict) {
                    success(dict);
                    NSLog(@"%@",dict);
                }
            }
        }




    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"HTTP Request failed: %@", error);

        failure(error);
    }];
    
//    // 初始化Manager
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    // 设置请求头
////    NSArray *keyArray = [headers allKeys];
////
////    for (NSString *key in keyArray) {
////
////        NSString *value = [headers valueForKey:key];
////
////
////    }
//    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
//
//    NSString *URLString = [NSString stringWithFormat:@"%@%@", Java_URL, method];
//
//    [manager POST:URLString parameters:bodyDic progress:^(NSProgress * _Nonnull uploadProgress) {
//
//
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//
//        NSLog(@"方法名: %@",method);
//
//        //将Json格式的String转换为dictionary
//        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
//
//
//        NSError *err;
//
//        if (jsonData ==nil) {
//            NSLog(@"错误: %@",err);
//        }else{
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                 options:NSJSONReadingMutableContainers
//                                                                   error:&err];
//
//
//            if(err) {
//                NSLog(@"异常：%@",err);
//            } else {
//                if (success && dict) {
//                    success(dict);
//                    NSLog(@"%@",dict);
//                }
//            }
//        }
//
//
//
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        NSLog(@"HTTP Request failed: %@", error);
//
//        failure(error);
//    }];
    
    
    
//    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//
//
//    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
//
//
//    NSURL* URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Java_URL, method]];
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
//    request.HTTPMethod = @"POST";
//
//
//
//    // Headers
////    NSString *visitor = @"99564875c6885c7d3cd42c199d5e5b8d";
////    NSString *token = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9iaWRhcHAuY29tIiwibW9iaWxlIjoiMTM3MDUwMzg0MjgiLCJtYnJfaWQiOiIzOCIsImV4cCI6MTUxNDQzMDI2NCwiaWF0IjoxNTExODM4MjY0fQ.w5lNmDoaVUQDDU6E-5MGymkI9J5R4Gbj0Ysyj4EYVEQ";
////    [request addValue:visitor forHTTPHeaderField:@"VISITOR"];
////    [request addValue:token forHTTPHeaderField:@"TKID"];
//    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
////    [request setAllHTTPHeaderFields:headers];
//
//
//    request.HTTPBody = [NSStringFromQueryParameters(bodyDic) dataUsingEncoding:NSUTF8StringEncoding];
//
//
//    /* Start a new Task */
//    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//        if (error == nil) {
//
//            //将Json格式的String转换为dictionary
//            NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
//
//
//            NSError *err;
//
//            if (jsonData ==nil) {
//                NSLog(@"错误: %@",err);
//                NSLog(@"方法名: %@",method);
//            }else{
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                     options:NSJSONReadingMutableContainers
//                                                                       error:&err];
//
//
//                if(err) {
//                    NSLog(@"异常：%@",err);
//                    NSLog(@"方法名：%@",method);
//                } else {
//                    if (success && dict) {
//                        success(dict);
//                        NSLog(@"%@",dict);
//                    }
//                }
//            }
//
//        } else {
//            // Failure
//            NSLog(@"%@",result);
//            failure(error);
//
//        }
//    }];
//    [task resume];
//    [session finishTasksAndInvalidate];
    
    
    
    
}

static NSString* NSStringFromQueryParameters(NSDictionary* queryParameters)
{
    NSMutableArray* parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
                          [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
                          ];
        [parts addObject:part];
    }];
    return [parts componentsJoinedByString: @"&"];
}


/**
 *  post方式请求SOAP，返回Json  （使用的原生的网络请求方式）
 *
 *  @param method       后台对应方法名
 *  @param parameter    方法需要的参数
 *  @param success      成功block
 *  @param failure      失败block
 */

+ (void)SOAPDataWithMethod:(NSString *)method parameter:(NSDictionary *)parameter success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
//    @"TKID", @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9iaWRhcHAuY29tIiwibW9iaWxlIjoiMTM3MDUwMzg0MjgiLCJtYnJfaWQiOiIzOCIsImV4cCI6MTUxNDQzMDI2NCwiaWF0IjoxNTExODM4MjY0fQ.w5lNmDoaVUQDDU6E-5MGymkI9J5R4Gbj0Ysyj4EYVEQ",
//    @"VISITOR", @"99564875c6885c7d3cd42c199d5e5b8d",

    
    //成功的，原生请求方式
    NSString *urlString = [NSString stringWithFormat:@"%@%@",Java_URL,method];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    [request setHTTPMethod:@"POST"];

    //将dictionary转换为Json格式的String，并加密
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameter
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"%@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    //去除所有的反斜杠
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSLog(@"JSON数据:\n%@",jsonString);


    //将参数转为data类型，并放入HttpBody中
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sharedSession];

//    [request setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9iaWRhcHAuY29tIiwibW9iaWxlIjoiMTM3MDUwMzg0MjgiLCJtYnJfaWQiOiIzOCIsImV4cCI6MTUxNDQzMDI2NCwiaWF0IjoxNTExODM4MjY0fQ.w5lNmDoaVUQDDU6E-5MGymkI9J5R4Gbj0Ysyj4EYVEQ" forHTTPHeaderField:@"TKID"];
//    [request setValue:@"99564875c6885c7d3cd42c199d5e5b8d" forHTTPHeaderField:@"VISITOR"];
//    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
//    [request setAllHTTPHeaderFields:headers];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        //将接收到的data类型的数据转换为string
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        if (!error){

            NSUInteger length = [result length];
            const char *cString = [result UTF8String];
            if (strlen(cString) > length){
                //包含中文
                NSError *decryptError = [NSError errorWithDomain:@"zlct.com.cn" code:-1000 userInfo:@{NSLocalizedDescriptionKey:result}];
                if (failure) {
                    NSLog(@"%@",result);
                    failure(decryptError);
                }
            } else {


                //将Json格式的String转换为dictionary
                NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];


                NSError *err;

                if (jsonData ==nil) {
                    NSLog(@"错误: %@",err);
                    NSLog(@"方法名: %@",method);
                }else{
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&err];
                    

                    if(err) {
                        NSLog(@"异常：%@",err);
                        NSLog(@"方法名：%@",method);
                    } else {
                        if (success && dict) {
                            success(dict);
                            NSLog(@"%@",dict);
                        }
                    }
                }



            }
        } else {
            //直接请求失败，把error传出来
            if (failure) {
                failure(error);
            }
        }

    }];
    //发送网络任务
    [task resume];
    

    
}






/**
 *  post方式上传图片数据，返回Json  （AFNetwork封装的请求方式，后台返回的内容需要解密）
 *
 *  @param method       后台对应方法名
 *  @param imageData    图片的data数据
 *  @param imageKey     图片在方法中对应的参数名
 *  @param success      成功block
 *  @param failure      失败block
 */
+ (void)SOAPDataWithMethod:(NSString *)method idCode:(NSString *)idCode imageKey:(NSString *)imageKey imageData:(NSData *)imageData success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    
    // 请求的参数
   // NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:imageKey, @"Action", idCode, @"EnCode", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:idCode, @"EnCode", nil];
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",Java_Image_URL,method];
    // post请求
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，解析数据
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        NSString *decryptStr = nil;
        //        NSLog(@"后台返回，解码前的数据：\n%@",result);
        
        //判断result是否有中文，有的话应该要报“服务器处理异常”
        NSUInteger length = [result length];
        const char *cString = [result UTF8String];
        if (strlen(cString) > length){
            //包含中文
            NSError *decryptError = [NSError errorWithDomain:@"zlct.com.cn" code:-1000 userInfo:@{NSLocalizedDescriptionKey:result}];
            if (failure) {
                NSLog(@"返回异常包含中文：\n%@",result);
                failure(decryptError);
            }
        } else {

            //正常的编码了的字符串，进行正常解码
            decryptStr = [EncryptForInterface decryptWithText:result];
            
            //去除字符串中多余的换行符
            decryptStr = [decryptStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            decryptStr = [decryptStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            //去除所有的反斜杠
            decryptStr = [decryptStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            
            //去除后台返回null无法识别的问题
            decryptStr = [decryptStr stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
            
            NSLog(@"后台返回，解码后的数据：\n%@",decryptStr);
            
            //将Json格式的String转换为dictionary
            NSData *jsonData = [decryptStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];

            
            if (success && dict) {
                success(dict);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //直接请求失败，把error传出来
        if (failure) {
            failure(error);
        }
    }];
}





/**
 *  post方式上传港汇城的评论图片数据，返回Json （AFNetwork封装的请求方式，后台返回的内容并不需要解密）
 *
 *  @param method       后台对应方法名
 *  @param imageData    图片的data数据
 *  @param ordersGoodsId     订单中的商品id
 *  @param success      成功block
 *  @param failure      失败block
 */
+ (void)SOAPDataWithMethod:(NSString *)method OrdersGoodsId:(NSString *)ordersGoodsId imageData:(NSData *)imageData success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    
    // 请求的参数
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:ordersGoodsId, @"OrdersGoodsId", nil];
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",Java_Image_URL,method];
    // post请求
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，解析数据
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString *decryptStr = nil;
        
        //判断result是否有中文，有的话应该要报“服务器处理异常”
        NSUInteger length = [result length];
        const char *cString = [result UTF8String];
        if (strlen(cString) > length){
            //包含中文
            NSError *decryptError = [NSError errorWithDomain:@"zlct.com.cn" code:-1000 userInfo:@{NSLocalizedDescriptionKey:result}];
            if (failure) {
                NSLog(@"返回异常包含中文：\n%@",result);
                failure(decryptError);
            }
        } else {
            //正常的编码了的字符串，进行正常解码
            decryptStr = [EncryptForInterface decryptWithText:result];
            NSLog(@"后台返回，解码后的数据：\n%@",decryptStr);
            
            //把返回的图片URL路径组个字典传出去
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:decryptStr, @"imageURL", nil];
            
            if (success && dict) {
                success(dict);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //直接请求失败，把error传出来
        if (failure) {
            failure(error);
        }
    }];
}


//判断网络可达性
+ (BOOL)SOAPReachability{
    
//    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return YES;
//    return appDlg.isReachable;
}





//AFNetworking  请求Java
+ (void)AFHTTPSessionManager:(NSString *)method parameter:(NSDictionary *)parameter success:(void (^)(id responseObject))successs failure:(void(^)(NSError *error))failure{
    
    //成功的，原生请求方式
    NSString *urlString = [NSString stringWithFormat:@"%@%@.do",Java_URL ,method];
    NSLog(@"请求的接口：urlString=%@",urlString);
    NSLog(@"上传的数据：%@",parameter);
    urlString=[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [[AFHTTPSessionManager manager] POST:urlString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successs && responseObject) {
            NSLog(@"请求成功方法名%@=%@",method,[responseObject description]);
            successs(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //直接请求失败，把error传出来
        if (failure) {
            NSLog(@"请求失败方法名%@ error=%@",method,[error description]);
            failure(error);
        }
    }];
    
}


//上传图片
+ (void)AFHTTPDataManaager:(NSString *)method parameter:(NSDictionary *)parameter imageData:(NSData *)imageData success:(void (^)(id responseObject))successs failure:(void(^)(NSError *error))failure {

    NSDictionary *dic = parameter;
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@.do", Java_URL, method];
    
    NSLog(@"请求的接口：urlString=%@",urlString);
    NSLog(@"上传的数据：%@",parameter);
    
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"请求成功方法名%@=%@",method,[responseObject description]);
        if (successs) {
            successs(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败方法名%@ error=%@",method,[error description]);
        //直接请求失败，把error传出来
        if (failure) {
            failure(error);
        }
    }];
    

}

//上传多图
+ (void)AFHTTPDataManaager:(NSString *)method parameter:(NSDictionary *)parameter images:(NSArray *)images success:(void (^)(id responseObject))successs failure:(void(^)(NSError *error))failure{

    NSDictionary *dic = parameter;
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@.do", Java_URL, method];
    
    NSLog(@"请求的接口：urlString=%@",urlString);
    NSLog(@"上传的数据：%@",parameter);
    
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
        
        for (NSInteger i = 0; i < images.count; i++) {
            // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.jpg", str, i];
            NSData *imageData = UIImageJPEGRepresentation(images[i], 0.5);
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"请求成功方法名%@=%@",method,[responseObject description]);
        if (successs) {
            successs(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败方法名%@ error=%@",method,[error description]);
        //直接请求失败，把error传出来
        if (failure) {
            failure(error);
        }
    }];

}








//---------------------------------------自己尝试的一些老的请求网络的方式---------------------------------------------


//    NSString *urlString = [NSString stringWithFormat:@"%@%@",Interface_URL,method];
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    //缓存策略
//    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
//    
//    //请求头
//    //upload task不会在请求头里添加content-type(上传数据类型)字段
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8;boundary=%@", boundary];
//    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
//    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"head" ofType:@"jpg"];
//    //拼接请求体
//    NSData *bodyData=[self setBodydata:filePath]; //（注意上面宏定义的请求体边界下面就要用上了）
//    
//    
//    //创建网络会话
//    NSURLSession *session=[NSURLSession sharedSession];
//    
//    //创建网络上传任务
//    NSURLSessionUploadTask *dataTask=[session uploadTaskWithRequest:request fromData:bodyData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        //将接收到的data类型的数据转换为string
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        if (!error){
//            //请求成功并且把接收到的字符串解码后传出来
//            //注意有可能请求成功了，实际上返回的是后台错误信息，需要判断解码的字符串
//            
//            //解码数据类型，并捕获无法解析的异常
//            NSString *decryptStr = nil;
//            NSLog(@"后台返回，解码前的数据：\n%@",result);
//            
//            //正常的编码了的字符串，进行正常解码
//            decryptStr = [EncryptForInterface decryptWithText:result];
//            NSLog(@"后台返回，解码后的数据：\n%@",decryptStr);
//                
//            //将Json格式的String转换为dictionary
//            NSData *jsonData = [decryptStr dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                     options:NSJSONReadingMutableContainers
//                                                                       error:&err];
//            if(err) {
//                NSLog(@"加密时JSON数据转换成Dic时出现异常：%@",err);
//            }
//            if (success && dict) {
//                success(dict);
//            }
//        } else {
//            //直接请求失败，把error传出来
//            if (failure) {
//                failure(error);
//            }
//        }
//    }];
//    
//    //发送网络任务
//    [dataTask resume];
    
    
    



    
//    //成功的，原生请求方式
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",Interface_URL,method];
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
//    
//    [request setHTTPMethod:@"POST"];
//    
//    //将data转为string
//    NSLog(@"图片字符流data值：\n%@",imageData);
//    if (!imageData || [imageData length] == 0) {
//        NSLog(@"文件为0字节");
//    }
//    NSMutableString *hexString = [[NSMutableString alloc] initWithCapacity:[imageData length]];
//    
//    [imageData enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
//        unsigned char *dataBytes = (unsigned char*)bytes;
//        for (NSInteger i = 0; i < byteRange.length; i++) {
//            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
//            if ([hexStr length] == 2) {
//                [hexString appendString:hexStr];
//            } else {
//                [hexString appendFormat:@"0%@", hexStr];
//            }
//        }
//    }];
//    
//    NSLog(@"hexString======\n%@",hexString);
//    
//    NSString *str = [NSString stringWithFormat:@"{\"UpLoadType\":\"Headortrait\",\"UpLoadBaseValue\":\"%@\",\"UserCode\":\"100000002\"}",hexString];
//    
//    NSLog(@"str=====\n%@",str);
//    
//    [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    [str stringByReplacingOccurrencesOfString:@">" withString:@""];
//
//    NSString *bodyStr = [NSString stringWithFormat:@"Json=%@",str];
//    NSLog(@"bodyStr=====\n%@",str);
//    
//    //将参数转为data类型，并放入HttpBody中
//    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        //将接收到的data类型的数据转换为string
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        if (!error){
//            //请求成功并且把接收到的字符串解码后传出来
//            //注意有可能请求成功了，实际上返回的是后台错误信息，需要判断解码的字符串
//            
//            //解码数据类型，并捕获无法解析的异常
//            NSString *decryptStr = nil;
//            NSLog(@"后台返回，解码前的数据：\n%@",result);
//            
//            //判断result是否有中文，有的话应该要报“服务器处理异常”
//            NSUInteger length = [result length];
//            const char *cString = [result UTF8String];
//            if (strlen(cString) > length){
//                //包含中文
//                NSError *decryptError = [NSError errorWithDomain:@"zlct.com.cn" code:-1000 userInfo:@{NSLocalizedDescriptionKey:result}];
//                if (failure) {
//                    failure(decryptError);
//                }
//            } else {
//                //正常的编码了的字符串，进行正常解码
//                decryptStr = [EncryptForInterface decryptWithText:result];
//                NSLog(@"后台返回，解码后的数据：\n%@",decryptStr);
//                
//                //将Json格式的String转换为dictionary
//                NSData *jsonData = [decryptStr dataUsingEncoding:NSUTF8StringEncoding];
//                NSError *err;
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                     options:NSJSONReadingMutableContainers
//                                                                       error:&err];
//                if(err) {
//                    NSLog(@"加密时JSON数据转换成Dic时出现异常：%@",err);
//                }
//                
//                if (success && dict) {
//                    success(dict);
//                }
//            }
//        } else {
//            //直接请求失败，把error传出来
//            if (failure) {
//                failure(error);
//            }
//        }
//        
//    }];
//    
//    [task resume];









//+ (NSData *)setBodydata:(NSString *)filePath
//{
//    //把文件转换为NSData
//    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
//    
//    //1.构造body string
//    NSMutableString *bodyString = [[NSMutableString alloc] init];
//    
//    //2.拼接body string
//    //(1)access_token
//    [bodyString appendFormat:@"--%@\r\n", boundary];//（一开始的 --也不能忽略）
//    [bodyString appendFormat:@"Content-Disposition: form-data; name=\"access_token\"\r\n\r\n"];
//    [bodyString appendFormat:@"xxxxxx\r\n"];
//    
//    //(2)status
//    [bodyString appendFormat:@"--%@\r\n", boundary];
//    [bodyString appendFormat:@"Content-Disposition: form-data; name=\"status\"\r\n\r\n"];
//    [bodyString appendFormat:@"带图片的微博\r\n"];
//    
//    //(3)pic
//    [bodyString appendFormat:@"--%@\r\n", boundary];
//    [bodyString appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"file\"\r\n"];
//    [bodyString appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
//    
//    
//    //3.string --> data
//    NSMutableData *bodyData = [NSMutableData data];
//    //拼接的过程
//    //前面的bodyString, 其他参数
//    [bodyData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
//    //图片数据
//    [bodyData appendData:fileData];
//    
//    //4.结束的分隔线
//    NSString *endStr = [NSString stringWithFormat:@"\r\n--%@--\r\n",boundary];
//    //拼接到bodyData最后面
//    [bodyData appendData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    return bodyData;
//}




















//使用AFNetwork实现post方式
//// 请求的参数
//NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"Headortrait", @"LoginMark", @"13311122233", @"LoginName", @"zxcvbnm", @"LoginPassword", nil];
//
//NSString *jsonString = nil;
//NSError *error;
//NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
//                                                   options:NSJSONWritingPrettyPrinted
//                                                     error:&error];
//if (!jsonData) {
//    NSLog(@"加密时Dic转换成JSON数据时出现异常: %@", error);
//} else {
//    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//}
//NSLog(@"JSON数据:\n%@",jsonString);
////将JSON字符串加密
//NSString *encryptStr = [EncryptForInterface encryptWithText:jsonString];
//NSLog(@"加密的JSON数据:\n%@",encryptStr);
//
//NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:encryptStr, @"Json", nil];
//
//// 初始化Manager
//AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//// post请求
//[manager POST:@"http://192.168.1.116:8022/Index.asmx/Login" parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
//    // 这里可以获取到目前的数据请求的进度
//    
//} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//    
//    //将接收到的data类型的数据转换为string
//    NSData *data = responseObject;
//    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    //解码数据类型，并捕获无法解析的异常
//    NSString *decryptStr = nil;
//    NSLog(@"后台返回，解码前的数据：\n%@",result);
//    
//    //判断result是否有中文，有的话应该要报“服务器处理异常”
//    NSUInteger length = [result length];
//    const char *cString = [result UTF8String];
//    if (strlen(cString) > length){
//        //包含中文
//        NSError *decryptError = [NSError errorWithDomain:@"zlct.com.cn" code:-1000 userInfo:@{NSLocalizedDescriptionKey:result}];
//        if (failure) {
//            failure(decryptError);
//        }
//    } else {
//        //正常的编码了的字符串，进行正常解码
//        decryptStr = [EncryptForInterface decryptWithText:result];
//        NSLog(@"后台返回，解码后的数据：\n%@",decryptStr);
//        
//        //将Json格式的String转换为dictionary
//        NSData *jsonData = [decryptStr dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *err;
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                             options:NSJSONReadingMutableContainers
//                                                               error:&err];
//        if(err) {
//            NSLog(@"加密时JSON数据转换成Dic时出现异常：%@",err);
//        }
//        
//        if (success && dict) {
//            success(dict);
//        }
//    }
//    
//} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    
//    // 请求失败
//    NSLog(@"%@", [error localizedDescription]);
//    //直接请求失败，把error传出来
//    if (failure) {
//        failure(error);
//    }
//}];



@end
