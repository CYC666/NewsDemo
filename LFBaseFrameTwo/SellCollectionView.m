//
//  SellCollectionView.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/9/25.
//  Copyright © 2017年 admin. All rights reserved.
//

// 特卖商品列表集合视图

#import "SellCollectionView.h"
#import "SellGoodsCell.h"
#import "SellEnumModel.h"


@interface SellCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate> {
    
    
    UserInformation *userInfo;              // 用户信息单例
    
    SmallFunctionTool *smallFunc;           // 工具方法单例
    
    NSMutableArray *goodsArray;             // 商品数组
    
    NSInteger currentPage;                  // 当前页
    
    UIView *noDataView;                     // 没有数据时显示的页面
    
}

@end

@implementation SellCollectionView







#pragma mark ========================================控制器生命周期========================================

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {

    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        // 设置基本信息
        [self settingAction];
    }
    return self;

}



#pragma mark ========================================私有方法=============================================

#pragma mark - 设置基本信息
- (void)settingAction {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self registerNib:[UINib nibWithNibName:@"SellGoodsCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SellGoodsCell"];
    self.delegate = self;
    self.dataSource = self;
    
    //初始化
    userInfo = [UserInformation sharedInstance];
    smallFunc = [SmallFunctionTool sharedInstance];
    goodsArray = [NSMutableArray array];
    currentPage = 1;
    
    _enumModel = [[SellEnumModel alloc] init];
    _enumModel.TypeId = @"default";
    _enumModel.TypeName = @"推荐";
    _enumModel.SortCode = @"default";
    _enumModel.isSelect = NO;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadGoodsData:NO];
        
        //关闭刷新
        [self.mj_header endRefreshing];
    }];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11];
    self.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self loadGoodsData:YES];
        
        //关闭刷新
        [self.mj_footer endRefreshing];
    }];
    footer.automaticallyHidden = YES;//自动根据有无数据来显示和隐藏
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    self.mj_footer = footer;
    
}

- (void)setEnumModel:(SellEnumModel *)enumModel {

    _enumModel = enumModel;
    
    // 重新搜索
    [self loadGoodsData:NO];

}

#pragma mark ========================================动作响应=============================================




#pragma mark ========================================网络请求=============================================
#pragma mark - 获取商品
- (void)loadGoodsData:(BOOL)isFooter {
    
    
    
}


#pragma mark ========================================代理方法=============================================
#pragma mark - 集合视图代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    return goodsArray.count;
    return 20;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kScreenWidth, 95);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SellGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SellGoodsCell" forIndexPath:indexPath];
    
    if (goodsArray.count == 0) {
        return cell;
    }
    
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

#pragma mark ========================================通知================================================

@end
