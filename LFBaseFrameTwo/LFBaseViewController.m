//
//  LFBaseViewController.m
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/16.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "LFBaseViewController.h"
#import "UIScrollView+UITouch.h"

@interface LFBaseViewController ()
{
    //临时保存滑动视图的大小
    CGRect scrollViewFrame;
    
    //临时保存内容的大小
    CGRect contentViewFrame;
}
@end

@implementation LFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化
    self.smallFunc = [SmallFunctionTool sharedInstance];
    self.userInfo = [UserInformation sharedInstance];
    
    //当给从Storyboard创建的VC添加滑动效果时才用到，现在没有用到
    self.isFirstSB = YES;
    
    //设置视图的背景色
    self.view.backgroundColor = Background_Color;
    
    
    //设置导航栏的颜色和文字样式
    self.navigationController.navigationBar.barTintColor = Publie_Color;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                                    NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    //    //添加导航栏的返回按钮
    //    if ([self.navigationController.viewControllers indexOfObject:self] != 0) {
    //
    //        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    //        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //        [button sizeToFit];
    //        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    //
    //    }
    
    
    //给超出界面的视图添加滑动功能
    self.automaticallyAdjustsScrollViewInsets = NO; //关闭自动调整，主要是自动调整时tableview会有64个像素的变动
    //生成contentView
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1)];
    [self.view addSubview:self.contentView];
    
    
    //    self.contentView.contentSize = self.contentView.bounds.size;
    //
    //    //在viewWillAppear中去判断修改contentView的展示范围
    //    CGFloat contentHeight = 0;
    //    NSArray * subViews = self.contentView.subviews;
    //    for (UIView * view in subViews) {
    //        if (CGRectGetMaxY(view.frame) > contentHeight) {
    //            contentHeight = CGRectGetMaxY(view.frame);
    //        }
    //    }
    //    //笔者项目主要是上下滚动，如视图可能超出视图右侧，也能以同样方式实现其效果
    //    if (contentHeight > self.contentView.bounds.size.height) {
    //        self.contentView.contentSize = CGSizeMake(self.contentView.bounds.size.width, contentHeight);
    //    }
    
    
    
    //添加下滑收起键盘功能
    UISwipeGestureRecognizer *downGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    downGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.contentView addGestureRecognizer:downGesture];
    
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //弹出键盘时，判断根据键盘的高度看是否可滑动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //去除掉通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//下滑手势收起键盘
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender {
    
    //判断滑动的方向
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        
        //收起键盘的3种方式
        
        //方式1
        [self.contentView endEditing:YES];
        
        //方式2
        //[[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        
        //方式3
        //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
    }
    
}

//交互事件开始时收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //方式1
    [self.contentView endEditing:YES];
    
    //方式2
    //[[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    //方式3
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}



///使用xib创建的VC添加滑动功能
- (void)addScrollViewForXib:(UIView *)oneSubview withFrame:(CGRect)tempFrame {
    
    
    //修改contentView视图的大小
    self.contentView.frame = tempFrame;
    self.contentView.contentSize = self.contentView.bounds.size;
    
    //添加原来的VC中的self.view中的内容
    [self.contentView addSubview:oneSubview];
    
    
    //在viewWillAppear中去判断修改contentView的展示范围
    CGFloat contentHeight = 0;
    NSArray * subViews = self.contentView.subviews;
    for (UIView * view in subViews) {
        if (CGRectGetMaxY(view.frame) > contentHeight) {
            contentHeight = CGRectGetMaxY(view.frame);
        }
    }
    
    //笔者项目主要是上下滚动，如视图可能超出视图右侧，也能以同样方式实现其效果
    if (contentHeight > self.contentView.bounds.size.height) {
        self.contentView.contentSize = CGSizeMake(self.contentView.bounds.size.width, contentHeight);
    } else {
        self.contentView.contentSize = CGSizeMake(self.contentView.bounds.size.width, contentHeight);
        //没有内容超过contentView的高度时，调整contentView的高度
        CGRect contentFrame = self.contentView.frame;
        contentFrame.size.height = contentHeight;
        self.contentView.frame = contentFrame;
    }
    
    //临时保存滑动视图大小
    scrollViewFrame = self.contentView.frame;
    //临时保存内容的大小
    contentViewFrame = oneSubview.frame;
}



/////给Storyboard创建的VC添加滑动功能
//- (void)addScrollViewForSB:(UIView *)oneSubview withFrame:(CGRect)tempFrame {
//
//    //删除self.view中的所有子视图
//    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//
//
//    //清除页面上的contentView滑动视图，以及上面的子视图
//    if (self.contentView) {
//        [self.contentView removeFromSuperview];
//        self.contentView = nil;
//    }
//    //生成contentView
//    self.contentView = [[UIScrollView alloc] initWithFrame:tempFrame];
//
//    [self.view addSubview:self.contentView];
//    self.contentView.contentSize = self.contentView.bounds.size;
//
//    //添加原来的VC中的self.view中的内容
//    [self.contentView addSubview:oneSubview];
//
//
//    //在viewWillAppear中去判断修改contentView的展示范围
//    CGFloat contentHeight = 0;
//    NSArray * subViews = self.contentView.subviews;
//    for (UIView * view in subViews) {
//        if (CGRectGetMaxY(view.frame) > contentHeight) {
//            contentHeight = CGRectGetMaxY(view.frame);
//        }
//    }
//
//    //笔者项目主要是上下滚动，如视图可能超出视图右侧，也能以同样方式实现其效果
//    if (contentHeight > self.contentView.bounds.size.height) {
//        self.contentView.contentSize = CGSizeMake(self.contentView.bounds.size.width, contentHeight);
//    }
//
//    //修改contentView的背景色
//    self.contentView.backgroundColor = [UIColor colorWithRed:255/255.0f green:10/255.0f blue:10/255.0f alpha:0.5f];
//
//}


////导航栏返回按钮点击事件
//-(void)back {
//
//    //pop返回
//    [self.navigationController popViewControllerAnimated:YES];
//
//}



#pragma mark - 实现text随着键盘移动
- (void)keyboardWillShow:(NSNotification *)notification {
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //当前点击textfield的坐标的Y值 + 当前点击textFiled的高度 - （屏幕高度- 键盘高度 - 键盘上tabbar高度)
    CGFloat offset = 0.0f;
    if (scrollViewFrame.origin.x == 0) {
        offset = (contentViewFrame.origin.y+contentViewFrame.size.height) - (SCREEN_HEIGHT - kbHeight);
    } else {
        offset = (64+contentViewFrame.origin.y+contentViewFrame.size.height) - (SCREEN_HEIGHT - kbHeight);
    }
    
    //取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        
        [UIView animateWithDuration:duration animations:^{
            //改变滑动视图的大小
            //            self.contentView.frame = CGRectMake(scrollViewFrame.origin.x, scrollViewFrame.origin.y, scrollViewFrame.size.width, SCREEN_HEIGHT - 64 - kbHeight);
            
            //            self.contentView.frame = CGRectMake(scrollViewFrame.origin.x, scrollViewFrame.origin.y, scrollViewFrame.size.width, (contentViewFrame.origin.y+contentViewFrame.size.height)-offset);
            
            
            if ([_IstextView isEqualToString:@"1"]) {
                //将滑动视图滚动到底部
                //[self.contentView setContentOffset:CGPointMake(0, offset) animated:YES];
                self.contentView.frame = CGRectMake(scrollViewFrame.origin.x,  -(scrollViewFrame.size.height+kbHeight-SCREEN_HEIGHT-20), scrollViewFrame.size.width,scrollViewFrame.size.height);
                _IstextView=@"0";
            } else {
                self.contentView.frame = CGRectMake(scrollViewFrame.origin.x, scrollViewFrame.origin.y, scrollViewFrame.size.width, (contentViewFrame.origin.y+contentViewFrame.size.height)-offset);
            }
        } completion:^(BOOL finished) {
            //将滑动视图滚动到底部
            //   [self.contentView setContentOffset:CGPointMake(0, offset) animated:YES];
            
            //这里需要根据点击的text来判断上滑的高度
            //            UIView *focusView = [self firstResponderInSubView];
            //            if (focusView == nil) {
            //                //将滑动视图滚动到底部
            //                [self.contentView setContentOffset:CGPointMake(0, offset) animated:YES];
            //            } else {
            //
            //                //计算focusView的坐标
            //                CGRect focusFrame = focusView.frame;
            //                //CGRect focusFrame = focusView.bounds;
            //
            //                CGFloat offsetFocus = 0.0f;
            //                if (scrollViewFrame.origin.x == 0) {
            //                    offsetFocus = (focusFrame.origin.y+focusFrame.size.height) - (SCREEN_HEIGHT - kbHeight);
            //                } else {
            //                    offsetFocus = (64+ focusFrame.origin.y+focusFrame.size.height) - (SCREEN_HEIGHT - kbHeight);
            //                }
            //
            //                if (offsetFocus > 0) {
            //                    [self.contentView setContentOffset:CGPointMake(0, offsetFocus) animated:YES];
            //                }
            //
            //            }
            
        }];
    }
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    //动画时间
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        
        self.contentView.frame = scrollViewFrame;
    }];
    
}
//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}



#pragma mark - 私有方法
//获取焦点所在的textview
- (UIView *)firstResponderInSubView {
    
    for (UIView *subview in self.contentView.subviews) {
        
        if (( [subview isKindOfClass:[UITextView class]])&& subview.isFirstResponder) {//[subview isKindOfClass:[UITextField class]] ||
            return subview;
        }
        
        if ([subview isKindOfClass:[UIView class]])
        {
            for (UIView *moreSubview in subview.subviews) {
                
                if (( [moreSubview isKindOfClass:[UITextView class]]) && moreSubview.isFirstResponder) {//[moreSubview isKindOfClass:[UITextField class]] ||
                    return moreSubview;
                }
            }
        }
    }
    
    return nil;
}



@end
