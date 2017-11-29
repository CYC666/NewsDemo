//
//  MessagePrivateInfo.h
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessagePrivateInfo : NSObject

//id
@property (nonatomic) NSString *logid;
//标题
@property (nonatomic) NSString *title;
//内容
@property (nonatomic) NSString *content;
//用户id
@property (nonatomic) NSString *userid;
//创建时间
@property (nonatomic) NSString *createdate;
//是否已读（0-未读，1-已读）
@property (nonatomic) NSString *readmark;




- (instancetype)initWithlogid:(NSString *)logid
                        title:(NSString *)title
                      content:(NSString *)content
                       userid:(NSString *)userid
                   createdate:(NSString *)createdate
                     readmark:(NSString *)readmark;


@end
