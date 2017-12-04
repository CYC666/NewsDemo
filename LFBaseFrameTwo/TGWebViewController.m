//
//  TGWebViewController.m
//  TGWebViewController
//
//  Created by 赵群涛 on 2017/9/15.
//  Copyright © 2017年 QR. All rights reserved.
//

#import "TGWebViewController.h"
#import "TGWebProgressLayer.h"
#import "LoginViewController.h"
#import <WebKit/WebKit.h>


@interface TGWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong)WKWebView *tgWebView;

@property (strong, nonatomic) UIButton *rightItem;

@property (nonatomic, strong)TGWebProgressLayer *webProgressLayer;


@end

@implementation TGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.webTitle;
    [self setUpUI];
}

- (void)setUpUI {
    
    
    // 导航栏右边的添加按钮
    _rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightItem setImage:[UIImage imageNamed:@"ZG添加"]  forState:UIControlStateNormal];
    [_rightItem setTintColor:[UIColor whiteColor]];
    _rightItem.frame = CGRectMake(0, 0, 20, 20);
    _rightItem.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    _rightItem.contentMode = UIViewContentModeScaleAspectFit;
    [_rightItem addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_rightItem];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    

    if (_megmt_id == 0){
          [_rightItem setImage:[UIImage imageNamed:@"uncollect_s"] forState:UIControlStateNormal];
    }else{
        [_rightItem setImage:[UIImage imageNamed:@"collect_s"] forState:UIControlStateNormal];
    }
  
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]
                                          initWithTitle:@"返回"
                                          style:UIBarButtonItemStyleDone
                                          target:self
                                          action:@selector(leftButtonAction)];
    leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    

//    self.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    self.tgWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    self.tgWebView.navigationDelegate =self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.tgWebView loadRequest:request];
    [self.view addSubview:self.tgWebView];
    

    
    
    self.webProgressLayer = [[TGWebProgressLayer alloc] init];
    self.webProgressLayer.frame = CGRectMake(0, 42, WIDTH, 2);
    self.webProgressLayer.strokeColor = self.progressColor.CGColor;
    [self.navigationController.navigationBar.layer addSublayer:self.webProgressLayer];
}
- (void)leftButtonAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButton:(UIButton *)btn {
//    [self.navigationController popViewControllerAnimated:YES];
//    [self.webProgressLayer removeFromSuperlayer];
    if (_megmt_id == 0) {
        [btn setImage:[UIImage imageNamed:@"collect_s"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"uncollect_s"] forState:UIControlStateNormal];
    }
    [self collectButtonAction];
}



#pragma mark - 收藏
- (void)collectButtonAction {
    
    
    
    
    NSString *favorite;
    
    
    if (_megmt_id == 0) {
        
        // 执行收藏
        favorite = @"0";
        
    } else {
        
        // 取消收藏
        favorite = @"1";
    }
    
    [SOAPUrlSession collectActionWithMegmt_id:[NSString stringWithFormat:@"%ld", _megmt_id]
                                  megmt_artid:_artid
                                  mwsub_webid:_webid
                                     favorite:favorite
                                      success:^(id responseObject) {
                                          
                                          NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                                          NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                                          
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                          if ([responseCode isEqualToString:@"0"]) {
                                              
                                              NSString *iconflg = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"iconflg"]];
                                              
                                              if (iconflg.integerValue == 0) {
                                                  
                                                  // 取消成功
                                                  _megmt_id = 0;
                                                  
                                              } else {
                                                  
                                                  // 收藏成功
                                                  NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"resultid"]];
                                                  _megmt_id = str.integerValue;
                                              }
                                              
                                          } else if ([msg isEqualToString:@"此操作必须登录"]) {
                                              
                                              //主线程更新视图
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  
                                                  
                                                  // 跳转登录页面
                                                  LoginViewController *ctrl = [[LoginViewController alloc] init];
                                                  [self.navigationController pushViewController:ctrl animated:YES];
                                                  
                                              });
                                              
                                          }
                                          
                                          //主线程更新视图
                                              if (_megmt_id == 0){
                                                  [_rightItem setImage:[UIImage imageNamed:@"uncollect_s"] forState:UIControlStateNormal];
                                              }else{
                                                  [_rightItem setImage:[UIImage imageNamed:@"collect_s"] forState:UIControlStateNormal];
                                              }

                                              
                                          });
                                          
                                          
                                      } failure:^(NSError *error) {
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                              [showMessage showAlertWith:@"请求失败"];
                                              
                                          });
                                          
                                      }];
    
    
    
    
}


#pragma mark - UIWebViewDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.webProgressLayer tg_startLoad];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webProgressLayer tg_finishedLoadWithError:nil];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.webProgressLayer tg_finishedLoadWithError:error];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)dealloc {
    [self.webProgressLayer tg_closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}




@end
