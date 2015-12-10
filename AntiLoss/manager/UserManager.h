//
//  UserManager.h
//  AntiLoss
//
//  Created by cbuu on 15/12/3.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

typedef enum : NSUInteger {
    USER_MODE,
    HELP_MODE,
} ENTER_MODE;

@interface UserManager : NSObject

@property (nonatomic,strong) User* user;
@property (nonatomic,assign) ENTER_MODE mode;

+ (instancetype)getInstance;

- (void)setUpWithUsername:(NSString*)username;
- (void)setUpUserWithData:(NSDictionary*)data;

- (NSMutableArray*)getDevices;

- (BOOL)isBounded:(NSString*)mac;

@end
