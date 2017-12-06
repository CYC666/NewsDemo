//
//  LatestDingView.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "LatestDingView.h"
#import "DListCell.h"
#import "DingModel.h"
#import "WebListViewController.h"

@interface LatestDingView () <UITableViewDelegate, UITableViewDataSource>  {
    
    UITableView *_listTableView;
    NSMutableArray *_dataArray;
    
}

@end

@implementation LatestDingView

#pragma mark ========================================生命周期========================================
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self creatSubviewsAction];
        
    }
    return self;
    
    
}

#pragma mark ========================================私有方法=============================================

#pragma mark - 创建子视图
- (void)creatSubviewsAction {
    
    self.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    
    
    CGFloat wid = self.frame.size.width;
    CGFloat hei = self.frame.size.height;
    
    // 标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = Label_Color_C;
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"最新加入";
    [self addSubview:label];
    
    // 箭头
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(wid - 25, 15, 15, 15)];
    imageview.image = [UIImage imageNamed:@"right-1"];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageview];
    
    // 分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 39, wid - 20, 1)];
    line.backgroundColor = Background_Color;
    [self addSubview:line];
    
    // 按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, wid, 30);
    [button addTarget:self action:@selector(hotButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    
    // 表视图
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, wid, hei - 40)
                                                  style:UITableViewStylePlain];
    _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.rowHeight = (hei - 40)*0.25;
    _listTableView.scrollEnabled = NO;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView registerNib:[UINib nibWithNibName:@"DListCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"DListCell"];
    [self addSubview:_listTableView];
    
    [self loadNewTypeAction];
    
}


#pragma mark - 获取最新加入
- (void)loadNewTypeAction {
    
    [SOAPUrlSession hotAneNewWebsType:@"1"
                             cur_page:@"1"
                              success:^(id responseObject) {
                                  
                                  NSString *responseCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                                  
                                  if ([responseCode isEqualToString:@"0"]) {
                                      
                                      [_dataArray removeAllObjects];
                                      NSArray *list = responseObject[@"data"];
                                      
                                      // 封装数据
                                      for (NSInteger i = 0; i < list.count; i++) {
                                          
                                          if (i < 4) {
                                              NSDictionary *dic = list[i];
                                              
                                              DingModel *model = [[DingModel alloc] init];
                                              model.mwsub_id = [NSString stringWithFormat:@"%@", dic[@"subscribe_id"]];
                                              //                                              model.mwsub_mbrid = [NSString stringWithFormat:@"%@", dic[@"mwsub_mbrid"]];
                                              model.mwsub_webid = [NSString stringWithFormat:@"%@", dic[@"webid"]];
                                              model.ws_logo = [NSString stringWithFormat:@"%@", dic[@"ws_logo"]];
                                              model.ws_name = [NSString stringWithFormat:@"%@", dic[@"ws_name"]];
                                              
                                              [_dataArray addObject:model];
                                          }
                                          
                                      }
                                      
                                      
                                  }
                                  
                                  //主线程更新视图
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      [_listTableView reloadData];
                                      
                                  });
                                  
                              } failure:^(NSError *error) {
                                  
                                  //主线程更新视图
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      FadeAlertView *showMessage = [[FadeAlertView alloc] init];
                                      [showMessage showAlertWith:@"请求失败"];
                                      
                                  });
                                  
                              }];
    
}


#pragma mark - 重新刷新数据
- (void)reloadDataWithArray:(NSMutableArray *)dataArray {
    
    _dataArray = dataArray;
    
    [_listTableView reloadData];
    
    
}

#pragma mark - 最新加入跳转
- (void)hotButtonAction:(UIButton *)button {
    
    WebListViewController *ctrl = [[WebListViewController alloc] init];
    ctrl.title = @"最新加入";
    ctrl.websType = @"1";
    [self.superCtrl.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark - 点击了该网站
- (void)selectWebvAction:(UIButton *)button {
    
    DingModel *model = _dataArray[button.tag];
    
    [_cellDelegate LatestDingViewIndexSelect:model];
    
}

#pragma mark - 表视图代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DListCell"
                                                      forIndexPath:indexPath];
    
    if (_dataArray.count == 0) {
        
    } else {
        
        DingModel *model = _dataArray[indexPath.row];
        
        // 图片
        NSString *path = [NSString stringWithFormat:@"%@%@", Java_Image_URL, model.ws_logo];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:path]
                              placeholderImage:[UIImage imageNamed:@"loadfail-0"]
                                       options:SDWebImageRetryFailed];
        
        // 名字
        cell.nameLabel.text = model.ws_name;
        
        if ([model.mwsub_id isEqualToString:@"<null>"] ||
            [model.mwsub_id isEqualToString:@"(null)"] ||
            [model.mwsub_id isEqualToString:@""]) {
            
            // 未订阅
            [cell.dingButton setTitle:@"订阅" forState:UIControlStateNormal];
            [cell.dingButton setTitleColor:Label_Color_B forState:UIControlStateNormal];
            [cell.dingButton setBackgroundColor:Background_Color];
        } else {
            
            [cell.dingButton setTitle:@"已订" forState:UIControlStateNormal];
            [cell.dingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.dingButton setBackgroundColor:Publie_Color];
            
        }
        
        
    }
    
    cell.dingButton.tag = indexPath.row;
    [cell.dingButton addTarget:self action:@selector(selectWebvAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_cellDelegate HotDingViewSelectCell:indexPath.row];
    
}



























@end
