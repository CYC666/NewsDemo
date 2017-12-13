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
#import "DingModel.h"
#import "SellCollectionView.h"
#import "NewsEnumView.h"
#import "DingListViewController.h"
#import "SearchViewController.h"
#import "LoginViewController.h"

@interface ResourcesViewController () <SellEnumViewDelegate, UIScrollViewDelegate, NewsEnumViewDlegate, DingListViewControllerDelegate> {
    
    SellEnumView *sellEnumView;                 // 分类
    
    UIScrollView *listScrollView;               // 承载多个商品列表的滑动视图
    
    NSMutableArray *enumModelArray;             // 所有分类数组
    
    UserInformation *userInfo;                  // 用户信息单例
    
    SmallFunctionTool *smallFunc;               // 工具方法单例
    
    NewsEnumView *newsEnumView;                 // 分类视图
    
    UIView *mainView;                           // 承载信息类目和列表的视图
    
    NSString *art_type;                         // （文章类别：全部 -1 招标信息 1  中标公示 0）
    
    NSMutableArray *typeArray;                  // 分类
    
    BOOL didShowLogin;                          // 是否显示了一次登录页
    
    UIView *loginView;                          // 显示登录的页面
    
}

@end


@implementation ResourcesViewController



#pragma mark ========================================控制器生命周期========================================


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订阅";
    
    //初始化
    userInfo = [UserInformation sharedInstance];
    smallFunc = [SmallFunctionTool sharedInstance];
    self.view.backgroundColor = Background_Color;
    enumModelArray = [NSMutableArray array];
    typeArray = [NSMutableArray array];
    art_type = @"-1";
    
    // 列表
    CGFloat startY = 0;
    CGFloat endY = 0;
    CGFloat startBarY = 0;
    if (kScreenHeight == 812) {
        startY = 88;    // iPhone X
        endY = 83;
        startBarY = 48;
    } else {
        startY = 64;    // 其他机型
        endY = 49;
        startBarY = 24;
    }
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0, startY, kScreenWidth, kScreenHeight - startY - endY)];
    mainView.backgroundColor = [UIColor whiteColor];
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
    newsEnumView = [[NewsEnumView alloc] initWithFrame:CGRectMake(0, startBarY, kScreenWidth, 40)];
    newsEnumView.delegate = self;
    [self.view addSubview:newsEnumView];
    
    // 获取列表
    [self loadDingListAction];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 检测登录状态
    [self checkLoginAction];

    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //停止风火轮
    [smallFunc stopActivityIndicator:@"ResourcesViewController"];
    
    
}

#pragma mark ========================================私有方法=============================================

#pragma mark - 创建列表视图
- (void)creatSubView:(NSArray<DingModel *> *)typeArray {
    
    if (listScrollView) {
        [listScrollView removeFromSuperview];
        listScrollView = nil;
    }
    
    // 承载所有商品列表的滑动视图
    CGFloat startY = 0;
    CGFloat endY = 0;
    if (kScreenHeight == 812) {
        startY = 88;    // iPhone X
        endY = 83;
    } else {
        startY = 64;    // 其他机型
        endY = 49;
    }
    listScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - startY - endY - 40)];
    listScrollView.contentSize = CGSizeMake(kScreenWidth * typeArray.count, kScreenHeight - startY - endY - 40);
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
        SellCollectionView *listCollectionView = [[SellCollectionView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight - startY - endY - 40)
                                                                      collectionViewLayout:goodsLayout];
        listCollectionView.superCtrl = self;
        listCollectionView.art_type = art_type;
        listCollectionView.enumModel = typeArray[i];    // 设置分类，并开始加载数据
        [listScrollView addSubview:listCollectionView];
    }
    
    
    
}

- (void)setSelectModel:(DingModel *)selectModel {
    
    _selectModel = selectModel;
    
    // 如果已经创建了视图，那么直接修改显示页
    if (sellEnumView) {
        sellEnumView.selectModel = selectModel;
        
        for (NSInteger i = 0; i < enumModelArray.count; i++) {
            DingModel *model = enumModelArray[i];
            if ([selectModel.ws_name isEqualToString:model.ws_name]) {
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
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark - 跳转登录
- (void)loginButtonAction:(UIButton *)button {
    
    // 跳转登录页面
    LoginViewController *ctrl = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}


#pragma mark ========================================网络请求=============================================

#pragma mark - 检测登录
- (void)checkLoginAction {
    
    
    [SOAPUrlSession loadDingListActionSuccess:^(id responseObject) {
        
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
        
        if (responseCode.integerValue == 0) {
            
            NSArray *list = responseObject[@"data"];
            NSMutableArray *tempArray = [NSMutableArray array];

            for (NSDictionary *dic in list) {

                DingModel *model = [[DingModel alloc] init];
                model.mwsub_id = [NSString stringWithFormat:@"%@", dic[@"mwsub_id"]];
                model.mwsub_wsid = [NSString stringWithFormat:@"%@", dic[@"mwsub_wsid"]];
                model.ws_logo = [NSString stringWithFormat:@"%@", dic[@"ws_logo"]];
                model.ws_name = [NSString stringWithFormat:@"%@", dic[@"ws_name"]];

                [tempArray addObject:model];

            }

            if (tempArray.count == typeArray.count - 1) {

                // 不重新加载

            } else {

                // 获取列表
                [self loadDingListAction];

            }
            
            
            
            if (loginView) {
                [loginView removeFromSuperview];
                loginView = nil;
            }
            
        } else if ([responseCode isEqualToString:@"1"] && [msg isEqualToString:@"没有取到数据"]) {
            
            // 没有订阅，那么显示 添加订阅按钮
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (loginView) {
                    [loginView removeFromSuperview];
                    loginView = nil;
                }
                
                loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                loginView.backgroundColor = Background_Color;
                [self.view addSubview:loginView];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, 0, 150, 150);
                button.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
                [button setImage:[UIImage imageNamed:@"shouldLogin"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(showAllEnumAction:) forControlEvents:UIControlEventTouchUpInside];
                [loginView addSubview:button];
                
                
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
                label1.center = CGPointMake(kScreenWidth * 0.5 + 0.5, kScreenHeight * 0.5 + 40.5);
                label1.textAlignment = NSTextAlignmentCenter;
                label1.textColor = Label_Color_B;
                label1.font = [UIFont systemFontOfSize:15];
                label1.text = @"点击添加订阅";
                [loginView addSubview:label1];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
                label.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5 + 40);
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont systemFontOfSize:15];
                label.text = @"点击添加订阅";
                [loginView addSubview:label];
                
            });
            
            
            
            
//            if (typeArray.count == 1) {
//
//                // 已经显示了推荐，不用再次刷新
//                //主线程更新视图
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    if (loginView) {
//                        [loginView removeFromSuperview];
//                        loginView = nil;
//                    }
//
//                });
//
//            } else {
//
//                [typeArray removeAllObjects];
//                // 只显示推荐
//                DingModel *model1 = [[DingModel alloc] init];
//                model1.ws_name = @"推荐";
//                model1.mwsub_id = @"-1";
//                model1.mwsub_wsid = @"-1";
//                model1.ws_logo = @"";
//                model1.isSelect = YES;
//
//                [typeArray addObject:model1];
//
//                //主线程更新视图
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    // 显示分类视图
//                    sellEnumView.typeArray = typeArray;
//
//                    // 创建列表
//                    [self creatSubView:typeArray];
//
//                    if (loginView) {
//                        [loginView removeFromSuperview];
//                        loginView = nil;
//                    }
//
//                });
//
//            }
            
            
            
            
        } else if ([msg isEqualToString:@"此操作必须登录"]) {
            
            
            //主线程更新视图
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (loginView) {
                    [loginView removeFromSuperview];
                    loginView = nil;
                }
                
                loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                loginView.backgroundColor = Background_Color;
                [self.view addSubview:loginView];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, 0, 150, 150);
                button.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
                [button setImage:[UIImage imageNamed:@"shouldLogin"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [loginView addSubview:button];
                
                
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
                label1.center = CGPointMake(kScreenWidth * 0.5 + 0.5, kScreenHeight * 0.5 + 40.5);
                label1.textAlignment = NSTextAlignmentCenter;
                label1.textColor = Label_Color_B;
                label1.font = [UIFont systemFontOfSize:15];
                label1.text = @"点击登录";
                [loginView addSubview:label1];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
                label.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5 + 40);
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont systemFontOfSize:15];
                label.text = @"点击登录";
                [loginView addSubview:label];

            });
            
        }

    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 获取订阅分类列表
- (void)loadDingListAction {
    
    [typeArray removeAllObjects];
    
    
    [SOAPUrlSession loadDingListActionSuccess:^(id responseObject) {
        
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if (responseCode.integerValue == 0) {
            
            
            
            NSArray *list = responseObject[@"data"];
            
            for (NSDictionary *dic in list) {
                
                DingModel *model = [[DingModel alloc] init];
                model.mwsub_id = [NSString stringWithFormat:@"%@", dic[@"mwsub_id"]];
                model.mwsub_wsid = [NSString stringWithFormat:@"%@", dic[@"mwsub_wsid"]];
                model.ws_logo = [NSString stringWithFormat:@"%@", dic[@"ws_logo"]];
                model.ws_name = [NSString stringWithFormat:@"%@", dic[@"ws_name"]];
                
                [typeArray addObject:model];
                
            }
            
            if (typeArray.count != 0) {
                // 去重复
                NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
                
                for (DingModel *model in typeArray) {
                    
                    [mDic setObject:model forKey:model.ws_name];
                    
                }
                typeArray = [mDic.allValues mutableCopy];
                
            }
            
            // 推荐
            DingModel *model1 = [[DingModel alloc] init];
            model1.ws_name = @"推荐";
            model1.mwsub_id = @"-1";
            model1.mwsub_wsid = @"-1";
            model1.ws_logo = @"";
            model1.isSelect = YES;
            
            [typeArray insertObject:model1 atIndex:0];
            
            
            //主线程更新视图
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // 显示分类视图
                sellEnumView.typeArray = typeArray;
                
                // 创建列表
                [self creatSubView:typeArray];
                
            });
            
        }
        
        
        
        
        
    } failure:^(NSError *error) {
        
        //主线程更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            
            FadeAlertView *showMessage = [[FadeAlertView alloc] init];
            [showMessage showAlertWith:@"请求失败"];
            
        });
        
    }];
    
}



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
- (void)didChangeEnum:(DingModel *)model indexPath:(NSInteger)index{
    
    // 将滑动视图偏移到指定列表
    CGFloat distance = kScreenWidth * index;
    [UIView animateWithDuration:0.35 animations:^{
        listScrollView.contentOffset = CGPointMake(distance, 0);
    }];
    
    
}

#pragma mark - 加载了全部的类型
- (void)didLoadAllType:(NSArray<DingModel *> *)typeArray {
    
    enumModelArray = [typeArray mutableCopy];
    
    // 创建商品列表
    [self creatSubView:typeArray];
    
}

#pragma mark - 分类选了类目
- (void)TopSearchViewIndexChange:(NSInteger)index {
    
 
    
    [UIView animateWithDuration:.2 animations:^{
        newsEnumView.transform = CGAffineTransformMakeTranslation(0, 40);
        mainView.transform = CGAffineTransformMakeTranslation(0, 40);
    } completion:^(BOOL finished) {
        
        if (index == 0) {
            
            // 全部文章
            art_type = @"-1";
        } else if (index == 1) {
            
            // 招标信息
            art_type = @"1";
        } else {
            
            // 中标信息
            art_type = @"0";
        }
    
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"art_type_change" object:art_type];
        
        
    }];
    
    
    
    
}

#pragma mark - 选择了指定要看的页面
- (void)DingListViewControllerIndexChange:(NSInteger)index finishBlock:(DingListViewControllerBlock)finishBlock{
    
    // 切换显示
//    [sellEnumView setCellsDisplay:index + 1]; // 滑动的代理方法里面，也设置了眉目的显示
    [listScrollView setContentOffset:CGPointMake(kScreenWidth * (index + 1), 0) animated:YES];
    
    // 执行回调，告知可以返回了
    finishBlock();

    
}


#pragma mark - 添加了订阅
- (void)DingListViewControllerAddModel:(DingModel *)model {
    
    // 刷新数据
    [self loadDingListAction];
    
    
    
    
    
    
//    [typeArray addObject:model];
//
//    // 重新显示类目
//    sellEnumView.typeArray = typeArray;
//
//    listScrollView.contentSize = CGSizeMake(kScreenWidth * typeArray.count, kScreenHeight - 64 - 49 - 40);
//
//    // 商品列表
//    UICollectionViewFlowLayout *goodsLayout = [[UICollectionViewFlowLayout alloc] init];
//    goodsLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    goodsLayout.minimumLineSpacing = 0;
//    goodsLayout.minimumInteritemSpacing = 0;
//    SellCollectionView *listCollectionView = [[SellCollectionView alloc] initWithFrame:CGRectMake(kScreenWidth * (typeArray.count - 1), 0, kScreenWidth, kScreenHeight - 64 - 49 - 40)
//                                                                  collectionViewLayout:goodsLayout];
//    listCollectionView.superCtrl = self;
//    listCollectionView.art_type = art_type;
//    listCollectionView.enumModel = typeArray.lastObject;    // 设置分类，并开始加载数据
//    [listScrollView addSubview:listCollectionView];
    
    
}



#pragma mark ========================================通知================================================






































@end
