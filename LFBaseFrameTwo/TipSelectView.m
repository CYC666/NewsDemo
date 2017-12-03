//
//  TipSelectView.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "TipSelectView.h"

@interface TipSelectView () <UIPickerViewDelegate, UIPickerViewDataSource>  {
    
    NSString *tipString;
    
}

@end

@implementation TipSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self creatSubViewsAction];
        
    }
    return self;
    
    
}

#pragma mark - 创建子视图
- (void)creatSubViewsAction {
    
    tipString = @"文章";
    _tipArray = @[@"文章", @"专栏"];
    self.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wid, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wid, 0.5)];
    line.backgroundColor = Label_Color_C;
    [self addSubview:line];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(wid - 50, 0, 50, 40);
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:finishButton];
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, wid, hei - 40)];
    picker.delegate = self;
    picker.dataSource = self;
    [self addSubview:picker];
    
    UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(-1, 40 + (hei - 40 - 30)*0.5, wid + 2, 30)];
    rectView.userInteractionEnabled = NO;
    rectView.backgroundColor = [UIColor clearColor];
    rectView.layer.borderColor = Label_Color_C.CGColor;
    rectView.layer.borderWidth = 0.5;
    [self addSubview:rectView];
    
}

#pragma mark - 点击完成
- (void)finishButtonAction:(UIButton *)button {
    
    [_delegate TipSelectViewIndexChange:tipString];
    
}


#pragma mark ========================================picker代理方法=============================================
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
    
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _tipArray.count;
    
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (_tipArray.count == 0) {
        return @"空";
    } else {
        return _tipArray[row];
    }
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (_tipArray.count == 0) {
        return;
    }
    tipString = _tipArray[row];
    
    
}






























@end
