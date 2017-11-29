//
//  YLChineseString.h
//  TheAddressBookDemo
//
//  Created by YangLei on 16/3/15.
//  Copyright © 2016年 YangLei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLPinYin.h"
@class CityModel;


@interface YLChineseString : NSObject

//下面三个变量是一一对应的
@property (strong,nonatomic) NSString *string; //姓名
@property (strong,nonatomic) NSString *pinYin; //姓名的拼音
@property (strong,nonatomic) CityModel *onePerson; //姓名对应的对象


//-----  返回tableview右方indexArray
+ (NSMutableArray*)IndexArray:(NSArray*)stringArr;

//-----  返回联系人
+ (NSMutableArray*)LetterSortArray:(NSArray*)stringArr withPersonnelArray:(NSArray <CityModel *> *)PersonnelArr;


///----------------------
//返回一组字母排序数组(中英混排)
+ (NSMutableArray*)SortArray:(NSArray*)stringArr;


@end
