//
//  CALayer+Addition.h
//  YiYanYunGou
//
//  Created by admin on 16/7/21.
//  Copyright © 2016年 admin. All rights reserved.
//

//给CALayer层添加属性UIColor，由于默认的CGColor在RunTime设置时没有对应的属性
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (Addition)

@property(nonatomic, assign) UIColor* borderUIColor;


@end
