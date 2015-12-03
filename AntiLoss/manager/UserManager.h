//
//  UserManager.h
//  AntiLoss
//
//  Created by cbuu on 15/12/3.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject

@property (nonatomic,strong) User* user;

+ (instancetype)getInstance;

- (void)setUpUserWithData:(NSDictionary*)data;

- (NSMutableArray*)getDevices;

@end
