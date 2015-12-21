//
//  LocationManager.m
//  AntiLoss
//
//  Created by cbuu on 15/12/21.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

+ (instancetype)getInstance
{
    static LocationManager * instance;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[LocationManager alloc] init];
        
    });
    
    return instance;
}



@end
