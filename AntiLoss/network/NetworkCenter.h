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

@protocol GetDevicesInfoDelegate <NSObject>

- (void)getDevicesInfo:(NSArray*)infos;

@end

@protocol BoundDeviceDelegate <NSObject>

- (void)boundDeviceResult:(BOOL)isSuccees;

@end

@protocol UnBoundDeviceDelegate <NSObject>

- (void)unBoundDeviceResult:(BOOL)isSuccees;

@end

@interface NetworkCenter : NSObject

@property (nonatomic,weak) id<LoginDelegate> loginDelegate;
@property (nonatomic,weak) id<SignUpDelegate> signUpDelegate;
@property (nonatomic,weak) id<GetDevicesInfoDelegate> getDevicesInfoDelegate;
@property (nonatomic,weak) id<BoundDeviceDelegate> boundDeviceDelegate;
@property (nonatomic,weak) id<UnBoundDeviceDelegate> unBoundDeviceDelegate;

@property (nonatomic,strong) ImageLoader* imageLoader;

+ (instancetype)getInstance;

- (void)login:(NSString*)username password:(NSString*)password;
- (void)signUp:(NSString*)username password:(NSString*)password;


- (void)batchGetDevicesInfo:(NSArray*)devicesMac;

- (void)boundDeviceWithMac:(NSString *)mac;
- (void)unBoundDeviceWithMac:(NSString*)mac;

- (void)uploadDeviceInfoWithMac:(NSString*)mac deviceName:(NSString*)name andImage:(UIImage*)image;



@end
