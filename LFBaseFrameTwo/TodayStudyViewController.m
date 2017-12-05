//
//  TodayStudyViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/5.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "TodayStudyViewController.h"


@interface TodayStudyViewController () <UIWebViewDelegate> {
    //工具方法单例
    SmallFunctionTool *smallFunc;
    
    UIWebView *webView;
    
}
@end

@implementation TodayStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    smallFunc = [SmallFunctionTool sharedInstance];
    
    
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    webView.scalesPageToFit = YES;//允许缩放
    [self.view addSubview:webView];
    
    //加载网络url
    NSURL *url = [NSURL URLWithString:@"http://47.92.86.242/bidapp_front/todaystu.html"];
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //添加WebView的代理
    webView.delegate = self;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //停止风火轮
    [smallFunc stopActivityIndicator:@"TodayStudyViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - webview代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"开始加载页面");
    //显示风火轮
    [smallFunc createActivityIndicator:self.view AndKey:@"TodayStudyViewController"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"页面加载完毕");
    //停止风火轮
    [smallFunc stopActivityIndicator:@"TodayStudyViewController"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"页面加载失败");
    
    //显示一个加载失败的图片
    FadeAlertView *showMessage = [[FadeAlertView alloc] init];
    [showMessage showAlertWith:@"页面加载失败"];
    [smallFunc stopActivityIndicator:@"TodayStudyViewController"];
    
}



@end
