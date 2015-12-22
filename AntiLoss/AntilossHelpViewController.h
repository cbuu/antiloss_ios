//
//  AntilossHelpViewController.h
//  AntiLoss
//
//  Created by cbuu on 15/12/21.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AntiLossDevice.h"


@interface AntilossHelpViewController : UIViewController

@property (nonatomic,strong) AntiLossDevice * device;

@property (strong, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (strong, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UIButton *soundButton;

@end
