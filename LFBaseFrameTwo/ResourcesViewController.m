//
//  ResourcesViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

// 房源控制器

#import "ResourcesViewController.h"
#import "SellEnumView.h"
#import "SellCollectionView.h"
#import "SellEnumModel.h"
#import "NewsEnumView.h"
#import "DingListViewController.h"
#import "SearchViewController.h"

@interface ResourcesViewController () <SellEnumViewDelegate, UIScrollViewDelegate, NewsEnumViewDlegate> {
    
    SellEnumView *sellEnumView;                 // 分类
    
    UIScrollView *listScrollView;               // 承载多个商品列表的滑动视图
    
    NSMutableArray *enumModelArray;             // 所有分类数组
    
    UserInformation *userInfo;                  // 用户信息单例
    
    SmallFunctionTool *smallFunc;               // 工具方法单例
    
    NewsEnumView *newsEnumView;                 // 分类视图
    
    UIView *mainView;                           // 承载信息类目和列表的视图
    
}

@end


@implementation ResourcesViewController



#pragma mark ========================================控制器生命周期========================================


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订阅";
    self.view.backgroundColor = Background_Color;
    enumModelArray = [NSMutableArray array];
    
    //初始化
    userInfo = [UserInformation sharedInstance];
    smallFunc = [SmallFunctionTool sharedInstance];
    
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 49)];
    mainView.backgroundColor = Background_Color;
    [self.view addSubview:mainView];
    
    // 导航栏右边的两个按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"sou"]  forState:UIControlStateNormal];
    [searchButton setTintColor:[UIColor whiteColor]];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItemA = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    
    // 导航栏右边的添加按钮
    UIButton *rankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rankButton setImage:[UIImage imageNamed:@"select"]  forState:UIControlStateNormal];
    [rankButton setTintColor:[UIColor whiteColor]];
    rankButton.frame = CGRectMake(0, 0, 30, 30);
    [rankButton addTarget:self action:@selector(rankButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItemB = [[UIBarButtonItem alloc] initWithCustomView:rankButton];
    self.navigationItem.rightBarButtonItems = @[rightBarItemB, rightBarItemA];
    
    
    // 目录按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWidth - 30, 0, 30, 40);
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showAllEnumAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:button];
    
    // 分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 30, 0, 1, 40)];
    lineView1.backgroundColor = Background_Color;
    [mainView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 38, kScreenWidth, 2)];
    lineView2.backgroundColor = Background_Color;
    [mainView addSubview:lineView2];
    
    // 类目滑动区域
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    sellEnumView = [[SellEnumView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 40)
                                  collectionViewLayout:layout];
    sellEnumView.enumDelegate = self;
    //    enumView.selectModel = _selectModel;
    [mainView addSubview:sellEnumView];
    
    // 分类视图
    newsEnumView = [[NewsEnumView alloc] initWithFrame:CGRectMake(0, 24, kScreenWidth, 40)];
    newsEnumView.delegate = self;
    [self.view addSubview:newsEnumView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 获取列表
//    [self loadDingTypeListAction];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //停止风火轮
    [smallFunc stopActivityIndicator:@"ResourcesViewController"];
    
    
}

#pragma mark ========================================私有方法=============================================

#pragma mark - 创建列表视图
- (void)creatSubView:(NSArray<SellEnumModel *> *)typeArray {
    
    
    // 承载所有商品列表的滑动视图
    listScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 64 - 49 - 40)];
    listScrollView.contentSize = CGSizeMake(kScreenWidth * typeArray.count, kScreenHeight - 64 - 49 - 40);
    listScrollView.showsHorizontalScrollIndicator = NO;
    listScrollView.directionalLockEnabled = YES;
    listScrollView.pagingEnabled = YES;
    listScrollView.delegate = self;
    [mainView addSubview:listScrollView];
    
    for (NSInteger i = 0; i < typeArray.count; i++) {
        // 商品列表
        UICollectionViewFlowLayout *goodsLayout = [[UICollectionViewFlowLayout alloc] init];
        goodsLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        goodsLayout.minimumLineSpacing = 0;
        goodsLayout.minimumInteritemSpacing = 0;
        SellCollectionView *listCollectionView = [[SellCollectionView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight - 64 - 49 - 40)
                                                                      collectionViewLayout:goodsLayout];
        listCollectionView.superCtrl = self;
        listCollectionView.enumModel = typeArray[i];    // 设置分类，并开始加载数据
        [listScrollView addSubview:listCollectionView];
    }
    
    
    
}

- (void)setSelectModel:(SellEnumModel *)selectModel {
    
    _selectModel = selectModel;
    
    // 如果已经创建了视图，那么直接修改显示页
    if (sellEnumView) {
        sellEnumView.selectModel = selectModel;
        
        for (NSInteger i = 0; i < enumModelArray.count; i++) {
            SellEnumModel *model = enumModelArray[i];
            if ([selectModel.TypeId isEqualToString:model.TypeId]) {
                // 将滑动视图偏移到指定列表
                CGFloat distance = kScreenWidth * i;
                [UIView animateWithDuration:0.35 animations:^{
                    listScrollView.contentOffset = CGPointMake(distance, 0);
                }];
                return;
            }
        }
        
        
    }
    
    
    
}

#pragma mark ========================================动作响应=============================================

#pragma mark - 点击搜索
- (void)searchButtonAction:(UIButton *)button {
    
    SearchViewController *ctrl = [[SearchViewController alloc] init];
    ctrl.type = @"1";   // 搜索文章
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark - 点击排序
- (void)rankButtonAction:(UIButton *)button {
    
    if (newsEnumView.transform.ty == 40) {
        [UIView animateWithDuration:.2 animations:^{
            newsEnumView.transform = CGAffineTransformMakeTranslation(0, 0);
            mainView.transform = CGAffineTransformMakeTranslation(0, 0);
            
        }];
    } else {
        [UIView animateWithDuration:.2 animations:^{
            newsEnumView.transform = CGAffineTransformMakeTranslation(0, 40);
            mainView.transform = CGAffineTransformMakeTranslation(0, 40);

        }];
    }
    
    
}

#pragma mark - 点击目录
- (void)showAllEnumAction:(UIButton *)button {
    
    DingListViewController *ctrl = [[DingListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark ========================================网络请求=============================================





#pragma mark ========================================代理方法=============================================

#pragma mark - 滑动视图偏移了，要及时修改分类单元格的位置(要保证index不能小于0，不能大于类别的数目)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x / kScreenWidth;
    if (index <= 0) {
        index = 0;
    } else if (index > sellEnumView.typeCounts - 1 && sellEnumView.typeCounts) {
        index = sellEnumView.typeCounts - 1;
    }
    [sellEnumView setCellsDisplay:index];
    
}

#pragma mark - 切换了类型
- (void)didChangeEnum:(SellEnumModel *)model indexPath:(NSInteger)index{
    
    // 将滑动视图偏移到指定列表
    CGFloat distance = kScreenWidth * index;
    [UIView animateWithDuration:0.35 animations:^{
        listScrollView.contentOffset = CGPointMake(distance, 0);
    }];
    
    
}

#pragma mark - 加载了全部的类型
- (void)didLoadAllType:(NSArray<SellEnumModel *> *)typeArray {
    
    enumModelArray = [typeArray mutableCopy];
    
    // 创建商品列表
    [self creatSubView:typeArray];
    
}

#pragma mark - 分类选了类目
- (void)TopSearchViewIndexChange:(NSInteger)index {
    
    [UIView animateWithDuration:.2 animations:^{
        newsEnumView.transform = CGAffineTransformMakeTranslation(0, 40);
        mainView.transform = CGAffineTransformMakeTranslation(0, 40);

    }];
    
    FadeAlertView *showMessage = [[FadeAlertView alloc] init];
    [showMessage showAlertWith:[NSString stringWithFormat:@"%ld", index]];
    
    
    
}

#pragma mark ========================================通知================================================






































@end
