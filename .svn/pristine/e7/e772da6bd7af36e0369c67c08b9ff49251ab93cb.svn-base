//
//  UIButton+addproty.h
//  YiYanYunGou
//
//  Created by admin on 16/4/14.
//  Copyright © 2016年 admin. All rights reserved.
//




#import <UIKit/UIKit.h>

@interface UIButton (addproty)

/*
 * 有些按钮需要保存相应的id值，
 * 由于后台的id都是NSString，无法使用tag保存，
 * 所以需要添加一条属性
 */
@property(nonatomic, copy)NSString *relatedID;

/*
 * 有些按钮需要保存在列表中的NSIndexPath值，
 * 所以需要添加一条属性indexPathBut
 */
@property(nonatomic, copy)NSIndexPath *indexPathBut;

/*
 * 有些按钮需要保存相应的商品的单份价格值，
 * 所以需要添加一条属性
 */
@property(nonatomic, copy)NSString *unitPrice;


/*
 * 港汇城商品详情属性选择界面，属性父类index
 */
@property(nonatomic, copy)NSString *indexForParents;

/*
 * 港汇城商品详情属性选择界面，属性当前分类的index
 */
@property(nonatomic, copy)NSString *indexForNow;

/*
 * 港汇城订单需要添加一条不同状态的属性，
 */
@property(nonatomic, copy)NSString *orderState;





@end
