//
//  MainBannerView.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/9/21.
//  Copyright © 2017年 admin. All rights reserved.
//

// 首页轮播图

#import "MainBannerView.h"
#import "WebForCommonViewController.h"

@interface MainBannerView () <SDCycleScrollViewDelegate> {

    NSMutableArray *bannerArray;            // 轮播图数据数组

}

@end

@implementation MainBannerView


#pragma mark ========================================控制器生命周期========================================
- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        bannerArray = [NSMutableArray array];
        
        [self loadBannerData];
    }
    
    return self;
    
    
    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    bannerArray = [NSMutableArray array];
    
    [self loadBannerData];
    
}



#pragma mark ========================================私有方法=============================================

#pragma mark ========================================动作响应=============================================

#pragma mark ========================================网络请求=============================================
#pragma mark - 轮播图
- (void)loadBannerData {
    
    self.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.delegate = self;
    self.currentPageDotColor = Publie_Color;
    self.pageDotColor=[UIColor whiteColor];
    self.placeholderImage = [UIImage imageNamed:@"默认图"];
    self.backgroundColor = Background_Color;
    self.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
    self.localizationImageNamesGroup = @[@"banner1", @"banner2", @"banner3"];
    
    
}


#pragma mark ========================================代理方法=============================================

#pragma mark - 点击了轮播图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {

    

}


#pragma mark ========================================通知================================================



































@end
