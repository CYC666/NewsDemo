//
//  SendIdeaCell.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendIdeaCell : UITableViewCell

//意见输入框
@property (weak, nonatomic) IBOutlet UITextView *messageField;

//搁置
@property (weak, nonatomic) IBOutlet UILabel *fieldHolderLabel;

//反馈类型标签
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

//网点追加
@property (weak, nonatomic) IBOutlet UIButton *zhuijiaButton;

//点子
@property (weak, nonatomic) IBOutlet UIButton *dianziButton;

//信息错误
@property (weak, nonatomic) IBOutlet UIButton *cuowuButton;

//闪退
@property (weak, nonatomic) IBOutlet UIButton *shantuiButton;

//其他
@property (weak, nonatomic) IBOutlet UIButton *qitaButton;

//提交
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end
