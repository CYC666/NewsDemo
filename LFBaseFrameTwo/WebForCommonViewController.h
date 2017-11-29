//
//  WebForCommonViewController.h
//  YiYanYunGou
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebForCommonViewController : UIViewController

//H5页面的路径
@property (nonatomic) NSString *urlString;

//视图控制器的导航栏标题
@property (nonatomic) NSString *naviTitle;

//是否是present的
@property (nonatomic) BOOL isPresentBack;



@end
