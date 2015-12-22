//
//  IOIndicatorView.m
//  AntiLoss
//
//  Created by iorideng on 15/12/22.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "IOIndicatorView.h"


@interface IOIndicatorView()
{
    UIImageView * background;
    UIActivityIndicatorView * indicatorView;
    
}
@end

@implementation IOIndicatorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.frame = [UIScreen mainScreen].bounds;
    [self makeKeyAndVisible];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    background.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35f];
    background.center = self.center;
    [self addSubview:background];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.center = CGPointMake(75, 75);
    [background addSubview:indicatorView];
}

- (void)show
{
    [indicatorView startAnimating];
}

- (void)hide
{
    [indicatorView stopAnimating];
    self.hidden = YES;
}

@end
