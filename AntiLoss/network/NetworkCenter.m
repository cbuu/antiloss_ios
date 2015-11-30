//
//  networkCenter.m
//  AntiLoss
//
//  Created by cbuu on 15/11/19.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "networkCenter.h"
#import <BmobSDK/Bmob.h>
#import <AFNetworking.h>

@interface NetworkCenter()
{
    
}

@end

@implementation NetworkCenter

+ (instancetype)getInstance
{
    static dispatch_once_t network_onceToken;
    static NetworkCenter *instance;
    dispatch_once(&network_onceToken, ^{
        instance = [[NetworkCenter alloc] init];
    });
    return instance;
}


- (void)login:(NSString*)username password:(NSString*)password
{
    
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress * l;
    
    
    [BmobUser loginWithUsernameInBackground:username password:password block:^(BmobUser *user, NSError *error) {
        if (error == nil) {
            [self.loginDelegate loginResult:TRUE];
        }else{
            [self.loginDelegate loginResult:FALSE];
        }
        
    }];
}


- (void)signUp:(NSString*)username password:(NSString*)password
{
    BmobUser *bUser = [[BmobUser alloc] init];
    bUser.username = username;
    [bUser setPassword:password];
    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        [self.signUpDelegate signUpResult:isSuccessful];
    }];
}

@end
