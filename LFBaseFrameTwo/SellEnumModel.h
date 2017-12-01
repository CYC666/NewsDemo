//
//  SellEnumModel.h
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/9/25.
//  Copyright © 2017年 admin. All rights reserved.
//

// 特卖商品类型模型

#import <Foundation/Foundation.h>

@interface SellEnumModel : NSObject

@property (nonatomic, copy) NSString *TypeId;
@property (nonatomic, copy) NSString *TypeName;
@property (nonatomic, copy) NSString *SortCode;


@property (assign, nonatomic) BOOL isSelect;        // 是否选中




@end
