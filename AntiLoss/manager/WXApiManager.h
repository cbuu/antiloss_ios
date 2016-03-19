//
//  WXApiManager.h
//  AntiLoss
//
//  Created by cbuu on 15/11/20.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "AntiLossDevice.h"

@interface OpenCache : NSObject

@property (nonatomic,copy) NSString * deviceMac;
@property (nonatomic,copy) NSString * imageID;
@property (nonatomic,copy) NSString * deviceName;
@property (nonatomic,copy) NSString * username;
@property (nonatomic,copy) NSString * teleNum;

@end

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

@end

@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;
@property (nonatomic, strong) OpenCache* cache;

+ (instancetype)sharedManager;

- (BOOL)sendMessageWithTitle:(NSString*)title device:(AntiLossDevice*)device deviceImage:(UIImage*)image Desciption:(NSString*)description andData:(NSData*)data;

@end

