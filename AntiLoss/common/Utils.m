//
//  Utils.m
//  AntiLoss
//
//  Created by cbuu on 15/12/9.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(void)makeRoundButton:(UIButton *)button{
    button.layer.cornerRadius = 5.0f;
    button.backgroundColor = [UIColor greenColor];
    button.clipsToBounds = YES;
}

@end
