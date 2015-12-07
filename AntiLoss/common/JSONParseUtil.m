//
//  JSONParseUtil.m
//  AntiLoss
//
//  Created by cbuu on 15/12/4.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "JSONParseUtil.h"

@implementation JSONParseUtil

+ (NSData*)devicesMacToJSON:(NSArray*)devices{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    [dic setObject:devices forKey:@"devicesMac"];
    
    return [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
}

@end
