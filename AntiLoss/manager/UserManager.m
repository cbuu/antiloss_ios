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
        self.mode = USER_MODE;
    }
    return self;
}

- (void)setUpWithUsername:(NSString*)username
{
    if (username) {
        User * user = [User new];
        user.username = username;
        self.user = user;
    }
}

- (void)setUpUserWithData:(NSDictionary*)data
{
    if (data) {
        User * user = [User new];
        user.username = data[@"username"];
        user.devicesMac = [self parseJsonWithData:data];
        self.user = user;
    }
}

- (NSMutableArray*)parseJsonWithData:(NSDictionary*)data
{
    NSArray * arr = data[@"devices"];
    NSMutableArray * devicesMac = [NSMutableArray array];
    for (NSDictionary * d in arr) {
        [devicesMac addObject:d[@"deviceMac"]];
    }
    return devicesMac;
}

- (NSMutableArray *)getDevices{
    return self.user.devicesMac;
}

- (BOOL)isBounded:(NSString *)mac
{
    return [self.user isBounded:mac];
}


@end
