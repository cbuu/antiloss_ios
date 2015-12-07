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

@end
