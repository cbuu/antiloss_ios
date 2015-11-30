//
//  BTManager.h
//  AntiLoss
//
//  Created by cbuu on 15/11/24.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTSearchDeviceDelegate <NSObject>

@optional
- (void)deviceFound:(NSString*)mac;

@end

@interface BTManager : NSObject

@property (nonatomic,assign) id<BTSearchDeviceDelegate> searchDeviceDelegate;


+ (instancetype)getInstance;

- (void)setUp;
- (BOOL)getBTState;
- (void)scan;

@end
