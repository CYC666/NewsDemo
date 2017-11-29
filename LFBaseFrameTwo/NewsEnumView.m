//
//  NewsEnumView.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "NewsEnumView.h"

@implementation NewsEnumView

#pragma mark ========================================生命周期========================================

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self creatSubviewsAction];
        
    }
    
    return self;
    
}



#pragma mark ========================================私有方法=============================================

#pragma mark - 创建视图
- (void)creatSubviewsAction {
    
    // 初始化
    self.backgroundColor = [UIColor whiteColor];
    
    // 创建视图
    
    _AllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _AllButton.frame = CGRectMake(0, 0, kScreenWidth * 0.334, 40);
    [_AllButton setTitle:@"全部" forState:UIControlStateNormal];
    [_AllButton setTitleColor:Label_Color_A forState:UIControlStateNormal];
    _AllButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_AllButton addTarget:self action:@selector(allButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_AllButton];
    
    UIView *lineA = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.334, 10, 1, 20)];
    lineA.backgroundColor = Label_Color_B;
    [self addSubview:lineA];
    
    _zhaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _zhaoButton.frame = CGRectMake(kScreenWidth * 0.334, 0, kScreenWidth * 0.334, 40);
    [_zhaoButton setTitle:@"招标信息" forState:UIControlStateNormal];
    [_zhaoButton setTitleColor:Label_Color_C forState:UIControlStateNormal];
    _zhaoButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_zhaoButton addTarget:self action:@selector(zhaoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_zhaoButton];
    
    UIView *lineB = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.334 * 2, 10, 1, 20)];
    lineB.backgroundColor = Label_Color_B;
    [self addSubview:lineB];
    
    _zhongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _zhongButton.frame = CGRectMake(kScreenWidth * 0.334 * 2, 0, kScreenWidth * 0.334, 40);
    [_zhongButton setTitle:@"中标信息" forState:UIControlStateNormal];
    [_zhongButton setTitleColor:Label_Color_C forState:UIControlStateNormal];
    _zhongButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_zhongButton addTarget:self action:@selector(zhongButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_zhongButton];
    
}



#pragma mark ========================================动作响应=============================================

#pragma mark - 点击全部
- (void)allButtonAction:(UIButton *)button {
    
    _AllButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _zhaoButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _zhongButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [_AllButton setTitleColor:Label_Color_A forState:UIControlStateNormal];
    [_zhaoButton setTitleColor:Label_Color_C forState:UIControlStateNormal];
    [_zhongButton setTitleColor:Label_Color_C forState:UIControlStateNormal];
    
    [_delegate TopSearchViewIndexChange:0];
    
}

#pragma mark - 点击招标信息
- (void)zhaoButtonAction:(UIButton *)button {
    
    _AllButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _zhaoButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _zhongButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [_AllButton setTitleColor:Label_Color_C forState:UIControlStateNormal];
    [_zhaoButton setTitleColor:Label_Color_A forState:UIControlStateNormal];
    [_zhongButton setTitleColor:Label_Color_C forState:UIControlStateNormal];
    
    [_delegate TopSearchViewIndexChange:1];
    
}

#pragma mark - 点击中标信息
- (void)zhongButtonAction:(UIButton *)button {
    
    _AllButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _zhaoButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _zhongButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    [_AllButton setTitleColor:Label_Color_C forState:UIControlStateNormal];
    [_zhaoButton setTitleColor:Label_Color_C forState:UIControlStateNormal];
    [_zhongButton setTitleColor:Label_Color_A forState:UIControlStateNormal];
    
    [_delegate TopSearchViewIndexChange:2];
    
}


#pragma mark ========================================网络请求=============================================

#pragma mark ========================================代理方法=============================================

#pragma mark ========================================通知================================================

@end
