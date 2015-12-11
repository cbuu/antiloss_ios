//
//  User.h
//  AntiLoss
//
//  Created by cbuu on 15/12/2.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface User : NSObject

@property (nonatomic,copy) NSString * username;
@property (nonatomic,copy) NSMutableArray * devicesMac;

- (BOOL)isBounded:(NSString*)mac;
- (BOOL)unBoundDevice:(NSString*)mac;
@end
