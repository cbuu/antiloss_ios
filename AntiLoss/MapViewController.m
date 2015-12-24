//
//  MapViewController.m
//  AntiLoss
//
//  Created by iorideng on 15/12/23.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "MapViewController.h"

#import "Constants.h"

@interface MapViewController ()<QMapViewDelegate>

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self initView];
}

- (void)initView
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(backButtonClick)];
    
    _mapView = [[QMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    _mapView.userTrackingMode = QUserTrackingModeFollowWithHeading;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backButtonClick
{
    _mapView.showsUserLocation = NO;
    [self.navigationController popViewControllerAnimated:YES];
   
}

- (void)mapViewWillStartLocatingUser:(QMapView *)mapView
{
    //获取开始定位的状态
    NSLog(@"begin location:%f,%f", mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude);
}

- (void)mapViewDidStopLocatingUser:(QMapView *)mapView
{
    NSLog(@"end location:%f,%f", mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude);
}

- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    NSLog(@"location:%f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
}

@end
