//
//  SellEnumView.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/9/25.
//  Copyright © 2017年 admin. All rights reserved.
//

// 类目滑动区域

#import "SellEnumView.h"
#import "SellEnumCell.h"
#import "DingModel.h"

@interface SellEnumView () <UICollectionViewDataSource, UICollectionViewDelegate> {
    
 
}

@end

@implementation SellEnumView







#pragma mark ========================================控制器生命周期========================================

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout {

    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        // 设置视图信息
        [self setInfoAction];
    }
    return self;

}


#pragma mark ========================================私有方法=============================================

#pragma mark - 配置视图信息
- (void)setInfoAction {
    
    _typeArray = [NSMutableArray array];
    
    self.backgroundColor = [UIColor whiteColor];
    self.showsHorizontalScrollIndicator = NO;
    
    [self registerNib:[UINib nibWithNibName:@"SellEnumCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SellEnumCell"];
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    
    
    
}

- (void)setCellsDisplay:(NSInteger)index {

    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _typeArray.count; i++) {
        DingModel *model = _typeArray[i];
        
        // 重新设置选中状态
        if (i == index) {
            model.isSelect = YES;
        } else {
            model.isSelect = NO;
        }
        [tempArray addObject:model];
    }
    
    _typeArray = tempArray;
    [self reloadData];
    
    // 将点中的单元格移至水平中部
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}


- (void)setSelectModel:(DingModel *)selectModel {

    _selectModel = selectModel;
    
    // 如果不是第一次加载，那么重新设置UI
    if (_typeArray.count != 0) {
        
        for (NSInteger i = 0; i < _typeArray.count; i++) {
            DingModel *model = _typeArray[i];
            if ([model.mwsub_id isEqualToString:selectModel.mwsub_id]) {
                model.isSelect = YES;
                // 单元格移至水平中部
                [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            } else {
                model.isSelect = NO;
            }
        }
        
        
        
    }

}

- (void)setTypeArray:(NSMutableArray *)typeArray {
    
    _typeArray = typeArray;
    
    [self reloadData];
    
    
}

- (void)setEnumDelegate:(id<SellEnumViewDelegate>)enumDelegate {
    
    _enumDelegate = enumDelegate;
    
    
}

#pragma mark ========================================动作响应=============================================

#pragma mark ========================================网络请求=============================================


#pragma mark ========================================代理方法=============================================
#pragma mark - 集合视图代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return _typeArray.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DingModel *model = _typeArray[indexPath.item];
    
    
    return CGSizeMake(30 + 15 * model.ws_name.length, 40);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SellEnumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SellEnumCell" forIndexPath:indexPath];
    
    if (_typeArray.count == 0) {
        
    } else {
    
        DingModel *model = _typeArray[indexPath.item];
        cell.nameLabel.text = model.ws_name;
        
        
        
        if (model.isSelect) {
            
            cell.isSelect = model.isSelect;
            
            // 名字的颜色
            cell.nameLabel.textColor = Publie_Color;
            
            // 名字的大小
            cell.nameLabel.font = [UIFont systemFontOfSize:17];
            
        } else {
            
            cell.isSelect = model.isSelect;
            
            cell.nameLabel.textColor = Label_Color_C;
            cell.nameLabel.font = [UIFont systemFontOfSize:15];
        }
    
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 将点中的单元格移至水平中部
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if (_typeArray.count == 0) {
        return;
    } else {
    
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSInteger i = 0; i < _typeArray.count; i++) {
            DingModel *model = _typeArray[i];
            
            // 重新设置选中状态
            if (i == indexPath.item) {
                model.isSelect = YES;
            } else {
                model.isSelect = NO;
            }
            [tempArray addObject:model];
        }
        
        _typeArray = tempArray;
        [self reloadData];
        
        // 执行代理方法
        if ([_enumDelegate respondsToSelector:@selector(didChangeEnum:indexPath:)]) {
            DingModel *model = _typeArray[indexPath.item];
            [_enumDelegate didChangeEnum:model indexPath:indexPath.item];
        }
        
    }
    
    
    
    
}

#pragma mark ========================================通知================================================






































@end
