//
//  MessageNode.h
//  AntiLoss
//
//  Created by iorideng on 15/12/24.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageNode : NSObject

@property (nonatomic,copy) NSString * meaageID;

@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * message;
@property (nonatomic,copy) NSString * fromUser;

@property (nonatomic,strong) id data;

@end
