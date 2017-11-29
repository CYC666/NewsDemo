//
//  LFBaseViewController.h
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/16.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFBaseViewController : UIViewController

//工具方法单例
@property (nonatomic) SmallFunctionTool *smallFunc;
//用户信息单例
@property (nonatomic) UserInformation *userInfo;

@property(nonatomic)NSString *IstextView;

///基础的滑动视图
@property (nonatomic) UIScrollView *contentView;

///解决有Storyboard创建的从VC不能添加contentView的问题，添加标志位，防止重复加载
@property (nonatomic) BOOL isFirstSB;


///使用xib创建的VC添加滑动功能
- (void)addScrollViewForXib:(UIView *)oneSubview withFrame:(CGRect)tempFrame;


///给Storyboard创建的VC添加滑动功能
//- (void)addScrollViewForSB:(UIView *)oneSubview withFrame:(CGRect)tempFrame;
/*!
 * 虽然使用这个方法可以实现Storyboard上的视图控制器直接加上滑动效果，但是有导航栏的时候会有高度的约束问题，
 * 而且每个视图控制器都需要创建两边，很影响资源，不建议使用这中方法。
 * 统一在创建一般的VC时使用xib来创建，如果想用这个方法，记得在对应的类中加入下列代码：
 
 - (void)viewDidAppear:(BOOL)animated {
 
 [super viewDidAppear:animated];
 
 if (self.isFirstSB) {
 
 //创建一个传递过去的self.view
 OrderPageViewController *oneView = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderPageViewController"];
 UIView *originalView = oneView.view;
 CGRect originalFrame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-48);
 //修改标志位
 oneView.isFirstSB = NO;
 
 
 //是第一次加载SB的self.view ，则执行添加滑动视图的操作
 [self addScrollViewForSB:originalView withFrame:originalFrame];
 }
 
 }
 
 */




@end
