//
//  User.m
//  AntiLoss
//
//  Created by cbuu on 15/12/2.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "User.h"
#import "AntiLossDevice.h"

@implementation User

- (BOOL)isBounded:(NSString *)mac{
    if (self.devices) {
        for (AntiLossDevice * device in self.devices) {
            if ([mac isEqualToString:device.deviceMac]) {
                return YES;
            }
        }
    }
    return NO;
}

@end
