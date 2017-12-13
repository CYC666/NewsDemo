//
//  ProtocolView.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProtocolView : UIView

// 顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstaint;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

+ (instancetype)viewFromXIB;


@end
