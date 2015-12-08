//
//  CBUURotateView.h
//  Test
//
//  Created by cbuu on 15/8/31.
//  Copyright (c) 2015年 cbuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBUURotateView : UIView

+ (instancetype)buildProgressViewWithFrame:(CGRect)frame redius:(CGFloat)redius width:(CGFloat)width startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor*)color;

- (void)startRotateWithDuration:(CGFloat)duration;
- (void)stopRotate;

@end
