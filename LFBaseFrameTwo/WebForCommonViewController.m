//
//  WebForCommonViewController.m
//  YiYanYunGou
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "WebForCommonViewController.h"

@interface WebForCommonViewController () <UIWebViewDelegate>
{
    //工具方法单例
    SmallFunctionTool *smallFunc;
    
    UIWebView *webView;
    
}
@end

@implementation WebForCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    smallFunc = [SmallFunctionTool sharedInstance];
    
    //设置导航栏标题和按钮
    self.navigationItem.title = _naviTitle;
    
    //导航栏左右按钮
//    UIBarButtonItem *buttonReturn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoReturnPop)];
//    self.navigationItem.leftBarButtonItem = buttonReturn;
    
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    webView.scalesPageToFit = YES;//允许缩放
    [self.view addSubview:webView];
    
    //加载网络url
    NSURL *url;
    if ([_urlString characterAtIndex:0] == 'h') {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", _urlString]];
    } else {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@", _urlString]];
    }
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //添加WebView的代理
    webView.delegate = self;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //停止风火轮
    [smallFunc stopActivityIndicator:@"WebForCommonViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - webview代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"开始加载页面");
    //显示风火轮
    [smallFunc createActivityIndicator:self.view AndKey:@"WebForCommonViewController"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"页面加载完毕");
    //停止风火轮
    [smallFunc stopActivityIndicator:@"WebForCommonViewController"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"页面加载失败");
    
    //显示一个加载失败的图片
    FadeAlertView *showMessage = [[FadeAlertView alloc] init];
    [showMessage showAlertWith:@"页面加载失败"];
    [smallFunc stopActivityIndicator:@"WebForCommonViewController"];
    
}


#pragma mark - 私有方法
//- (void)gotoReturnPop{
//    
//    if (_isPresentBack) {
//        //返回上一页
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        //返回上一页
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    
//
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
