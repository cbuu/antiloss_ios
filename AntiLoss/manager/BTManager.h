//
//  BTManager.h
//  AntiLoss
//
//  Created by cbuu on 15/11/24.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AntiLossDevice.h"

@protocol BTSearchDeviceDelegate <NSObject>

@optional
- (void)deviceFound:(AntiLossDevice*)device;

@end

@interface BTManager : NSObject

@property (nonatomic,assign) id<BTSearchDeviceDelegate> searchDeviceDelegate;


+ (instancetype)getInstance;

- (void)setUp;
- (BOOL)getBTState;
- (void)scan;
- (void)stopScan;

@end
