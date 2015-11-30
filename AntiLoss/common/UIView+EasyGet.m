//
//  UIView+EasyGet.m
//  AntiLoss
//
//  Created by cbuu on 15/11/30.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "UIView+EasyGet.h"

@implementation UIView(UIView_EasyGet)

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.height);
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, height);
    self.frame = frame;
}

@end
