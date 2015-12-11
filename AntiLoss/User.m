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

- (instancetype)init{
    if (self=[super init]) {
        self.devicesMac = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isBounded:(NSString *)mac{
    BOOL isBound = NO;
    if (self.devicesMac) {
        for (NSString * deviceMac in self.devicesMac) {
            if ([mac isEqualToString:deviceMac]) {
                isBound = YES;
            }
        }
    }
    return isBound;
}

- (BOOL)unBoundDevice:(NSString*)mac{
    BOOL isUnBound = NO;
    int index = -1;
    int l = (int)self.devicesMac.count;
    if (self.devicesMac) {
        for (int i = 0 ;i<l;i++) {
            if ([mac isEqualToString:self.devicesMac[i]]) {
                isUnBound = YES;
                index = i;
                break;
            }
        }
    }
    if (isUnBound) {
        [self.devicesMac removeObjectAtIndex:index];
    }
    return isUnBound;
}

@end
