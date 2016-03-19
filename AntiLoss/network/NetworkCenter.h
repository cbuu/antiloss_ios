//
//  NetworkCenter.h
//  AntiLoss
//
//  Created by cbuu on 15/11/19.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageLoader.h"

@protocol LoginDelegate <NSObject>

@optional
- (void)loginResult:(BOOL)isSuccess withData:(NSDictionary*)data;

@end


@protocol SignUpDelegate <NSObject>

@optional
- (void)signUpResult:(BOOL)isSuccess username:(NSString*)username;

@end

@protocol SaveUserInfoDelegate <NSObject>

@optional
- (void)saveUserInfoResult:(BOOL)isSuccess;

@end

@protocol GetDevicesInfoDelegate <NSObject>

- (void)getDevicesInfo:(NSArray*)infos;

@end

@protocol IsDeviceRegisteredDelegate <NSObject>

@optional
- (void)isRegistered:(BOOL)isRegistered;

@end

@protocol BoundDeviceDelegate <NSObject>

- (void)boundDeviceResult:(BOOL)isSuccees;

@end

@protocol UnBoundDeviceDelegate <NSObject>

- (void)unBoundDeviceResult:(BOOL)isSuccees;

@end

@protocol UpdateDeviceDelegate <NSObject>

- (void) updateDeviceResult:(BOOL)isSuccees;

@end

@interface NetworkCenter : NSObject

@property (nonatomic,weak) id<LoginDelegate> loginDelegate;
@property (nonatomic,weak) id<SignUpDelegate> signUpDelegate;
@property (nonatomic,weak) id<GetDevicesInfoDelegate> getDevicesInfoDelegate;
@property (nonatomic,weak) id<IsDeviceRegisteredDelegate> isDeviceRegisteredDelegate;
@property (nonatomic,weak) id<BoundDeviceDelegate> boundDeviceDelegate;
@property (nonatomic,weak) id<UnBoundDeviceDelegate> unBoundDeviceDelegate;
@property (nonatomic,weak) id<UpdateDeviceDelegate> updateDeviceDelegate;
@property (nonatomic,weak) id<SaveUserInfoDelegate> saveUserInfoDelegate;

@property (nonatomic,strong) ImageLoader* imageLoader;

+ (instancetype)getInstance;

- (void)login:(NSString*)username password:(NSString*)password;
- (void)signUp:(NSString*)username password:(NSString*)password;
- (void)saveUserInfo;

- (void)batchGetDevicesInfo:(NSArray*)devicesMac;
- (void)isDeviceRegistered:(NSString*)mac;

- (void)boundDeviceWithMac:(NSString *)mac;
- (void)unBoundDeviceWithMac:(NSString*)mac;

- (void)uploadDeviceInfoWithMac:(NSString*)mac deviceName:(NSString*)name andImagePath:(NSString*)imagePath;



@end
