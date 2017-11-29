//
//  BusinessScope.h
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/24.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessScope : NSObject

//主键编号
@property (nonatomic) NSString *ItemDetailId;
//中文名称
@property (nonatomic) NSString *ItemName;
//关键字
@property (nonatomic) NSString *ItemValue;
//描述
@property (nonatomic) NSString *Description;


///初始化
- (instancetype)initWithItemDetailId:(NSString *)ItemDetailId
                            ItemName:(NSString *)ItemName
                           ItemValue:(NSString *)ItemValue
                         Description:(NSString *)Description;

@end
