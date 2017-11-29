//
//  TGWebViewController.m
//  TGWebViewController
//
//  Created by 赵群涛 on 2017/9/15.
//  Copyright © 2017年 QR. All rights reserved.
//

#import "TGWebViewController.h"
#import "TGWebProgressLayer.h"
#import <WebKit/WebKit.h>


@interface TGWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong)WKWebView *tgWebView;

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
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 24, 24);
    rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    rightBtn.contentMode = UIViewContentModeScaleToFill;
//    rightBtn.contentMode = UIViewContentModeCenter;
    if (_megmt_id == 0){
          [rightBtn setImage:[UIImage imageNamed:@"uncollect_s.png"] forState:UIControlStateNormal];
    }else{
        [rightBtn setImage:[UIImage imageNamed:@"collect_s.png"] forState:UIControlStateNormal];
    }
  
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [rightBtn addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]
                                          initWithTitle:@"返回"
                                          style:UIBarButtonItemStyleDone
                                          target:self
                                          action:@selector(leftButtonAction)];
    leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    

//    self.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    self.tgWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
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
        [btn setImage:[UIImage imageNamed:@"collect_s.png"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"uncollect_s.png"] forState:UIControlStateNormal];
    }
    [self addtoFavorite];
}

- (void)addtoFavorite
{
    /* Configure session, choose between:
     * defaultSessionConfiguration
     * ephemeralSessionConfiguration
     * backgroundSessionConfigurationWithIdentifier:
     And set session-wide properties, such as: HTTPAdditionalHeaders,
     HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
     */
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     My API (POST http://47.92.86.242/bidapp/Api/index.php/Engagements/addToFavorite)
     */
    
    NSURL* URL = [NSURL URLWithString:@"http://47.92.86.242/bidapp/Api/index.php/Engagements/addToFavorite"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    // Headers
    NSLog(@"param,webid%@,artid%@,megmt_id%ld",_webid,_artid,(long)_megmt_id);
    [request addValue:_visitor forHTTPHeaderField:@"VISITOR"];
    [request addValue:_token forHTTPHeaderField:@"TKID"];
    
    // Form URL-Encoded Body
    NSDictionary* bodyParameters = @{
                                     @"megmt_webid": _webid,
                                     @"megmt_artid": _artid,
                                     };
    if (_megmt_id == 0) {
        bodyParameters = @{
                             @"megmt_webid": _webid,
                             @"megmt_artid": _artid,
                             @"favorite": @"0",
                             };
    }else{
        NSString *favid = [NSString stringWithFormat:@"%ld",_megmt_id];
        bodyParameters = @{
                           @"megmt_id": favid,
                           @"favorite": @"1",
                           };
    }
    
    request.HTTPBody = [NSStringFromQueryParameters(bodyParameters) dataUsingEncoding:NSUTF8StringEncoding];
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
           
            printf("收藏/取消收藏成功 web页");
            
        }
        else {
            // Failure
             printf("收藏/取消收藏失败 web页");
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            
        }
    }];
    [task resume];
    [session finishTasksAndInvalidate];
}

/*
 * Utils: Add this section before your class implementation
 */

/**
 This creates a new query parameters string from the given NSDictionary. For
 example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
 string will be @"day=Tuesday&month=January".
 @param queryParameters The input dictionary.
 @return The created parameters string.
 */
static NSString* NSStringFromQueryParameters(NSDictionary* queryParameters)
{
    NSMutableArray* parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
                          [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
                          ];
        [parts addObject:part];
    }];
    return [parts componentsJoinedByString: @"&"];
}

/**
 Creates a new URL by adding the given query parameters.
 @param URL The input URL.
 @param queryParameters The query parameter dictionary to add.
 @return A new NSURL.
 */
static NSURL* NSURLByAppendingQueryParameters(NSURL* URL, NSDictionary* queryParameters)
{
    NSString* URLString = [NSString stringWithFormat:@"%@?%@",
                           [URL absoluteString],
                           NSStringFromQueryParameters(queryParameters)
                           ];
    return [NSURL URLWithString:URLString];
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
