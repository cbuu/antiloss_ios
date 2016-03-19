//
//  JSONParseUtil.h
//  AntiLoss
//
//  Created by cbuu on 15/12/4.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface JSONParseUtil : NSObject

+ (NSData*)userToJSON:(User*)user;
+ (NSDictionary*)userFromJSON:(NSData*)jsonData;
+ (NSData*)devicesMacToJSON:(NSArray*)devices;
+ (NSDictionary*)deviceFromJson:(NSString*)json;

@end
