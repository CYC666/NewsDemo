//
//  MessageListModel.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageListModel : NSObject

@property (copy, nonatomic) NSString *listId;
@property (copy, nonatomic) NSString *mmsg_readflg;
@property (copy, nonatomic) NSString *mmsg_type_pic_path;
@property (copy, nonatomic) NSString *mmsg_title;
@property (copy, nonatomic) NSString *mmsg_remark;
@property (copy, nonatomic) NSString *mmsg_content;
@property (copy, nonatomic) NSString *mmsg_creation_date;





@end
