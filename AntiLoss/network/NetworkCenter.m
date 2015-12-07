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
#import "UserManager.h"
#import "JSONParseUtil.h"

//#define NETWORK_PATH @"http://120.25.71.34:3000/"
#define NETWORK_PATH @"http://localhost:3000/"

@interface NetworkCenter()
{
    AFURLSessionManager * manager;
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


- (instancetype)init
{
    if (self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return self;
}

- (void)login:(NSString*)username password:(NSString*)password
{
    
    NSString * queryStr = [NSString stringWithFormat:@"?username=%@&password=%@",username,password];
    
    NSString * loginPath = [NETWORK_PATH stringByAppendingPathComponent:@"login"];
    
    NSString * urlStr = [loginPath stringByAppendingString:queryStr];
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request addValue:@"yes" forHTTPHeaderField:@"ismobile"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [self.loginDelegate loginResult:FALSE withData:nil];
        } else {
            BOOL isSuccess = [responseObject[@"isSuccess"] boolValue];
            [self.loginDelegate loginResult:isSuccess withData:responseObject[@"user"]];
        }
    }];
    
    [dataTask resume];
}


- (void)signUp:(NSString*)username password:(NSString*)password
{
    
    NSString * registerPath = [NETWORK_PATH stringByAppendingPathComponent:@"register"];
    
    NSURL *URL = [NSURL URLWithString:registerPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    NSData * data = [NSJSONSerialization dataWithJSONObject:@{@"username":username
                                                              ,@"password":password} options:0 error:nil];
    
    request.HTTPBody = data;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            
        } else {
            BOOL isSuccess = [responseObject[@"isSuccess"] boolValue];
            if (self.signUpDelegate) {
                [self.signUpDelegate signUpResult:isSuccess];
            }
        }
    }];
    
    [dataTask resume];
    
    
//    BmobUser *bUser = [[BmobUser alloc] init];
//    bUser.username = username;
//    [bUser setPassword:password];
//    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
//        [self.signUpDelegate signUpResult:isSuccessful];
//    }];
}


- (void)batchGetDevicesInfo:(NSArray *)devicesMac{
    NSString * getInfoPath = [NETWORK_PATH stringByAppendingPathComponent:@"batchGetDevicesInfo"];
    
    NSURL *URL = [NSURL URLWithString:getInfoPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    NSData * data = [JSONParseUtil devicesMacToJSON:devicesMac];
    
    request.HTTPBody = data;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if (self.getDevicesInfoDelegate) {
                [self.getDevicesInfoDelegate getDevicesInfo:nil];
            }
        } else {
            if (self.getDevicesInfoDelegate) {
                [self.getDevicesInfoDelegate getDevicesInfo:responseObject[@"devices"]];
            }
        }
    }];
    
    [dataTask resume];

}


- (void)boundDeviceWithMac:(NSString *)mac
{
    if (mac&&mac.length>0) {
        NSString * boundPath = [NETWORK_PATH stringByAppendingPathComponent:@"boundDevice"];
        
        NSURL *URL = [NSURL URLWithString:boundPath];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        request.HTTPMethod = @"PUT";
        
        User * user = [UserManager getInstance].user;
        NSString * username = user.username;
        
        NSDictionary * dic = @{@"username":username,@"deviceMac":mac};
        
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        
        request.HTTPBody = data;
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (self.boundDeviceDelegate) {
                if (error) {
                    [self.boundDeviceDelegate boundDeviceResult:false];
                }else{
                    [self.boundDeviceDelegate boundDeviceResult: [responseObject[@"isSuccess"] boolValue]];
                }
            }
            
        }];
        
        [dataTask resume];

    }
}

@end
