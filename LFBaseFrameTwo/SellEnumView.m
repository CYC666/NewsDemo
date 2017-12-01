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
#import "SellEnumModel.h"

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
    
    [self loadTypeAction];
    
}

- (void)setCellsDisplay:(NSInteger)index {

    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger i = 0; i < typeArray.count; i++) {
        SellEnumModel *model = typeArray[i];
        
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


- (void)setSelectModel:(SellEnumModel *)selectModel {

    _selectModel = selectModel;
    
    // 如果不是第一次加载，那么重新设置UI
    if (typeArray.count != 0) {
        
        for (NSInteger i = 0; i < typeArray.count; i++) {
            SellEnumModel *model = typeArray[i];
            if ([model.TypeId isEqualToString:selectModel.TypeId]) {
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
#pragma mark - 获取商品分类列表
- (void)loadTypeAction {
    

    
        // 推荐
        SellEnumModel *model1 = [[SellEnumModel alloc] init];
        model1.TypeName = @"推荐";
        model1.isSelect = YES;
        
        [typeArray addObject:model1];
        
        for (NSInteger i = 0; i < 10; i++) {
            
            SellEnumModel *model = [[SellEnumModel alloc] init];
            model.TypeName = @"中国大学慕课";
            
            [typeArray addObject:model];
        }
        
        
        

    
        // 给父控制器传递所有类型，创建商品列表
//        [_enumDelegate didLoadAllType:typeArray];
    
        // 类别的数目
        _typeCounts = typeArray.count;
    
    
        [self reloadData];
            

    
    
    
    
    
    
    
    
//    [SOAPUrlSession SOAPDataWithMethod:@"GetProductTypeList" parameter:nil success:^(id responseObject) {
//
//        if ([responseObject[@"Code"] integerValue] == 200) {
//
//            // 全部
//            SellEnumModel *All = [[SellEnumModel alloc] init];
//            All.TypeId = @"default";
//            All.TypeName = @"全部";
//            All.SortCode = @"default";
//            All.isSelect = YES;
//            [typeArray addObject:All];
//
//            // 其他
//            for (NSDictionary *dic in responseObject[@"Data"]) {
//
//                SellEnumModel *model = [[SellEnumModel alloc] init];
//                model.TypeId = [NSString stringWithFormat:@"%@", dic[@"TypeId"]];
//                model.TypeName = [NSString stringWithFormat:@"%@", dic[@"TypeName"]];
//                model.SortCode = [NSString stringWithFormat:@"%@", dic[@"SortCode"]];
//                model.isSelect = NO;
//
//                [typeArray addObject:model];
//
//            }
//
//        }
//
//
//        __block NSInteger tagIndex = 0; // 标识是否指向某个特定的标签
//
//        // 判断显示的是哪个分类
//        if (_selectModel) {
//
//            NSMutableArray *tempArray = [NSMutableArray array];
//            for (NSInteger i = 0; i < typeArray.count; i++) {
//                SellEnumModel *model = typeArray[i];
//                if ([model.TypeId isEqualToString:_selectModel.TypeId]) {
//                    tagIndex = i;
//                    model.isSelect = YES;
//                } else {
//                    model.isSelect = NO;
//                }
//                [tempArray addObject:model];
//            }
//            typeArray = tempArray;
//
//        }
//
//        //主线程更新视图
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            // 给父控制器传递所有类型，创建商品列表
//            if ([_enumDelegate respondsToSelector:@selector(didLoadAllType:)]) {
//                [_enumDelegate didLoadAllType:typeArray];
//            }
//
//            // 类别的数目
//            _typeCounts = typeArray.count;
//
//            [self reloadData];
//
//            // 单元格移至水平中部
//            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:tagIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//
//        });
//
//    } failure:^(NSError *error) {
//
//    }];
    
    
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
    
    SellEnumModel *model = typeArray[indexPath.item];
    
    
    return CGSizeMake(30 + 15 * model.TypeName.length, 40);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SellEnumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SellEnumCell" forIndexPath:indexPath];
    
    if (typeArray.count == 0) {
        
    } else {
    
        SellEnumModel *model = typeArray[indexPath.item];
        cell.nameLabel.text = model.TypeName;
        
        
        
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
            SellEnumModel *model = typeArray[i];
            
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
            SellEnumModel *model = typeArray[indexPath.item];
            [_enumDelegate didChangeEnum:model indexPath:indexPath.item];
        }
        
    }
    
    
    
    
}

#pragma mark ========================================通知================================================






































@end
