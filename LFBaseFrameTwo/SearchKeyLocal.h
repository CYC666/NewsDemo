//
//  SearchKeyLocal.h
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 admin. All rights reserved.
//

/*!
 * 本地数据库中保存的用户搜索的关键字
 */

#import <Foundation/Foundation.h>

@interface SearchKeyLocal : NSObject

@property (nonatomic) NSString *time; //时间
@property (nonatomic) NSString *searchStr; //搜索的String


- (instancetype)initWithTime:(NSString *)time searchStr:(NSString *)searchStr;


@end
