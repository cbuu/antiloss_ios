//
//  JSONParseUtil.m
//  AntiLoss
//
//  Created by cbuu on 15/12/4.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "JSONParseUtil.h"
#import "User.h"


@implementation JSONParseUtil

+ (NSData*)userToJSON:(User*)user{
    NSMutableDictionary * dic  = [NSMutableDictionary dictionary];
    dic[@"teleNum"] = user.teleNum;
    dic[@"username"] = user.username;
    
    return [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
}


+ (NSDictionary*)userFromJSON:(NSData*)jsonData{
    if (jsonData == nil) {
        return nil;
    }
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSData*)devicesMacToJSON:(NSArray*)devices{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    [dic setObject:devices forKey:@"devicesMac"];
    
    return [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
}

+ (NSDictionary*)deviceFromJson:(NSString*)json
{
    if (json == nil) {
        return nil;
    }
    
    
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
