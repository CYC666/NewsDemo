//
//  HotDingView.m
//  LFBaseFrameTwo
//
//  Created by 曹老师 on 2017/12/1.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "HotDingView.h"
#import "DListCell.h"
#import "DingModel.h"
#import "WebListViewController.h"

@interface HotDingView () <UITableViewDelegate, UITableViewDataSource>  {
    
    UITableView *_listTableView;
    NSMutableArray *_dataArray;
    
}

@end

@implementation HotDingView

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
    label.text = @"热门推荐";
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
    _listTableView.rowHeight = 50;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView registerNib:[UINib nibWithNibName:@"DListCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"DListCell"];
    [self addSubview:_listTableView];

    
    
}

#pragma mark - 重新刷新数据
- (void)reloadDataWithArray:(NSMutableArray *)dataArray {
    
    _dataArray = dataArray;
    
    [_listTableView reloadData];
    
    
}

#pragma mark - 热门推荐跳转
- (void)hotButtonAction:(UIButton *)button {
    
    WebListViewController *ctrl = [[WebListViewController alloc] init];
    ctrl.title = @"热门推荐";
    [self.superCtrl.navigationController pushViewController:ctrl animated:YES];
    
}


#pragma mark - 点击了该网站
- (void)selectWebvAction:(UIButton *)button {
    
    [_cellDelegate HotDingViewIndexSelect:button.tag];
    
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
    
}






































@end
