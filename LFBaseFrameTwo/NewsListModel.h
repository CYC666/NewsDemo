//
//  NewsListModel.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/28.
//  Copyright © 2017年 admin. All rights reserved.
//

// 主页新闻列表数据模型

#import <Foundation/Foundation.h>

@interface NewsListModel : NSObject

@property (copy, nonatomic) NSString *ws_name;          // 网站名字
@property (copy, nonatomic) NSString *website_id;       // 网站id
@property (copy, nonatomic) NSString *mwsub_id;         // 订阅id (尚未订阅，没有)
@property (copy, nonatomic) NSString *mwsub_webid;      // 网站订阅id (尚未订阅，没有)
@property (copy, nonatomic) NSString *ws_logo;          // 网站logo

@property (copy, nonatomic) NSString *art_title;        // 文章标题
@property (copy, nonatomic) NSString *listId;           // 文章id
@property (copy, nonatomic) NSString *megmt_id;         // 收藏id (尚未收藏，没有)
@property (copy, nonatomic) NSString *megmt_artid;      // 文章收藏id (尚未收藏，没有)
@property (copy, nonatomic) NSString *art_content;      // 内容
@property (copy, nonatomic) NSString *art_type;         // 文章类型
@property (copy, nonatomic) NSString *art_readnum;      // 浏览量
@property (copy, nonatomic) NSString *art_creation_date;// 日期

@property (copy, nonatomic) NSString *mwsub_mbrid;


@end




//返回数据
/*
 "website_id" : "1",
 "ws_name" : "中国政府采购网",
 "ws_logo" : "zfcg_logo.jpg",
 "art_type" : "0",
 "mwsub_id" : null,
 "megmt_id" : null,
 "art_title" : "中山大学南校园游泳池及网球场改造工程中标公告",
 "megmt_artid" : null,
 "id" : "12219",
 "art_creation_date" : "2017-11-14 09:36:00",
 "mwsub_webid" : null,
 "art_content" : "中山大学南校园游泳池及网球场改造工程项目（项目编号：中大招（工）[2017]133号 ） 组织评标工作已经结束，现将评标结果公示如下： 一、项目信息项目编号：中大招（工）[2017]133号 项",
 "mwsub_mbrid" : null,
 "art_readnum" : "1"
 */
