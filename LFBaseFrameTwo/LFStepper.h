//
//  LFStepper.h
//  YiYanYunGou
//
//  Created by admin on 16/5/17.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFStepper;
// 数值改变时的回调方法
typedef void (^LFStepperValueChangedCallback)(LFStepper *stepper, float newValue);

// 数值增加时的回调方法
typedef void (^LFStepperIncrementedCallback)(LFStepper *stepper, float newValue);

// 数值减少时的回调方法
typedef void (^LFStepperDecrementedCallback)(LFStepper *stepper, float newValue);

IB_DESIGNABLE
@interface LFStepper : UIControl
@property(nonatomic, strong) UITextField *countText;
@property(nonatomic, strong) UIColor *labelColor;
@property(nonatomic, strong) UIButton *incrementButton;
@property(nonatomic, strong) UIButton *decrementButton;

@property(nonatomic) float value; // default: 0.0
@property(nonatomic) float stepInterval; // default: 1.0
@property(nonatomic) float minimum; // default: 0.0
@property(nonatomic) float maximum; // default: 100.0
@property(nonatomic) BOOL hidesDecrementWhenMinimum; // default: NO
@property(nonatomic) BOOL hidesIncrementWhenMaximum; // default: NO
@property(nonatomic) CGFloat buttonWidth; // default: 44.0f

@property(nonatomic, copy) LFStepperValueChangedCallback valueChangedCallback;
@property(nonatomic, copy) LFStepperIncrementedCallback incrementCallback;
@property(nonatomic, copy) LFStepperDecrementedCallback decrementCallback;

// call this method after setting value(s) and callback(s)
// This method will call callback
- (void)setup;

// view customization
- (void)setBorderColor:(UIColor *)color;
- (void)setBorderWidth:(CGFloat)width;
- (void)setCornerRadius:(CGFloat)radius;

- (void)setLabelTextColor:(UIColor *)color;
- (void)setLabelFont:(UIFont *)font;

- (void)setButtonTextColor:(UIColor *)color forState:(UIControlState)state;
- (void)setButtonFont:(UIFont *)font;



//添加两个属性，用来存改变前的商品数量和商品的id
@property(nonatomic) NSInteger beforeGoodsNum; //改变前的商品数量
@property(nonatomic) NSString *projectIdForStepper; //商品的id


@end
