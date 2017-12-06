//
//  ProtocolView.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/12/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ProtocolView.h"

@implementation ProtocolView

//简单封装了创建xib的方法
+ (instancetype)viewFromXIB {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"ProtocolView" owner:nil options:nil] firstObject];
    
}

@end
