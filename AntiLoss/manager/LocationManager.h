//
//  LocationManager.h
//  AntiLoss
//
//  Created by cbuu on 15/12/21.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QMapKit/QMapKit.h>
#import <UIKit/UIKit.h>

@interface LocationManager : NSObject

@property (nonatomic,strong) QMapView * map;

+ (instancetype) getInstance;

- (void)bindViewController:(UIViewController *)vc;

- (void)showMap;

@end
