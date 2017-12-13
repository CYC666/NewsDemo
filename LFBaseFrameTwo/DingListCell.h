//
//  DingListCell.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DingListCell : UICollectionViewCell


// 多功能按钮
@property (weak, nonatomic) IBOutlet UIButton *funButton;

// 标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

// 按钮
@property (weak, nonatomic) IBOutlet UIButton *cellButton;


@end
