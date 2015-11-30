//
//  AntiLossDevice.h
//  AntiLoss
//
//  Created by cbuu on 15/11/30.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AntiLossDevice : NSObject

@property NSString * deviceMac;
@property NSString * deviceName;
@property UIImage  * image;

@property NSString * imageID;


+ (instancetype)initWithMac:(NSString*)mac name:(NSString*)name;

@end
