//
//  DidAddListView.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "DidAddListView.h"
#import "DingListCell.h"
#import "DingModel.h"

@interface DidAddListView () <UICollectionViewDelegate, UICollectionViewDataSource>  {
    
    UICollectionView *_listCollectionView;
    NSMutableArray *_dataArray;
    
}

@end

@implementation DidAddListView


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
    label.text = @"切换网站";
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

#pragma mark - 重新刷新数据
- (void)reloadDataWithArray:(NSMutableArray *)dataArray {
    
    [_dataArray removeAllObjects];
    for (DingModel *model in dataArray) {
        
        if ([model.mwsub_id isEqualToString:@""] || [model.mwsub_id isEqualToString:@"<null>"] || [model.mwsub_id isEqualToString:@"(null)"]) {
            
        } else {
            [_dataArray addObject:model];
        }
        
    }
    
    [_listCollectionView reloadData];
    
    
}

#pragma mark ========================================动作响应=============================================

#pragma mark - 点击了该网站
- (void)selectWebvAction:(UIButton *)button {
    
    [_cellDelegate DidAddListViewIndexSelect:_dataArray[button.tag]];
    
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
    
    if (_dataArray.count == 0) {
        
    } else {
        
        DingModel *model = _dataArray[indexPath.item];
        [cell.cellButton setTitle:model.ws_name forState:UIControlStateNormal];
        [cell.cellButton addTarget:self action:@selector(selectWebvAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
    
}



#pragma mark ========================================通知================================================





@end
