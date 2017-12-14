//
//  SendIdeaViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SendIdeaViewController.h"
#import "SendIdeaCell.h"

@interface SendIdeaViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
    
    UITableView *_listTableView;
    
    UITextView *messageField;         // 意见文本输入框
    
    UILabel *holderLabel;             // 假的holder
    
    UILabel *tipLabel;                // 提示文本
    
    NSString *tipType;                // 反馈类型：网店追加-0 点子-1 错误信息-2 闪退-3 其他-4
    
    // 反馈类型几个按钮
    UIButton *zhuijiaButton;
    UIButton *dianziButton;
    UIButton *cuowuButton;
    UIButton *shantuiButton;
    UIButton *qitaButton;
    
    
}

@end

@implementation SendIdeaViewController

#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.view.backgroundColor = Background_Color;
    tipType = @"网点追加";
    // 创建视图
    [self creatSubViewsAction];
    
    
    
}


#pragma mark ========================================私有方法=============================================

#pragma mark - 创建视图
- (void)creatSubViewsAction {
    
    // 表视图
    CGFloat startY = 0;
    if (kScreenHeight == 812) {
        startY = 88;    // iPhone X
    } else {
        startY = 64;    // 其他机型
    }
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startY, kScreenWidth, kScreenHeight - startY)
                                                  style:UITableViewStylePlain ];
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView registerNib:[UINib nibWithNibName:@"SendIdeaCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"SendIdeaCell"];
    [self.view addSubview:_listTableView];
    
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)){
        _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#else
    
#endif
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

#pragma mark ========================================动作响应=============================================

#pragma mark - 网点追加
- (void)zhuijiaAction:(UIButton *)button {
    
    tipType = @"网点追加";
    
    zhuijiaButton.backgroundColor = Publie_Color;
    dianziButton.backgroundColor = [UIColor whiteColor];
    cuowuButton.backgroundColor = [UIColor whiteColor];
    shantuiButton.backgroundColor = [UIColor whiteColor];
    qitaButton.backgroundColor = [UIColor whiteColor];
    
    [zhuijiaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dianziButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [cuowuButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [shantuiButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [qitaButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    
    tipLabel.text = @"  网点追加";
    
    
}

#pragma mark - 点子
- (void)ideaAction:(UIButton *)button {
    
    tipType = @"点子";
    
    zhuijiaButton.backgroundColor = [UIColor whiteColor];
    dianziButton.backgroundColor = Publie_Color;
    cuowuButton.backgroundColor = [UIColor whiteColor];
    shantuiButton.backgroundColor = [UIColor whiteColor];
    qitaButton.backgroundColor = [UIColor whiteColor];
    
    [zhuijiaButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [dianziButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cuowuButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [shantuiButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [qitaButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    
    tipLabel.text = @"  点子";
    
}

#pragma mark - 信息错误
- (void)errorAction:(UIButton *)button {
    
    tipType = @"信息错误";
    
    zhuijiaButton.backgroundColor = [UIColor whiteColor];
    dianziButton.backgroundColor = [UIColor whiteColor];
    cuowuButton.backgroundColor = Publie_Color;
    shantuiButton.backgroundColor = [UIColor whiteColor];
    qitaButton.backgroundColor = [UIColor whiteColor];
    
    [zhuijiaButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [dianziButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [cuowuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shantuiButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [qitaButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    
    tipLabel.text = @"  信息错误";
    
}

#pragma mark - 闪退
- (void)shantuiAction:(UIButton *)button {
    
    tipType = @"闪退";
    
    zhuijiaButton.backgroundColor = [UIColor whiteColor];
    zhuijiaButton.backgroundColor = [UIColor whiteColor];
    cuowuButton.backgroundColor = [UIColor whiteColor];
    shantuiButton.backgroundColor = Publie_Color;
    qitaButton.backgroundColor = [UIColor whiteColor];
    
    [zhuijiaButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [dianziButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [cuowuButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [shantuiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qitaButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    
    tipLabel.text = @"  闪退";
    
}

#pragma mark - 其他
- (void)otherButtonAction:(UIButton *)button {
    
    tipType = @"其他";
    
    zhuijiaButton.backgroundColor = [UIColor whiteColor];
    dianziButton.backgroundColor = [UIColor whiteColor];
    cuowuButton.backgroundColor = [UIColor whiteColor];
    shantuiButton.backgroundColor = [UIColor whiteColor];
    qitaButton.backgroundColor = Publie_Color;
    
    [zhuijiaButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [dianziButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [cuowuButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [shantuiButton setTitleColor:Publie_Color forState:UIControlStateNormal];
    [qitaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    tipLabel.text = @"  其他";
    
}

#pragma mark - 提交
- (void)commitButtonAction:(UIButton *)button {
    
    if (tipType == nil) {
        FadeAlertView *showMessage = [[FadeAlertView alloc] init];
        [showMessage showAlertWith:@"请选择反馈类型"];
        return;
    }
    
    if ([messageField.text isEqualToString:@""]) {
        FadeAlertView *showMessage = [[FadeAlertView alloc] init];
        [showMessage showAlertWith:@"请输入反馈意见"];
        return;
    }
    
    
    
    [SOAPUrlSession sendIdeaCode:tipType
                            desc:messageField.text
                         success:^(id responseObject) {
                             
                             NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                             NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                             
                             if (responseCode.integerValue == 0) {
                                 
                                 [self.navigationController popViewControllerAnimated:YES];
                                 
                             }
                             
                             //主线程更新视图
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                 [showMessage showAlertWith:msg];
                                 
                             });
                             
                         } failure:^(NSError *error) {
                             
                             //主线程更新视图
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                 [showMessage showAlertWith:@"请求失败"];
                                 
                             });
                             
                         }];
    
    
}





#pragma mark ========================================网络请求=============================================

#pragma mark ========================================代理方法=============================================

#pragma mark - 表视图代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat startY = 0;
    if (kScreenHeight == 812) {
        startY = 88;    // iPhone X
    } else {
        startY = 64;    // 其他机型
    }
    return kScreenHeight - startY;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SendIdeaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendIdeaCell"
                                                          forIndexPath:indexPath];
    
    messageField = cell.messageField;
    messageField.delegate = self;
    holderLabel = cell.fieldHolderLabel;
    tipLabel = cell.tipLabel;
    
    zhuijiaButton = cell.zhuijiaButton;
    dianziButton = cell.dianziButton;
    cuowuButton = cell.cuowuButton;
    shantuiButton = cell.shantuiButton;
    qitaButton = cell.qitaButton;
    
    
    [cell.zhuijiaButton addTarget:self action:@selector(zhuijiaAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.dianziButton addTarget:self action:@selector(ideaAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.cuowuButton addTarget:self action:@selector(errorAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.shantuiButton addTarget:self action:@selector(shantuiAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.qitaButton addTarget:self action:@selector(otherButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.commitButton addTarget:self action:@selector(commitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}


#pragma mark - 输入框代理方法，控制假的holder是否显示
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    holderLabel.hidden = YES;
    
    return YES;
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        holderLabel.hidden = NO;
    } else {
        holderLabel.hidden = YES;
    }
    
    return YES;
    
}

#pragma mark ========================================通知================================================



@end
