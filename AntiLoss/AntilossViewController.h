//
//  AntilossViewController.h
//  AntiLoss
//
//  Created by cbuu on 15/11/25.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AntiLossDevice;

@interface AntilossViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *soundButton;

@property (strong,nonatomic) AntiLossDevice* device;

@end
