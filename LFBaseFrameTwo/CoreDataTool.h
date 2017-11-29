//
//  CoreDataTool.h
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchKeyLocal.h"

@interface CoreDataTool : NSObject

/*
 * 下面的属性是程序中直接使用了的对象，
 * 数据库不论如何操作都会将结果回写到下面的属性中，
 * 以便在程序中使用单例方便的调用
 */

//云购搜索列表中的数据
@property (nonatomic) NSMutableArray <SearchKeyLocal *> *searchKeyLists;



//单例模式
+ (CoreDataTool *)sharedInstance;



//读取SearchKeyLocal表中的数据
- (void)readSearchKeyLocalData;
//写入SearchKeyLocal表中的数据
- (void)writeSearchKeyLocalData:(SearchKeyLocal *)newSearchKeyLocal;
//删除SearchKeyLocal表中的数据，根据“searchStr”字段
- (void)deleteSearchKeyLocalData:(NSString *)deleteKey;
//清空SearchKeyLocal表中的数据
- (void)clearSearchKeyLocalData;



@end
