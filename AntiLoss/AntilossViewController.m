//
//  AntilossViewController.m
//  AntiLoss
//
//  Created by cbuu on 15/11/25.
//  Copyright © 2015年 cbuu. All rights reserved.
//
#import "AntiLossDevice.h"
#import "AntilossViewController.h"
#import "CBUURotateView.h"
#import "manager/BTManager.h"

@interface AntilossViewController ()<BTManagerDelegate>
{
    CBUURotateView * rotateView;
    
    BOOL isFound;
}

@end

@implementation AntilossViewController

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BTManager getInstance].managerDelegate = self;
    
    isFound = NO;
    
    [self initView];
    [self addRotateView];
}

- (void)initView{
    [self.view setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]];
    
    [self makeRoundImage:self.deviceImage];
    
    self.searchStateLabel.text = @"搜索中";
    
    self.deviceNameLabel.text = self.device.deviceName;
    
    
    [[BTManager getInstance] scan];
}

- (void)addRotateView{
    rotateView = [CBUURotateView buildProgressViewWithFrame:self.deviceImage.frame redius:self.deviceImage.frame.size.width/2 width:5 startAngle:0 endAngle:M_PI/2 color:[UIColor greenColor]];
    rotateView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:rotateView];
    
    NSLayoutConstraint * rotateViewConstraintX = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.deviceImage attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
    NSLayoutConstraint * rotateViewConstraintY = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.deviceImage attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    
    NSLayoutConstraint * rotateViewConstraintW = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.deviceImage attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
    
    NSLayoutConstraint * rotateViewConstraintH = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.deviceImage attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0];
    
    rotateViewConstraintX.active = YES;
    rotateViewConstraintY.active = YES;
    rotateViewConstraintW.active = YES;
    rotateViewConstraintH.active = YES;
    
    [rotateView startRotateWithDuration:2.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)makeRoundImage:(UIImageView*)imageView{
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.clipsToBounds = YES;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 5.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)soundButtonClick:(id)sender {
    NSLog(@"sound");
    [[BTManager getInstance] makeSound:self.device];
}
- (IBAction)editDeviceInfo:(id)sender {
    
}


- (void)appWillEnterForegroundNotification{
    if (!isFound) {
        [rotateView startRotateWithDuration:2.0f];
    }
}

#pragma mark - BTmanager delegate

- (void)deviceFound:(AntiLossDevice *)device
{
    if (device&&[device.deviceMac isEqualToString:self.device.deviceMac]) {
        [[BTManager getInstance] connect:device];
    }
}

- (void)deviceConnectResult:(BOOL)isSuccess
{
    isFound = isSuccess;
    if (isSuccess) {
        [self.soundButton setTitle:@"鸣笛" forState:UIControlStateNormal];
    }
}

@end
