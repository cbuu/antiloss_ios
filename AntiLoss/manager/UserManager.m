//
//  UserManager.m
//  AntiLoss
//
//  Created by cbuu on 15/12/3.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "UserManager.h"


@implementation UserManager

+ (instancetype)getInstance{
    static UserManager * instance;
    static dispatch_once_t user_token;
    
    dispatch_once(&user_token, ^{
        instance = [[UserManager alloc] init];
    });
    
    return instance;
}

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setUpUserWithData:(NSDictionary*)data
{
    if (data) {
        User * user = [User new];
        user.username = data[@"username"];
        user.devices = [self parseJsonWithData:data];
        self.user = user;
    }
}

- (NSMutableArray*)parseJsonWithData:(NSDictionary*)data
{
    NSArray * arr = data[@"devices"];
    NSMutableArray * devices = [NSMutableArray array];
    for (NSDictionary * d in arr) {
        [devices addObject:d[@"deviceMac"]];
    }
    return devices;
}

- (NSMutableArray *)getDevices{
    return self.user.devices;
}

- (BOOL)isBounded:(NSString *)mac
{
    return [self.user isBounded:mac];
}


@end
