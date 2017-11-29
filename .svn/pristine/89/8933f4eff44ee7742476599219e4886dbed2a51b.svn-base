//
//  LocationServiceClass.h
//  LFBaseFrameTwo
//
//  Created by admin on 17/1/3.
//  Copyright © 2017年 admin. All rights reserved.
//

/*
 * 定位服务类：
 * 使用系统的CoreLocation实现本机定位，以及地理位置的转码
 *
 */


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationServiceClass : NSObject 

//----------------- 本地定位需要返回的信息 -----------------
@property (nonatomic) NSString *latitudeStr; //当前经度
@property (nonatomic) NSString *longitudeStr; //当前维度
@property (nonatomic) NSString *currentCity; //当前城市

@property (copy, nonatomic) NSString *cityName; // 深圳市


///单例模式
+ (LocationServiceClass *)sharedInstance;


///开始获取本地坐标，获取成功就更新对应的值，获取失败则都赋值@“0”
- (void)locateCurrentMap;

///地理编码，根据中文地址获取对应的经纬度
- (void)changeAddressToGeocode:(NSString *)addressStr completionHandler:(void (^)(NSString *longitudeChange,NSString *latitudeChange))addressInfo;

@end
