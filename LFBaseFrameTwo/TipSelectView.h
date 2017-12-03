//
//  TipSelectView.h
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TipSelectViewDlegate
-(void)TipSelectViewIndexChange:(NSString *)tip;
@end


@interface TipSelectView : UIView

@property (strong, nonatomic) NSArray *tipArray;;

// 代理
@property (weak, nonatomic) id<TipSelectViewDlegate> delegate;


@end
