//
//  CanAddListView.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "CanAddListView.h"
#import "DingListCell.h"
#import "DingModel.h"

@interface CanAddListView () <UICollectionViewDelegate, UICollectionViewDataSource>  {
    
    
    NSMutableArray *_dataArray;
    
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
    _dataArray = [NSMutableArray array];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = Label_Color_C;
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"点击添加更多网站";
    [self addSubview:label];
    
    // 集合视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth * 0.5, 50);
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

#pragma mark - 重新刷新数据
- (void)reloadDataWithArray:(NSMutableArray *)dataArray {
    
    [_dataArray removeAllObjects];
    for (DingModel *model in dataArray) {
        
        if ([model.mwsub_id isEqualToString:@""] || [model.mwsub_id isEqualToString:@"<null>"] || [model.mwsub_id isEqualToString:@"(null)"]) {
            
            [_dataArray addObject:model];
        } else {
        }
        
    }
    
    [_listCollectionView reloadData];
    
    
}

#pragma mark ========================================动作响应=============================================

#pragma mark - 点击了该网站500
- (void)selectWebvAction:(UIButton *)button {
    
    
    [_cellDelegate CanAddListViewIndexSelect:_dataArray[button.tag - 500]];
    
}


#pragma mark - 添加订阅600
- (void)addButtonAction:(UIButton *)button {
    
    
}



#pragma mark ========================================网络请求=============================================

#pragma mark ========================================代理方法=============================================
#pragma mark - 集合视图代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count;
    
}



- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DingListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DingListCell" forIndexPath:indexPath];
    cell.isDidCell = NO;
    
    if (_dataArray.count == 0) {
        
    } else {
        
        DingModel *model = _dataArray[indexPath.item];
        cell.nameLabel.text = model.ws_name;
        cell.cellButton.tag = 500 + indexPath.item;
        cell.funButton.tag = 600 + indexPath.item;
        
//        if (_isEdit) {
//
//            // 编辑状态可删除，不可点击
//            [cell.funButton setImage:[UIImage imageNamed:@"添加订阅"] forState:UIControlStateNormal];
//            [cell.funButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//            cell.funButton.userInteractionEnabled = YES;
//            cell.cellButton.userInteractionEnabled = NO;
//        } else {
//
//            cell.funButton.userInteractionEnabled = NO;
//            cell.cellButton.userInteractionEnabled = YES;
//        }
        [cell.funButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [cell.cellButton addTarget:self action:@selector(selectWebvAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return cell;
    
}







@end
