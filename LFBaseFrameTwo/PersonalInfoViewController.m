//
//  PersonalInfoViewController.m
//  LFBaseFrameTwo
//
//  Created by 曹奕程 on 2017/11/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonalInfoCell.h"
#import "LoginViewController.h"
#import "SelectSexView.h"
#import "PGDatePicker.h"


@interface PersonalInfoViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SelectSexViewDlegate, PGDatePickerDelegate> {
    
    UITableView *_listTableView;
    
    UIButton *leaveButton;          // 退出登录
    
    UserInformation *userInfo;      // 用户信息单例
    
    SmallFunctionTool *smallFunc;   // 工具方法单例
    
    BOOL isShowLogin;               // 是否提示过一次登录
    
    SelectSexView *selectSexView;   // 选择性别
    
}

@end

@implementation PersonalInfoViewController

#pragma mark ========================================生命周期========================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人设置";
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化
    userInfo = [UserInformation sharedInstance];
    smallFunc = [SmallFunctionTool sharedInstance];
    isShowLogin = NO;
    
    // 创建视图
    [self creatSubViewsAction];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 获取个人信息
    [self loadPersonalInfoAction];
    
    
}


#pragma mark ========================================私有方法=============================================

#pragma mark - 创建视图
- (void)creatSubViewsAction {
    
    // 表视图
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)
                                                  style:UITableViewStylePlain ];
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView registerNib:[UINib nibWithNibName:@"PersonalInfoCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"PersonalInfoCell"];
    [self.view addSubview:_listTableView];
    
#ifdef __IPHONE_11_0
    if(@available(iOS 11.0, *)){
        _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#else
    
#endif
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    // 退出登录
    leaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leaveButton.frame = CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50);
    [leaveButton setTitle:@"退出登录" forState:UIControlStateNormal];
    leaveButton.backgroundColor = CRGB(144, 7, 20, 1);
    leaveButton.titleLabel.textColor = [UIColor whiteColor];
    leaveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leaveButton addTarget:self action:@selector(leaveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leaveButton];
    
}


#pragma mark - 获取个人信息
- (void)loadPersonalInfoAction {
    
    [SOAPUrlSession loadPersonalDetialInfoActionSuccess:^(id responseObject) {
    
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
        
        if (responseCode.integerValue == 0) {
            
            NSArray *list = responseObject[@"data"];
            NSDictionary *dic = list.firstObject;
            
            // 保存个人信息
            userInfo.member_birth = [NSString stringWithFormat:@"%@", dic[@"member_birth"]];
            userInfo.member_email = [NSString stringWithFormat:@"%@", dic[@"member_email"]];
            userInfo.member_gender = [NSString stringWithFormat:@"%@", dic[@"member_gender"]];
            userInfo.member_id = [NSString stringWithFormat:@"%@", dic[@"member_id"]];
            userInfo.member_img = [NSString stringWithFormat:@"%@", dic[@"member_img"]];
            userInfo.member_mobile = [NSString stringWithFormat:@"%@", dic[@"member_mobile"]];
            userInfo.member_nickname = [NSString stringWithFormat:@"%@", dic[@"member_nickname"]];
            
            //主线程更新视图
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_listTableView reloadData];
                
            });
            
        } else if ([msg isEqualToString:@"此操作必须登录"]) {
            
            //主线程更新视图
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (isShowLogin == NO) {
                    
                    isShowLogin = YES;
                    
                    // 清除数据
                    [userInfo clearData];

                    
                    // 跳转登录页面
                    LoginViewController *ctrl = [[LoginViewController alloc] init];
                    [self.navigationController pushViewController:ctrl animated:YES];
                    
                } else {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
                

            });

        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                [showMessage showAlertWith:[NSString stringWithFormat:@"%@", responseObject[@"msg"]]];
                
            });
            
        }
        
    } failure:^(NSError *error) {
        
        //主线程更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            
            FadeAlertView *showMessage = [[FadeAlertView alloc] init];
            [showMessage showAlertWith:@"请求失败"];
            
        });
        
    }];
    
    
}



#pragma mark ========================================动作响应=============================================

#pragma mark - 点击头像，弹出相机或照片选取
- (void)headButtonAction:(UIButton *)button {
    
    //弹出动作表单
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //添加动作表单列表按钮
    UIAlertAction *photoButton = [UIAlertAction actionWithTitle:@"手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开手机相册
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.delegate = self;
        pickerController.allowsEditing = YES;
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //显示相册选择器picker
        [self presentViewController:pickerController animated:YES completion:nil];
        
    }];
    [alert addAction:photoButton];
    UIAlertAction *cameraButton = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.delegate = self;
        pickerController.allowsEditing = YES;
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerController animated:YES completion:nil];
        
    }];
    [alert addAction:cameraButton];
    
    
    //添加取消按钮
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelButton];
    
    //使用runtime属性，修改默认的系统提示窗的字体(只支持8.4以上版本)
    CGFloat iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (iOSVersion >=8.4) {
        [photoButton setValue:Publie_Color forKey:@"_titleTextColor"];
        [cameraButton setValue:Publie_Color forKey:@"_titleTextColor"];
        [cancelButton setValue:[UIColor darkGrayColor] forKey:@"_titleTextColor"];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - 修改昵称
- (void)nickFieldAction:(UITextField *)field {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if ([field.text isEqualToString:@""] || [field.text isEqualToString:userInfo.member_nickname]) {
        field.text = userInfo.member_nickname;
        return;
    }
    
    // 更新个人资料
    [self changeInfoActionWithMbr_img:userInfo.member_img
                         mbr_nickname:field.text
                           mbr_mobile:userInfo.member_mobile
                           mbr_gender:userInfo.member_gender
                            mbr_birth:userInfo.member_birth
                            mbr_email:userInfo.member_email];
    
}

#pragma mark - 修改手机号
- (void)phoneFieldAction:(UITextField *)field {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (![SmallFunctionTool checkTelNumber:field.text]) {
        
        FadeAlertView *showMessage = [[FadeAlertView alloc] init];
        [showMessage showAlertWith:@"请输入正确的手机号"];
        field.text = userInfo.member_mobile;
        return;
        
    }
    
    if ([field.text isEqualToString:userInfo.member_mobile]) {
        return;
    }
    
    // 更新个人资料
    [self changeInfoActionWithMbr_img:userInfo.member_img
                         mbr_nickname:userInfo.member_nickname
                           mbr_mobile:field.text
                           mbr_gender:userInfo.member_gender
                            mbr_birth:userInfo.member_birth
                            mbr_email:userInfo.member_email];
    
}

#pragma mark - 修改生日
- (void)birthButtonAction:(UIButton *)button {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.delegate = self;
    [datePicker show];
    datePicker.isHiddenMiddleText = false;
    datePicker.middleTextColor = Publie_Color;          // 年月日颜色
    datePicker.confirmButtonTextColor = Publie_Color;   // 确定按钮颜色
    datePicker.textColorOfSelectedRow = Publie_Color;   // 选中日期的颜色
    datePicker.lineBackgroundColor = Publie_Color;      // 线条颜色
    datePicker.datePickerMode = PGDatePickerModeDate;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [dateFormatter dateFromString:userInfo.member_birth];
    [datePicker setDate:date animated:true];
    
    
}

#pragma mark - 修改邮箱
- (void)EmalFieldAction:(UITextField *)field {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if ([field.text isEqualToString:@""] || [field.text isEqualToString:userInfo.member_email]) {
        
        // 不修改
        PersonalInfoCell *cell =  [_listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.EmalField.text = userInfo.member_email;
        return;
    } else {
        
        // 更新个人资料
        [self changeInfoActionWithMbr_img:userInfo.member_img
                             mbr_nickname:userInfo.member_nickname
                               mbr_mobile:userInfo.member_mobile
                               mbr_gender:userInfo.member_gender
                                mbr_birth:userInfo.member_birth
                                mbr_email:field.text];
        
    }
    
    
    
}

#pragma mark - 选择性别
- (void)sexButtonAction:(UIButton *)button {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    selectSexView = [SelectSexView viewFromXIB];
    selectSexView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
    selectSexView.delegate = self;
    selectSexView.sexString = [userInfo.member_gender isEqualToString:@"0"] ? @"女" : @"男";
    [[UIApplication sharedApplication].keyWindow addSubview:selectSexView];
    
    [UIView animateWithDuration:0.2 animations:^{
        selectSexView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
    }];
    
    
}



#pragma mark - 退出登录
- (void)leaveButtonAction {
    
    //显示风火轮
    [smallFunc createActivityIndicator:self.view AndKey:@"PersonalInfoViewController"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //停止风火轮
        [smallFunc stopActivityIndicator:@"PersonalInfoViewController"];
        
        [userInfo clearData];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    });
    
    
    
}


#pragma mark ========================================网络请求=============================================

#pragma mark - 上传头像
- (void)uploadHeadImageAction:(UIImage *)image {
    
    [SOAPUrlSession upLoadImageActionWitImage:image success:^(id responseObject) {
        
        NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
        
        if (responseCode.integerValue == 0) {
            
            // 上传成功
            NSString *imageUrl = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"img_name"]];
            
            
            // 更新个人资料
            [self changeInfoActionWithMbr_img:imageUrl
                                 mbr_nickname:userInfo.member_nickname
                                   mbr_mobile:userInfo.member_mobile
                                   mbr_gender:userInfo.member_gender
                                    mbr_birth:userInfo.member_birth
                                    mbr_email:userInfo.member_email];
            
            
        } else {
            
            //主线程更新视图
            dispatch_async(dispatch_get_main_queue(), ^{
                
                FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                [showMessage showAlertWith:msg];
                
            });
            
            
        }
        
    } failure:^(NSError *error) {
        
        //主线程更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            
            FadeAlertView *showMessage = [[FadeAlertView alloc] init];
            [showMessage showAlertWith:@"请求失败"];
            
        });
        
    }];
    
    
    
}


#pragma mark - 更新个人资料
- (void)changeInfoActionWithMbr_img:(NSString *)member_img
                       mbr_nickname:(NSString *)mbr_nickname
                         mbr_mobile:(NSString *)mbr_mobile
                         mbr_gender:(NSString *)mbr_gender
                          mbr_birth:(NSString *)mbr_birth
                          mbr_email:(NSString *)mbr_email{
    
    [SOAPUrlSession changePersonalInfoMbr_img:member_img
                                 mbr_nickname:mbr_nickname
                                   mbr_mobile:mbr_mobile
                                   mbr_gender:mbr_gender
                                    mbr_birth:mbr_birth
                                    mbr_email:mbr_email
                                      success:^(id responseObject) {
                                          
                                          NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                                          
                                          NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                                          
                                          if (responseCode.integerValue == 0) {
                                              
                                              [self loadPersonalInfoAction];
                                              
                                              
                                          } else {
                                              
                                              //主线程更新视图
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                                  [showMessage showAlertWith:msg];
                                                  
                                              });
                                              
                                          }
                                          
                                      } failure:^(NSError *error) {
                                          
                                          
                                          
                                      }];
    
}


#pragma mark ========================================代理方法=============================================

#pragma mark - 表视图代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kScreenHeight - 64;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInfoCell"
                                                         forIndexPath:indexPath];
    
    // 图片
    NSString *path = [NSString stringWithFormat:@"%@%@", Java_Head_Image_URL, userInfo.member_img];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:path]
                          placeholderImage:[UIImage imageNamed:@"noLogin"]
                                   options:SDWebImageRetryFailed];
    
    [cell.headButton addTarget:self action:@selector(headButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 昵称
    cell.nickField.text = userInfo.member_nickname;
    [cell.nickField addTarget:self action:@selector(nickFieldAction:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // 手机号码
    cell.phoneField.text = userInfo.member_mobile;
    [cell.phoneField addTarget:self action:@selector(phoneFieldAction:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // 性别
    cell.sexLabel.text = userInfo.member_gender.integerValue == 1 ? @"男" : @"女";
    [cell.sexButton addTarget:self action:@selector(sexButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 生日
    cell.birthLabel.text = userInfo.member_birth;
    [cell.birthButton addTarget:self action:@selector(birthButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 邮箱
    cell.EmalField.text = userInfo.member_email;
    [cell.EmalField addTarget:self action:@selector(EmalFieldAction:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

#pragma mark - 相册获取结束
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //退出相册
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
//    PersonalInfoCell *cell =  [_listTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    cell.headImageView.image = image;

    // 前往上传头像
    [self uploadHeadImageAction:image];
    
    
}
//相册获取取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 选择了性别
- (void)SelectSexView:(NSString *)sex {
    
    [UIView animateWithDuration:0.2 animations:^{
        selectSexView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [selectSexView removeFromSuperview];
        selectSexView = nil;
        
        NSString *gender;
        if ([sex isEqualToString:@"女"]) {
            gender = @"0";
        } else {
            gender = @"1";
        }
        
        // 如果性别没有改变，name不执行操作
        if ([gender isEqualToString:userInfo.member_gender]) {
            return ;
        } else {
            
            // 更新个人资料
            [self changeInfoActionWithMbr_img:userInfo.member_img
                                 mbr_nickname:userInfo.member_nickname
                                   mbr_mobile:userInfo.member_mobile
                                   mbr_gender:gender
                                    mbr_birth:userInfo.member_birth
                                    mbr_email:userInfo.member_email];
        }
        
        
        
    }];
    
    
    
}

#pragma mark - 退出选择性别
- (void)viewDismiss:(SelectSexView *)selectView {
    
    [UIView animateWithDuration:0.2 animations:^{
        selectSexView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [selectSexView removeFromSuperview];
        selectSexView = nil;
    }];
    
    
}

#pragma mark - 选取了日期
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    NSArray *array = [userInfo.member_birth componentsSeparatedByString:@"-"];
    NSString *year = array[0];
    NSString *month = array[1];
    NSString *day = array[2];
    
    
    // 如果日期一样，不执行操作
    if (dateComponents.year == year.integerValue && dateComponents.month == month.integerValue && dateComponents.day == day.integerValue) {
        return;
    } else {
        
        NSString *birth = [NSString stringWithFormat:@"%ld-%ld-%ld", dateComponents.year, dateComponents.month, dateComponents.day];
        // 更新个人资料
        [self changeInfoActionWithMbr_img:userInfo.member_img
                             mbr_nickname:userInfo.member_nickname
                               mbr_mobile:userInfo.member_mobile
                               mbr_gender:userInfo.member_gender
                                mbr_birth:birth
                                mbr_email:userInfo.member_email];
    }
    
    
    
    
}


#pragma mark ========================================通知================================================



@end
