//
//  CanAddListView.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "CanAddListView.h"
#import "DingListCell.h"

@interface CanAddListView () <UICollectionViewDelegate, UICollectionViewDataSource>  {
    
    UICollectionView *_listCollectionView;
    
}

@end

@implementation CanAddListView


#pragma mark ========================================生命周期========================================
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self creatSubviewsAction];
        
    }
    return self;
    
    
}

#pragma mark ========================================私有方法=============================================

#pragma mark - 创建子视图
- (void)creatSubviewsAction {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = Label_Color_C;
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"点击添加更多网站";
    [self addSubview:label];
    
    // 集合视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth * 0.5, 40);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _listCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, (kScreenHeight - 64 - 10) * 0.5 - 30)
                                             collectionViewLayout:layout];
    _listCollectionView.backgroundColor = [UIColor clearColor];
    [_listCollectionView registerNib:[UINib nibWithNibName:@"DingListCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"DingListCell"];
    _listCollectionView.delegate = self;
    _listCollectionView.dataSource = self;
    [self addSubview:_listCollectionView];
    
}

#pragma mark ========================================动作响应=============================================

#pragma mark ========================================网络请求=============================================

#pragma mark ========================================代理方法=============================================
#pragma mark - 集合视图代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
    
}



- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DingListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DingListCell" forIndexPath:indexPath];
    
    [cell.cellButton setTitle:@"可以添加的网站" forState:UIControlStateNormal];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [_cellDelegate CanAddListViewIndexSelect:indexPath.item];
    
    
}


#pragma mark ========================================通知================================================





@end
