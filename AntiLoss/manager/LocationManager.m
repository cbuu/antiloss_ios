//
//  LocationManager.m
//  AntiLoss
//
//  Created by cbuu on 15/12/21.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "LocationManager.h"
#import "MapViewController.h"
#import <QMapKit/QMapKit.h>

@interface LocationManager()<QMapViewDelegate>
{
    
}

@end

@implementation LocationManager
{
    UIViewController * mapController;
    UIViewController * bindVC;
}

+ (instancetype)getInstance
{
    static LocationManager * instance;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[LocationManager alloc] init];
        
    });
    
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        mapController = [[MapViewController alloc] init];
        [self genMapWithFrame:mapController.view.frame];
        _map.delegate = self;
        _map.userTrackingMode = QUserTrackingModeFollowWithHeading;
        
        [mapController.view addSubview:_map];
        
    }
    return self;
}

- (void)bindViewController:(UIViewController *)vc
{
    bindVC = vc;
}

- (void)showMap
{
    if (bindVC!= nil) {
        [bindVC.navigationController showViewController:mapController sender:bindVC];
    }
}

- (QMapView*)genMapWithFrame:(CGRect)frame
{
    _map = [[QMapView alloc] initWithFrame:frame];
    return _map;
}

- (void)initAnnotation
{
    NSMutableArray *annotations = [NSMutableArray array];
    
    /* Red .*/
    QPointAnnotation *red = [[QPointAnnotation alloc] init];
    red.coordinate = CLLocationCoordinate2DMake(39.9042, 116.234);
    red.title    = @"Red";
    red.subtitle = [NSString stringWithFormat:@"{%f, %f}", red.coordinate.latitude, red.coordinate.longitude];
    [annotations addObject:red];
    
    /* Green .*/
    QPointAnnotation *green = [[QPointAnnotation alloc] init];
    green.coordinate = CLLocationCoordinate2DMake(39.9042, 116.334);
    green.title    = @"Green";
    green.subtitle = [NSString stringWithFormat:@"{%f, %f}", green.coordinate.latitude, green.coordinate.longitude];
    [annotations addObject:green];
    
    /* Purple .*/
    QPointAnnotation *purple = [[QPointAnnotation alloc] init];
    purple.coordinate = CLLocationCoordinate2DMake(39.9042, 116.424);
    purple.title    = @"Purple";
    purple.subtitle = [NSString stringWithFormat:@"{%f, %f}", purple.coordinate.latitude, purple.coordinate.longitude];
    [annotations addObject:purple];
    
    [_map addAnnotations:annotations];
}

#pragma mark -Qmapdelegate


- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QPinAnnotationView *annotationView = (QPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = YES;
        annotationView.canShowCallout   = YES;
        
        annotationView.pinColor = [_map.annotations indexOfObject:annotation];
        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }
    
    return nil;
}

- (void)mapViewWillStartLocatingUser:(QMapView *)mapView
{
    //获取开始定位的状态
}

- (void)mapViewDidStopLocatingUser:(QMapView *)mapView
{
    //获取停止定位的状态
}

- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    int a = 1;
}

@end
