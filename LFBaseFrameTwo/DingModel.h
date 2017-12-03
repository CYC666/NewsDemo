//
//  DingModel.h
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DingModel : NSObject

@property (copy, nonatomic) NSString *mwsub_id;
@property (copy, nonatomic) NSString *mwsub_wsid;
@property (copy, nonatomic) NSString *mwsub_webid;
@property (copy, nonatomic) NSString *mwsub_mbrid;
@property (copy, nonatomic) NSString *ws_logo;
@property (copy, nonatomic) NSString *ws_name;

@property (assign, nonatomic) BOOL isSelect;    // 是否选中，订阅页

@end
