//
//  CBUURotateView.mm
//  Test
//
//  Created by cbuu on 15/8/31.
//  Copyright (c) 2015年 cbuu. All rights reserved.
//

#import "CBUURotateView.h"



@implementation CBUURotateView


+ (instancetype)buildProgressViewWithFrame:(CGRect)frame redius:(CGFloat)redius width:(CGFloat)width startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor*)color
{
    CBUURotateView * view = [[CBUURotateView alloc] initWithFrame:frame];
    if (view) {
        CGFloat realRedius = redius - width/2;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(redius, redius)
                                                            radius:realRedius
                                                        startAngle:startAngle
                                                          endAngle:endAngle
                                                         clockwise:YES];
        
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.frame = view.bounds;
        layer.strokeColor   = color.CGColor;   // 边缘线的颜色
        layer.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
        //layer.lineCap       = kCALineCapSquare;               // 边缘线的类型
        layer.lineCap       = kCALineCapRound;
        layer.path          = path.CGPath;                    // 从贝塞尔曲线获取到形状
        layer.lineWidth     = width;                           // 线条宽度
        
        
        [view.layer addSublayer:layer];
    }
    
    
    return view;
}

- (void)startRotateWithDuration:(CGFloat)duration
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopRotate
{
    [self.layer removeAllAnimations];
}

@end
