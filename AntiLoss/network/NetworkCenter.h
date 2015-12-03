//
//  NetworkCenter.h
//  AntiLoss
//
//  Created by cbuu on 15/11/19.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginDelegate <NSObject>

@optional
- (void)loginResult:(BOOL)isSuccess withData:(NSDictionary*)data;

@end


@protocol SignUpDelegate <NSObject>

@optional
- (void)signUpResult:(BOOL)isSuccess;

@end

@protocol GetDevicesInfoDelegate <NSObject>

- (void)getDevicesInfo:(NSDictionary*)infos;

@end

@interface NetworkCenter : NSObject

@property (nonatomic,assign) id<LoginDelegate> loginDelegate;
@property (nonatomic,assign) id<SignUpDelegate> signUpDelegate;
@property (nonatomic,assign) id<GetDevicesInfoDelegate> getDevicesInfoDelegate;

+ (instancetype)getInstance;

- (void)login:(NSString*)username password:(NSString*)password;
- (void)signUp:(NSString*)username password:(NSString*)password;


- (void)startToGetDevicesInfo:(NSArray*)devicesMac;

@end
