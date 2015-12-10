//
//  WXApiManager.m
//  AntiLoss
//
//  Created by cbuu on 15/11/20.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "WXApiManager.h"
#import "Utils.h"
#import "UserManager.h"

@implementation OpenCache

@end

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

- (BOOL)sendMessageWithTitle:(NSString*)title device:(AntiLossDevice*)device deviceImage:(UIImage*)image andDesciption:(NSString*)description{
    UIImage * thumbImage = nil;
    if (image) {
        thumbImage = [Utils getThumbImage:image size:CGSizeMake(50.0f, 50.0f)];
    }else{
        thumbImage = [Utils getThumbImage:[UIImage imageNamed:@"Icon-40.png"] size:CGSizeMake(50.0f, 50.0f)];
    }
    
    WXAppExtendObject * obj = [WXAppExtendObject object];
    obj.extInfo = device.deviceMac;
    //obj.fileData = UIImageJPEGRepresentation(thumbImage, 1.0);
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.mediaObject = obj;
    message.description = description;
    message.messageExt = device.deviceName;
    
    [message setThumbImage:thumbImage];
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
    req.message = message;
    req.scene = WXSceneSession;
    req.bText = NO;
    
    return [WXApi sendReq:req];
}


@end
