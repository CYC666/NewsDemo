//
//  AboutWeViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "AboutWeViewController.h"
#import "ProtocolView.h"

@interface AboutWeViewController () {
    
    ProtocolView *proView;
    
}

@end

@implementation AboutWeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于";
    self.view.backgroundColor = Background_Color;
    
    CGFloat startY = 0;
    if (kScreenHeight == 812) {
        startY = 88;    // iPhone X
    } else {
        startY = 64;    // 其他机型
    }
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, startY, kScreenWidth, kScreenHeight - startY)];
    scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight - startY);
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    UIImage *image = [UIImage imageNamed:@"aboutbg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-startY)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [scrollView addSubview:imageView];
    
    UIButton *proButton = [UIButton buttonWithType:UIButtonTypeCustom];
    proButton.frame = CGRectMake(0, kScreenHeight - 200, kScreenWidth, 60);
    [proButton setTitle:@"《用户服务协议》" forState:UIControlStateNormal];
    proButton.titleLabel.font = [UIFont systemFontOfSize:13];
    proButton.titleLabel.textColor = [UIColor whiteColor];
    [proButton addTarget:self action:@selector(proButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:proButton];
    
    
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)){
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#else
    
#endif
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}


#pragma mark - 查看协议
- (void)proButtonAction:(UIButton *)button {
    
    if (proView == nil) {
        proView = [ProtocolView viewFromXIB];
        proView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        [[UIApplication sharedApplication].keyWindow addSubview:proView];
        [proView.sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        proView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
    }];
    
}

- (void)sureButtonAction:(UIButton *)button {
    
    [UIView animateWithDuration:0.35 animations:^{
        proView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    
    
}





































@end
