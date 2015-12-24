//
//  AntilossHelpViewController.m
//  AntiLoss
//
//  Created by cbuu on 15/12/21.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "AntilossHelpViewController.h"
#import "network/NetworkCenter.h"
#import "CBUURotateView.h"
#import "BTManager.h"
#import "Utils.h"

@interface AntilossHelpViewController ()<BTManagerDelegate,ImageLoaderDelegate,QMapViewDelegate>
{
    CBUURotateView * rotateView;
    BOOL isFound;
}

@end

@implementation AntilossHelpViewController

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    if (isFound) {
        [rotateView stopRotate];
    }else{
        [rotateView startRotateWithDuration:2.0f];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [rotateView stopRotate];
}

-(void)dealloc{
    [_locationManager setShowsUserLocation:NO];
    [[BTManager getInstance] disconnectAllDevices];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpLocationManager];

    [BTManager getInstance].managerDelegate = self;
    
    [NetworkCenter getInstance].imageLoader.delegate = self;
    
    
    [self initView];
    
    [[BTManager getInstance] scan];
    [[NetworkCenter getInstance].imageLoader downloadImage:self.device.imageID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpLocationManager
{
    _locationManager = [[QMapView alloc] init];
    [_locationManager setShowsUserLocation:YES];
    _locationManager.delegate = self;
    _locationManager.userTrackingMode = QUserTrackingModeFollowWithHeading;

}

- (void)initView
{
    [self.view setBackgroundColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f]];
    
    self.title = @"帮助寻找";
    
    self.deviceNameLabel.text = self.device.deviceName;
    
    [self makeRoundImage:self.deviceImageView];
    
    [self initButton];
    
    [self addRotateView];
    
}

- (void)initButton{
    [Utils makeRoundButton:self.soundButton];
}

- (void)addRotateView{
    rotateView = [CBUURotateView buildProgressViewWithFrame:self.deviceImageView.frame redius:self.deviceImageView.frame.size.width/2 width:5 startAngle:0 endAngle:M_PI/2 color:[UIColor greenColor]];
    rotateView.userInteractionEnabled = NO;
    rotateView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:rotateView];
    
    NSLayoutConstraint * rotateViewConstraintX = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.deviceImageView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
    NSLayoutConstraint * rotateViewConstraintY = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.deviceImageView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    
    NSLayoutConstraint * rotateViewConstraintW = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.deviceImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
    
    NSLayoutConstraint * rotateViewConstraintH = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.deviceImageView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0];
    
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

- (void)appWillEnterForegroundNotification{
    if (!isFound) {
        [rotateView startRotateWithDuration:2.0f];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
        self.stateLabel.text = [NSString stringWithFormat:@"已找到：%.2f  %.2f",_location.coordinate.latitude,_location.coordinate.longitude];
        [rotateView stopRotate];
        [_locationManager setShowsUserLocation:NO];
    }
}

- (void)deviceDisconnectResult:(BOOL)isSuccess
{
    if (isSuccess) {
        isFound = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - imageLoader delegate

- (void)onDownloadImage:(UIImage *)image
{
    if (image) {
        self.deviceImageView.image = image;
        self.device.image = image;
    }
}

#pragma mark - map delegate

- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    _location = userLocation.location;
    
    _stateLabel.text = [NSString stringWithFormat:@"搜索中：%.2f  %.2f",_location.coordinate.latitude,_location.coordinate.longitude];
    [_stateLabel sizeToFit];
}

#pragma mark - action

- (IBAction)soundButtonClick:(id)sender {
    if (isFound) {
        NSLog(@"sound");
        [[BTManager getInstance] makeSound:self.device];
    }
}

- (IBAction)backButtonClick:(id)sender {
    if (isFound) {
        [[BTManager getInstance] disconnectAllDevices];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
