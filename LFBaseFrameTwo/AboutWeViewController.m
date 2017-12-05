//
//  AboutWeViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "AboutWeViewController.h"

@interface AboutWeViewController ()

@end

@implementation AboutWeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于";
    self.view.backgroundColor = Background_Color;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight - 64);
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    UIImage *image = [UIImage imageNamed:@"aboutbg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [scrollView addSubview:imageView];
    
    
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)){
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#else
    
#endif
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
