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

@property (copy, nonatomic) NSString *website_id;
@property (copy, nonatomic) NSString *ws_name;
@property (copy, nonatomic) NSString *ws_logo;
@property (copy, nonatomic) NSString *art_type;
@property (copy, nonatomic) NSString *mwsub_id;
@property (copy, nonatomic) NSString *megmt_id;
@property (copy, nonatomic) NSString *art_title;
@property (copy, nonatomic) NSString *megmt_artid;
@property (copy, nonatomic) NSString *listId;
@property (copy, nonatomic) NSString *art_creation_date;
@property (copy, nonatomic) NSString *mwsub_webid;
@property (copy, nonatomic) NSString *art_content;
@property (copy, nonatomic) NSString *mwsub_mbrid;
@property (copy, nonatomic) NSString *art_readnum;


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
