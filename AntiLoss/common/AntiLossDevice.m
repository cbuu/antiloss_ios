//
//  AntiLossDevice.m
//  AntiLoss
//
//  Created by cbuu on 15/11/30.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "AntiLossDevice.h"

@interface AntiLossDevice()
{
    
}

@end

@implementation AntiLossDevice

+ (instancetype)initWithMac:(NSString*)mac name:(NSString*)name
{
    AntiLossDevice * device = [[AntiLossDevice alloc] init];
    
    device.deviceMac = mac;
    device.deviceName = name;
    
    return device;
}

- (instancetype)initWithDic:(NSDictionary*)dic
{
    if (self = [super init]) {
        if (dic) {
            self.deviceMac = dic[@"deviceMac"];
            self.deviceName = dic[@"deviceName"];
            self.imageID  =  dic[@"image"];
        }
    }
    return self;
}

- (NSString*)toJson
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (_deviceMac&&_deviceMac.length>0) {
        dic[@"deviceMac"] = _deviceMac;
    }
    if (_deviceName&&_deviceName.length>0) {
        dic[@"deviceName"] = _deviceName;
    }
    if (_imageID&&_imageID.length>0) {
        dic[@"image"] = _imageID;
    }
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
