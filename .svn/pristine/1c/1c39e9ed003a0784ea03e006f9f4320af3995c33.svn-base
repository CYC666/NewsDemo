//
//  LocationServiceClass.m
//  LFBaseFrameTwo
//
//  Created by admin on 17/1/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "LocationServiceClass.h"

@interface LocationServiceClass () <CLLocationManagerDelegate>
{
    //定位服务类，获取当前位置的
    CLLocationManager *locationManager;
    
    
}
@end

@implementation LocationServiceClass

//单例方法
static LocationServiceClass *instance;
+ (LocationServiceClass *)sharedInstance{
    @synchronized(self) {
        if (!instance) {
            instance = [[LocationServiceClass alloc]init];
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
        _latitudeStr = nil; //当前经度
        _longitudeStr = nil; //当前维度
        _currentCity = nil; //当前城市
        _cityName = nil;
    }
    return self;
}



///开始获取本地坐标，获取成功就更新对应的值，获取失败则都赋值@“0”
- (void)locateCurrentMap {

    //判断定位功能是否开启
    if ([CLLocationManager locationServicesEnabled]) {
    
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
        
        //设置寻址精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest; //定位精确度（越精确就越耗电）
        locationManager.distanceFilter = 20.0; //每隔多少米定位一次
        
        //开始定位服务
        [locationManager startUpdatingLocation];
        
    } else {
        //info.plist没有添加允许
        NSLog(@"未在info.plist中加入属性:\nNSLocationAlwaysUsageDescription\nNSLocationWhenInUseUsageDescription");
    
    }

}


#pragma mark - CoreLocation delegate (定位失败)
//定位失败则执行此代理方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    //定位失败，这里直接设置值为@“0”；
    _latitudeStr = @"0";
    _longitudeStr = @"0";
    
    NSLog(@"定位当前手机位置失败，可能手机没有打开对应定位服务");
    
}
#pragma mark - CoreLocation delegate (定位成功)
//定位成功则执行此代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    
    //停止继续运行定位功能
    [locationManager stopUpdatingLocation];
    
    //取最接近的定位值
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    //获取经纬度
    _latitudeStr = [NSString stringWithFormat:@"%.6f",currentLocation.coordinate.latitude];
    _longitudeStr = [NSString stringWithFormat:@"%.6f",currentLocation.coordinate.longitude];
    NSLog(@"当前定位的经纬度：%@--%@",_latitudeStr,_longitudeStr);
    
    //获取经纬度对应的中文城市名称
    //地理反编码--可以根据地理坐标（经、纬度）确定位置信息（街道、门牌等）
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error || placemarks.count == 0) {
           // NSLog(@"没有找到任何地址，定位失败！");
            _currentCity = @"无法定位当前位置信息";
            _cityName = @"定位失败";
        } else {
            //获取最近的一组地址信息
            CLPlacemark *placeMark = placemarks[0];
            
            //获取完整地址信息
            _currentCity = placeMark.name;
            _cityName = placeMark.locality;
            
            
            //打印其他可能用到的字段
            NSLog(@"当前国家---%@",placeMark.country); //当前国家
            NSLog(@"当前城市---%@",placeMark.locality); //当前城市
            NSLog(@"当前区域---%@",placeMark.subLocality); //当前区域
            NSLog(@"当前街道---%@",placeMark.thoroughfare); //当前街道
            NSLog(@"具体地址---%@",placeMark.name); //具体地址
            
            
            // 根据城市名

        }
        
    }];
    
}




//地理编码，根据中文地址获取对应的经纬度
- (void)changeAddressToGeocode:(NSString *)addressStr completionHandler:(void (^)(NSString *longitudeChange,NSString *latitudeChange))addressInfo {

    CLGeocoder *geocoder1 = [[CLGeocoder alloc] init];
    [geocoder1 geocodeAddressString:addressStr completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error || placemarks.count == 0) {
            NSLog(@"你输入的地址找不到，定位失败！");
            //经纬度设置成@“0”，传给外层方法
            if (addressInfo) {
                addressInfo(@"0",@"0");
            }
        } else { // 编码成功（找到了具体的位置信息）
            // 输出查询到的所有地标信息
            for (CLPlacemark *placemark in placemarks) {
                // 名字, 城市，国家，邮政编码
                NSLog(@"name=%@ locality=%@ country=%@ postalCode=%@", placemark.name, placemark.locality, placemark.country, placemark.postalCode);
            }
            
            // 显示最前面的地标信息
            CLPlacemark *firstPlacemark = [placemarks firstObject];
            NSLog(@"查询到的第一个地址：%@",firstPlacemark.name);
            // 纬度
            CLLocationDegrees latitude = firstPlacemark.location.coordinate.latitude;
            NSString *latitudeStr = [NSString stringWithFormat:@"%.6f", latitude];
            NSLog(@"查询到对应的维度：%@",latitudeStr);
            // 经度
            CLLocationDegrees longitude = firstPlacemark.location.coordinate.longitude;
            NSString *longitudeStr = [NSString stringWithFormat:@"%.6f", longitude];
            NSLog(@"查询到对应的经度：%@",longitudeStr);
            
            
            //设置经纬度，传给外层方法
            if (addressInfo) {
                addressInfo(longitudeStr,latitudeStr);
            }
            
        }
        
    }];

}



@end
