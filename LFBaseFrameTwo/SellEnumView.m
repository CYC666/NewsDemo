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
    
    NSMutableArray *typeArray;             // 类型数组
 
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
    
    typeArray = [NSMutableArray array];
    
    self.backgroundColor = [UIColor whiteColor];
    self.showsHorizontalScrollIndicator = NO;
    
    [self registerNib:[UINib nibWithNibName:@"SellEnumCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SellEnumCell"];
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    
    [self loadDingListAction];
    
}

- (void)setCellsDisplay:(NSInteger)index {

    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger i = 0; i < typeArray.count; i++) {
        DingModel *model = typeArray[i];
        
        // 重新设置选中状态
        if (i == index) {
            model.isSelect = YES;
        } else {
            model.isSelect = NO;
        }
        [tempArray addObject:model];
    }
    
    typeArray = tempArray;
    [self reloadData];
    
    // 将点中的单元格移至水平中部
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}


- (void)setSelectModel:(DingModel *)selectModel {

    _selectModel = selectModel;
    
    // 如果不是第一次加载，那么重新设置UI
    if (typeArray.count != 0) {
        
        for (NSInteger i = 0; i < typeArray.count; i++) {
            DingModel *model = typeArray[i];
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

- (void)setEnumDelegate:(id<SellEnumViewDelegate>)enumDelegate {
    
    _enumDelegate = enumDelegate;
    
    [_enumDelegate didLoadAllType:typeArray];
    
}

#pragma mark ========================================动作响应=============================================

#pragma mark ========================================网络请求=============================================

#pragma mark - 获取订阅分类列表
- (void)loadDingListAction {
    
    [SOAPUrlSession loadDingListActionSuccess:^(id responseObject) {
        
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if (responseCode.integerValue == 0) {
            
            [typeArray removeAllObjects];
            // 推荐
            DingModel *model1 = [[DingModel alloc] init];
            model1.ws_name = @"推荐";
            model1.mwsub_id = @"-1";
            model1.mwsub_wsid = @"-1";
            model1.ws_logo = @"";
            model1.isSelect = YES;
            
            [typeArray addObject:model1];
            
            NSArray *list = responseObject[@"data"];
            
            for (NSDictionary *dic in list) {
                
                DingModel *model = [[DingModel alloc] init];
                model.mwsub_id = [NSString stringWithFormat:@"%@", dic[@"mwsub_id"]];
                model.mwsub_wsid = [NSString stringWithFormat:@"%@", dic[@"mwsub_wsid"]];
                model.ws_logo = [NSString stringWithFormat:@"%@", dic[@"ws_logo"]];
                model.ws_name = [NSString stringWithFormat:@"%@", dic[@"ws_name"]];
                
                [typeArray addObject:model];
                
            }
            
        }
        
        //主线程更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 给父控制器传递所有类型，创建商品列表
            [_enumDelegate didLoadAllType:typeArray];
            
            // 类别的数目
            _typeCounts = typeArray.count;
            
            [self reloadData];
            
        });
        
        
        
    } failure:^(NSError *error) {
        
        //主线程更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            
            FadeAlertView *showMessage = [[FadeAlertView alloc] init];
            [showMessage showAlertWith:@"请求失败"];
            
        });
        
    }];
    
}



#pragma mark ========================================代理方法=============================================
#pragma mark - 集合视图代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return typeArray.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DingModel *model = typeArray[indexPath.item];
    
    
    return CGSizeMake(30 + 15 * model.ws_name.length, 40);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SellEnumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SellEnumCell" forIndexPath:indexPath];
    
    if (typeArray.count == 0) {
        
    } else {
    
        DingModel *model = typeArray[indexPath.item];
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
    
    if (typeArray.count == 0) {
        return;
    } else {
    
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSInteger i = 0; i < typeArray.count; i++) {
            DingModel *model = typeArray[i];
            
            // 重新设置选中状态
            if (i == indexPath.item) {
                model.isSelect = YES;
            } else {
                model.isSelect = NO;
            }
            [tempArray addObject:model];
        }
        
        typeArray = tempArray;
        [self reloadData];
        
        // 执行代理方法
        if ([_enumDelegate respondsToSelector:@selector(didChangeEnum:indexPath:)]) {
            DingModel *model = typeArray[indexPath.item];
            [_enumDelegate didChangeEnum:model indexPath:indexPath.item];
        }
        
    }
    
    
    
    
}

#pragma mark ========================================通知================================================






































@end
