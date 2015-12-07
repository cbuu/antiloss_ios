//
//  AntilossSearchViewController.h
//  AntiLoss
//
//  Created by cbuu on 15/12/2.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AntiLossDevice;

@protocol SearchDelegate <NSObject>

- (void)succeedToBoundDevice:(AntiLossDevice*)device;

@end

@interface AntilossSearchViewController : UITableViewController

@property (nonatomic,weak) id<SearchDelegate> searchDelegate;

@end
