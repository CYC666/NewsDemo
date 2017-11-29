//
//  SmallFunctionTool.m
//  YiYanYunGou
//
//  Created by admin on 16/3/25.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "SmallFunctionTool.h"
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#import "BlockButton.h"


@interface SmallFunctionTool ()
{
//    //风火轮对象
//    UIActivityIndicatorView *activityIndicator;
    
    //包含烽火轮对象的字典，每个视图的名称作为字典的key
    //由于存在Bug，单新视图打开时风火轮被上一个视图的关闭风火轮操作给删除了
    NSMutableDictionary <NSString *,UIActivityIndicatorView *> *activityIndicatorDic;
    
    //包含黑幕的风火轮
    NSMutableDictionary <NSString *,UIView *> *blankScreenViewDic;
    
}
@end

@implementation SmallFunctionTool

//单例方法
static SmallFunctionTool *instance;
+ (SmallFunctionTool *)sharedInstance{
    @synchronized(self) {
        if (!instance) {
            instance = [[SmallFunctionTool alloc]init];
        }
    }
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self) {
        if (!instance) {
            instance = [super allocWithZone:zone];
        }
    }
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        activityIndicatorDic = [NSMutableDictionary dictionary];
        blankScreenViewDic = [NSMutableDictionary dictionary];
        _isShowScrollImageView = YES;
    }
    return self;
}



/*获取设备的IP,需要导入下面头文件
 #import <sys/socket.h>
 #import <sys/sockio.h>
 #import <sys/ioctl.h>
 #import <net/if.h>
 #import <arpa/inet.h>
 */
+ (NSString *)getDeviceIPIpAddresses
{
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) return nil;
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    close(sockfd);
    
    NSString *deviceIP = @"";
    for (int i=0; i < ips.count; i++)
    {
        if (ips.count > 0)
        {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
            
        }
    }
    return deviceIP;
}



//正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber{
    NSString *pattern = @"^1[345678]\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    
    return isMatch;
}

//正则匹配邮箱
+ (BOOL)checkEmailStr:(NSString *)emailStr{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isMatch = [emailTest evaluateWithObject:emailStr];
    
    return isMatch;
}

//正则匹配邮政编码
+ (BOOL)checkZipCodeStr:(NSString *)zipCode{
    NSString *pattern = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:zipCode];
    
    return isMatch;
}


//创建并启动风火轮
- (void)createActivityIndicator:(UIView *)nowView AndKey:(NSString *)className{
    
    //判断当前页面是否有了一个风火轮，有的话先删除老的风火轮再创建一个新的
    //修复风火轮一直不消失的bug
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIActivityIndicatorView *activityIndicatorOld = activityIndicatorDic[className];
        if (activityIndicatorOld != nil) {
            [activityIndicatorOld stopAnimating];
            activityIndicatorOld = nil;
        }
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.2, SCREEN_WIDTH * 0.2)];
        CGRect temp = nowView.frame;
        activityIndicator.center = CGPointMake(nowView.center.x, nowView.center.y - temp.origin.y);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.backgroundColor = [UIColor darkGrayColor];
        activityIndicator.alpha = 0.8f;
        activityIndicator.layer.cornerRadius = 10;
        activityIndicator.layer.masksToBounds = YES;
        
        [nowView.window addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        //把风火轮加入字典中
        [activityIndicatorDic setObject:activityIndicator forKey:className];
    });
    
}
//关闭风火轮
- (void)stopActivityIndicator:(NSString *)className{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //取出对应key的烽火轮
        UIActivityIndicatorView *activityIndicator = activityIndicatorDic[className];
        if (activityIndicator != nil) {
            [activityIndicator stopAnimating];
            activityIndicator = nil;
        }
        
    });
}

//创建并启动风火轮，有部分需要位置偏移
- (void)createActivityIndicator:(UIView *)nowView AndKey:(NSString *)className AndOffset:(CGFloat)offset{
    
    //判断当前页面是否有了一个风火轮，有的话先删除老的风火轮再创建一个新的
    //修复风火轮一直不消失的bug
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIActivityIndicatorView *activityIndicatorOld = activityIndicatorDic[className];
        if (activityIndicatorOld != nil) {
            [activityIndicatorOld stopAnimating];
            activityIndicatorOld = nil;
        }
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.2, SCREEN_WIDTH * 0.2)];
        CGRect temp = nowView.frame;
        activityIndicator.center = CGPointMake(nowView.center.x, nowView.center.y - temp.origin.y);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.backgroundColor = [UIColor darkGrayColor];
        activityIndicator.alpha = 0.8f;
        activityIndicator.layer.cornerRadius = 10;
        activityIndicator.layer.masksToBounds = YES;
        
        //活动视图控制器设置上下偏移
        CGRect tempFrame = activityIndicator.frame;
        tempFrame.origin.y = tempFrame.origin.y - offset;
        activityIndicator.frame = tempFrame;
        
        [nowView.window addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        //把风火轮加入字典中
        [activityIndicatorDic setObject:activityIndicator forKey:className];
    });
    
}


//手机号加密显示
+ (NSString *)lockMobileNumber:(NSString *)mobileNumber{
    
    if (mobileNumber == nil || [mobileNumber isEqualToString:@""]) {
        return @"***";
    } else {
        NSString *firstStr = [mobileNumber substringToIndex:3];
        NSString *secondStr = [mobileNumber substringFromIndex:[mobileNumber length]-4];
        NSString *result = [NSString stringWithFormat:@"%@****%@",firstStr,secondStr];
        
        return result;
    }
}


/*
 * 显示全国省市区县的通用方法，使用本地的Json数据
 */


static NSArray *provinceArray;
///初始化本地省市区类方法
+ (void)initializeAllCityFunction{
    //初始化本地城市数据
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *pathAllCitys=[path stringByAppendingPathComponent:@"AllCitys.json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:pathAllCitys];
    
    NSError *err;
    provinceArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&err];
    if(err) {
        NSLog(@"JSON数据转换成array时出现异常：%@",err);
    }
}


//获取所有省份
+ (NSDictionary *)haveAllProvince {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (NSDictionary *provinceDic in provinceArray) {
        [dic setObject:provinceDic[@"areaName"] forKey:[NSString stringWithFormat:@"%@", provinceDic[@"areaId"]]];
    }
    
    return dic;
}



//获取某个省份的所有市区信息
+ (NSDictionary *)haveAllCity:(NSString *)provinceCode {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (NSDictionary *provinceDic in provinceArray) {
        //查询到对应的省份下的市级数组
        if ([[NSString stringWithFormat:@"%@", provinceDic[@"areaId"]] isEqualToString:provinceCode]) {
            
            //市级数组
            NSArray *cityArray = provinceDic[@"chirldData"];
            for (NSDictionary *cityDic in cityArray) {
                [dic setObject:cityDic[@"areaName"] forKey:[NSString stringWithFormat:@"%@", cityDic[@"areaId"]]];
            }
            
            //遍历到了就跳循环
            break;
        }
    }
    
    return dic;
    
}



//获取某个市区的所有区县的信息
+ (NSDictionary *)haveAllCounty:(NSString *)cityCode {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    //根据数据关系，从市级编号得到省级别编号(前2位不变，替换字符串最后4位为0000)
    NSString *provinceCode = [NSString stringWithFormat:@"%@0000",[cityCode substringWithRange:NSMakeRange(0,2)]];
    
    for (NSDictionary *provinceDic in provinceArray) {
        
        if ([provinceCode isEqualToString:@"110000"]) {
            provinceCode = @"1";
        } else if ([provinceCode isEqualToString:@"120000"]) {
            provinceCode = @"2";
        } else if ([provinceCode isEqualToString:@"310000"]) {
            provinceCode = @"3";
        }
        
        
        //查询到对应的省份下的市级数组
        if ([[NSString stringWithFormat:@"%@", provinceDic[@"areaId"]] isEqualToString:provinceCode]) {
            
            //市级数组
            NSArray *cityArray = provinceDic[@"chirldData"];
            for (NSDictionary *cityDic in cityArray) {
                
                //查询到对应的市级下的区县数组
                if ([[NSString stringWithFormat:@"%@", cityDic[@"areaId"]] isEqualToString:cityCode]) {
                    
                    //区县数组
                    NSArray *countryArray = cityDic[@"chirldData"];
                    for (NSDictionary *countryDic in countryArray) {
                        [dic setObject:countryDic[@"areaName"] forKey:[NSString stringWithFormat:@"%@", countryDic[@"areaId"]]];
                    }
                    
                    //遍历到了就跳循环
                    break;
                }

            }
            
            //遍历到了就跳循环
            break;
        }
    }
    
    return dic;

}


//屏蔽输入的表情字符
+ (NSString *)disable_emoji:(NSString *)text{
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:0 error:nil];
    
    NSString *noEmojiStr = [regularExpression stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
    
    return noEmojiStr;
}


//校验文本输入框的文本字数，两种类型：0--最长16个字，1-最长40个字，2-最长140个字,3-最长10个字
+ (NSString *)checkOutText:(NSString *)textContent byType:(NSString *)type withTextName:(NSString *)textName {
    
    NSString *returnStr = nil;
    if ([textContent isEqualToString:@""] || textContent == nil) {
        returnStr = [NSString stringWithFormat:@"%@不能为空",textName];
    } else {
        if ([type isEqualToString:@"0"]) { //最大长度16，银行名称
            if ([textContent length] > 16 ) {
                returnStr = [NSString stringWithFormat:@"%@过长，请确保字数少于16字！",textName];
            }
        } else if ([type isEqualToString:@"1"]) { //最大长度40，详细地址
            if ([textContent length] > 40 ) {
                returnStr = [NSString stringWithFormat:@"%@过长，请确保字数少于40字！",textName];
            }
        } else if ([type isEqualToString:@"2"]) { //最大长度140，QA问答提出问题
            if ([textContent length] > 140 ) {
                returnStr = [NSString stringWithFormat:@"%@过长，请确保字数少于140字！",textName];
            }
        } else if ([type isEqualToString:@"3"]) { //最大长度10，真实姓名
            if ([textContent length] > 10 ) {
                returnStr = [NSString stringWithFormat:@"%@过长，请确保字数少于10字！",textName];
            }
        } else if ([type isEqualToString:@"4"]) { //最大长度12，昵称、店铺名称
            if ([textContent length] > 12 ) {
                returnStr = [NSString stringWithFormat:@"%@过长，请确保字数少于12字！",textName];
            }
        } else if ([type isEqualToString:@"5"]) { //最大长度25，银行卡号
            if ([textContent length] > 25 ) {
                returnStr = [NSString stringWithFormat:@"%@过长，请确保字数少于25字！",textName];
            }
        } else if ([type isEqualToString:@"6"]) { //最大长度200，QA问答商家回答
            if ([textContent length] > 200 ) {
                returnStr = [NSString stringWithFormat:@"%@过长，请确保字数少于200字！",textName];
            }
        }
    }
    
    return returnStr;
    
}


//校验密码文本输框，必须为6-16位数字组成
+ (NSString *)checkOutPasswordText:(NSString *)textContent withTextName:(NSString *)textName {
    
    NSString *returnStr = nil;
    if ([textContent isEqualToString:@""] || textContent == nil) {
        returnStr = [NSString stringWithFormat:@"%@不能为空",textName];
    } else {
        if ([textContent length] < 6 || [textContent length] >16) {
            returnStr = [NSString stringWithFormat:@"%@长度需在6~16位之间",textName];
        } else {
//            NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"; //数字+字母
            NSString * regex = @"^[0-9A-Za-z]{6,16}$"; //数字或者字母
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if (![pred evaluateWithObject: textContent]) {
                returnStr = [NSString stringWithFormat:@"%@必须包含数字或字母，并且只支持数字和字母！",textName];
            }
        }
    }
    
    return returnStr;
}

//校验密码文本输框，必须为6-16位数字+字母组成
+ (NSString *)checkOutPasswordTexts:(NSString *)textContent withTextName:(NSString *)textName {
    
    NSString *returnStr = nil;
    if ([textContent isEqualToString:@""] || textContent == nil) {
        returnStr = [NSString stringWithFormat:@"%@不能为空",textName];
    } else {
        if ([textContent length] < 6 || [textContent length] >16) {
            returnStr = [NSString stringWithFormat:@"%@长度需在6~16位之间",textName];
        } else {
            NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"; //数字+字母
            //NSString * regex = @"^[0-9A-Za-z]{6,16}$"; //数字或者字母
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if (![pred evaluateWithObject: textContent]) {
                returnStr = [NSString stringWithFormat:@"%@必须包含数字或字母，并且只支持数字和字母！",textName];
            }
        }
    }
    
    return returnStr;
}

//普通按钮设置0.5秒点击一次
+ (void)singleClickButtonRestriction:(id)sender {
    
    if ([sender isMemberOfClass:[UIButton class]]) {
        UIButton *oneButton = sender;
        
        //按钮0.3秒只可以点击1次
        oneButton.enabled = NO;
    
        //延时0.3秒，按钮恢复可点击
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            oneButton.enabled = YES;
        });
    }
    
    if ([sender isMemberOfClass:[UIBarButtonItem class]]) {
        UIBarButtonItem *oneBarButton = sender;
        
        //按钮0.3秒只可以点击1次
        oneBarButton.enabled = NO;
        
        //延时0.3秒，按钮恢复可点击
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            oneBarButton.enabled = YES;
        });
    }
    

}



//保存图片点击放大时的老的坐标
static CGRect oldframe;

///图片点击后放大（uibutton）
+ (void)showBigImage:(UIButton *)buttonHaveImageView{
    
    UIImage *image = buttonHaveImageView.imageView.image;
    
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    //将老图片的坐标系过度到window坐标系
    oldframe = [buttonHaveImageView convertRect:buttonHaveImageView.bounds toView:window];
    
    //设置背景色
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    
    [backgroundView addSubview:imageView];
    
    [window addSubview:backgroundView];
    
    
    //添加隐藏大图的手势操作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBigImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    
    //执行动画
    [UIView animateWithDuration:0.3 animations:^{
         
         imageView.frame = CGRectMake(0,
                                    (SCREEN_HEIGHT - image.size.height*SCREEN_WIDTH/image.size.width)/2,
                                    SCREEN_WIDTH,
                                    image.size.height*SCREEN_WIDTH/image.size.width);
         
         backgroundView.alpha = 1;
         
     } completion:^(BOOL finished) {
         
         
     }];
    
}
//图片点击后放大后再点击后缩小的手势操作
+ (void)hideBigImage:(UITapGestureRecognizer*)tap{
    
    UIView *backgroundView = tap.view;
    
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    
    //执行动画
    [UIView animateWithDuration:0.3 animations:^{
         
         imageView.frame = oldframe;
         backgroundView.alpha=0;
         
     } completion:^(BOOL finished) {
         
         [backgroundView removeFromSuperview];
         
     }];
    
}

//-------------使用图片点击放大操作---------------
//原始尺寸
static CGRect imageOldFrame;
/**
 *  浏览大图
 *
 *  @param currentImageview 图片所在的imageView
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview{
    //当前imageview的图片
    UIImage *image = currentImageview.image;
    //当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    imageOldFrame = [currentImageview convertRect:currentImageview.bounds toView:window];
    
    //设置背景色
    backgroundView.backgroundColor = [UIColor blackColor];
    //此时视图不会显示
    [backgroundView setAlpha:0];
    
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageOldFrame];
    [imageView setImage:image];
    [imageView setTag:1];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //动画放大所展示的ImageView
    
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:1];
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setFrame:imageOldFrame];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}


///无网络弹窗提示
+ (void)showNoNetworkConnectTip:(UIViewController *)showVC {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络提示" message:@"网络不可用，请检测网络连接" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [showVC presentViewController:alert animated:YES completion:nil];

}




///添加黑幕不可点击的风火轮
- (void)createBlankScreenActivityIndicator:(UIView *)nowView AndKey:(NSString *)className AndOffset:(CGFloat)offset {
    
    //判断当前页面是否有了一个风火轮，有的话先删除老的风火轮再创建一个新的
    //修复风火轮一直不消失的bug
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //添加黑幕
        NSString *blankScreenStr = [NSString stringWithFormat:@"BS%@",className];
        UIView *blankScreenViewOld = blankScreenViewDic[blankScreenStr];
        if (blankScreenViewOld != nil) {
            [blankScreenViewOld removeFromSuperview];
            blankScreenViewOld = nil;
        }
        
        UIView *blankScreenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        blankScreenView.backgroundColor = [UIColor darkGrayColor];
        blankScreenView.alpha = 0.6f;
        [nowView.window addSubview:blankScreenView];
        
        //把黑幕view加入字典中
        [blankScreenViewDic setObject:blankScreenView forKey:blankScreenStr];
        
        
        //        NSString *blankScreenStr = [NSString stringWithFormat:@"BS%@",className];
        UIActivityIndicatorView *activityIndicatorOld = activityIndicatorDic[blankScreenStr];
        if (activityIndicatorOld != nil) {
            [activityIndicatorOld stopAnimating];
            activityIndicatorOld = nil;
        }
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.2, SCREEN_WIDTH * 0.2)];
        CGRect temp = nowView.frame;
        activityIndicator.center = CGPointMake(nowView.center.x, nowView.center.y - temp.origin.y);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.backgroundColor = [UIColor darkGrayColor];
        activityIndicator.alpha = 0.8f;
        activityIndicator.layer.cornerRadius = 10;
        activityIndicator.layer.masksToBounds = YES;
        
        //活动视图控制器设置上下偏移
        CGRect tempFrame = activityIndicator.frame;
        tempFrame.origin.y = tempFrame.origin.y - offset;
        activityIndicator.frame = tempFrame;
        
        [nowView.window addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        //把风火轮加入字典中
        [activityIndicatorDic setObject:activityIndicator forKey:blankScreenStr];
    });
    
}

///关闭风火轮
- (void)stopBlankScreenActivityIndicator:(NSString *)className {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //取出对应key的烽火轮
        NSString *blankScreenStr = [NSString stringWithFormat:@"BS%@",className];
        UIActivityIndicatorView *activityIndicator = activityIndicatorDic[blankScreenStr];
        if (activityIndicator != nil) {
            [activityIndicator stopAnimating];
            activityIndicator = nil;
        }
        
        //取出对应的黑幕清空了
        UIView *blankScreenView = blankScreenViewDic[blankScreenStr];
        if (blankScreenView != nil) {
            [blankScreenView removeFromSuperview];
            blankScreenView = nil;
        }
        
    });
    
}





//昵称统一显示10位，中间两位是**
+ (NSString *)lockNickNameString:(NSString *)nickName {
    
    if (nickName.length > 10) {
        NSString *firstStr = [nickName substringToIndex:4];
        NSString *secondStr = [nickName substringFromIndex:[nickName length]-4];
        NSString *result = [NSString stringWithFormat:@"%@**%@",firstStr,secondStr];
        
        return result;
    } else {
        return nickName;
    }
    
}

//根据身份证判断性别
+ (NSString *)lockIdString:(NSString *)nickName {
    
    if (nickName.length ==18) {
      
        int  b= [[nickName substringWithRange:NSMakeRange(16,1)] intValue];
        if (b%2==0) {
            return @"女";
        }else{
            return @"男";
        }
        
    }else{
        return @"男";
    }
    
}

+ (UIToolbar *)addHideKeyboardButton:(UIViewController *)target {
    
    //给文本框添加弹出键盘时的隐藏按钮
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [topView setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    BlockButton *btn = [BlockButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    //    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //使用block添加点击事件
    [btn addTapBlock:^(UIButton *button) {
        //收起键盘，0.3秒动画时间
        [UIView animateWithDuration:0.3 animations:^{
            [target.view endEditing:YES];
        }];
    }];
    
    [btn setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    
    return topView;
}


///正则匹配邀请码（这里先设置成手机号）
+ (BOOL)checkInvitationCodeStr:(NSString *)invitationCode {
    return [self checkTelNumber:invitationCode];
}



//验证身份证
//必须满足以下规则
//1. 长度必须是18位，前17位必须是数字，第十八位可以是数字或X
//2. 前两位必须是以下情形中的一种：11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91
//3. 第7到第14位出生年月日。第7到第10位为出生年份；11到12位表示月份，范围为01-12；13到14位为合法的日期
//4. 第17位表示性别，双数表示女，单数表示男
//5. 第18位为前17位的校验位
//算法如下：
//（1）校验和 = (n1 + n11) * 7 + (n2 + n12) * 9 + (n3 + n13) * 10 + (n4 + n14) * 5 + (n5 + n15) * 8 + (n6 + n16) * 4 + (n7 + n17) * 2 + n8 + n9 * 6 + n10 * 3，其中n数值，表示第几位的数字
//（2）余数 ＝ 校验和 % 11
//（3）如果余数为0，校验位应为1，余数为1到10校验位应为字符串“0X98765432”(不包括分号)的第余数位的值（比如余数等于3，校验位应为9）
//6. 出生年份的前两位必须是19或20
+ (BOOL)verifyIDCardNumber:(NSString *)value{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
    
}




///将当前时间转成string
+ (NSString *)transitionDateToString:(NSDate *)oneDate {
    
    //时间格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:Time_Format];
    if (oneDate) {
        NSString *dateString=[dateFormatter stringFromDate:oneDate];
        return dateString;
    } else {
        return nil;
    }

}

///比较string类型的时间和当前时间的差值(返回秒)
+ (long)timeDifferenceForNow:(NSString *)dateString {

    //时间格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:Time_Format];
    NSDate *recordTime = [dateFormatter dateFromString:dateString]; //string转成时间类型
    NSDate *timeNow = [NSDate date]; //当前时间
    long deviation = (long)[timeNow timeIntervalSince1970] - [recordTime timeIntervalSince1970]; //差值，秒
    
    return deviation;
}

//银行卡号加密显示
+ (NSString *)lockBankNumber:(NSString *)mobileNumber{
    
    //    NSString *str;
    //    str=@"";
    //
    //    {
    //    for (int i ;i<[mobileNumber length]-4;i++) {
    //
    //        str=[str stringByAppendingString:@"*"];
    //    }
    //    }
    //    NSString *result= [NSString stringWithFormat:@"%@%@",str,secondStr];
    //    return result;
    
    NSString *secondStr = [mobileNumber substringFromIndex:[mobileNumber length]-4];
    // NSString *result = [NSString stringWithFormat:@"**** **** **** **** %@",secondStr];
    
    return secondStr;
}


//将超大的金额改成万，不足够的正常显示，保存3位小数
+ (NSString *)changeBigNumber:(NSString *)bigNumber {
    
    CGFloat oneNum = [bigNumber floatValue];
    
    if (oneNum >= 10000.0) {
        //显示多少万
        CGFloat twoNum = oneNum / 10000.0;
        NSString *twoStr = [NSString stringWithFormat:@"%0.3f万",twoNum];
        return twoStr;
    } else {
        //正常显示
        NSString *twoStr = [NSString stringWithFormat:@"%0.3f",oneNum];
        return twoStr;
    }
    
}

//将超大的金额改成万，不足够的正常显示，保存2位小数
+ (NSString *)changeBigNumberTwo:(NSString *)bigNumber {
    
    CGFloat oneNum = [bigNumber floatValue];
    
    if (oneNum >= 10000.0) {
        //显示多少万
        CGFloat twoNum = oneNum / 10000.0;
        NSString *twoStr = [NSString stringWithFormat:@"%0.2f万",twoNum];
        return twoStr;
    } else {
        //正常显示
        NSString *twoStr = [NSString stringWithFormat:@"%0.2f",oneNum];
        return twoStr;
    }
    
}

//将超大的金额改成万，不足够的正常显示，保存0位小数
+ (NSString *)changeBigNumberZero:(NSString *)bigNumber {
    
    CGFloat oneNum = [bigNumber floatValue];
    
    if (oneNum >= 10000.0) {
        //显示多少万
        CGFloat twoNum = oneNum / 10000.0;
        NSString *twoStr = [NSString stringWithFormat:@"%.0f万",twoNum];
        return twoStr;
    } else {
        //正常显示
        NSString *twoStr = [NSString stringWithFormat:@"%.0f",oneNum];
        return twoStr;
    }
    
}

//将超大的积分改成万，不足够的正常显示，保存3位小数
+ (NSString *)changeBigNumberIntegral:(NSString *)bigNumber {
    
    CGFloat oneNum = [bigNumber floatValue];
    
    if (oneNum >= 10000.0) {
        //显示多少万
        CGFloat twoNum = oneNum / 10000.0;
        NSString *twoStr = [NSString stringWithFormat:@"%0.3f万",twoNum];
        return twoStr;
    } else {
        //正常显示
        NSString *twoStr = [NSString stringWithFormat:@"%0.0f",oneNum];
        return twoStr;
    }
    
}

///清除7天记录的登录状态
+ (void)clearAwayLoginState {
    
    //获取当前时间
    NSString *nowTime = nil;
    //加密userId
    NSString *encryptStr = nil;
    
    //存入NSUserDefaults文件中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nowTime forKey:@"LoginDate"];
    [userDefaults setObject:encryptStr forKey:@"LoginUserId"];
    [userDefaults synchronize]; //立即同步

}


///创建某一种颜色的背景图片
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
