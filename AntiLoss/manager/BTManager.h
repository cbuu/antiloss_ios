//
//  BTManager.h
//  AntiLoss
//
//  Created by cbuu on 15/11/24.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AntiLossDevice.h"

@protocol BTManagerDelegate <NSObject>

@optional
- (void)deviceFound:(AntiLossDevice*)device;
- (void)deviceConnectResult:(BOOL)isSuccess;
- (void)deviceDisconnectResult:(BOOL)isSuccess;
@end

@interface BTManager : NSObject

@property (nonatomic,weak) id<BTManagerDelegate> managerDelegate;
@property (nonatomic,assign) BOOL isConnect;

+ (instancetype)getInstance;

- (void)setUp;
- (BOOL)getBTState;
- (void)scan;
- (void)stopScan;

- (void)connect:(AntiLossDevice*)device;
- (void)disconnectAllDevices;

- (void)makeSound:(AntiLossDevice*)device;
@end
