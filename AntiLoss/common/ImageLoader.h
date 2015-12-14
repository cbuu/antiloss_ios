//
//  ImageLoader.h
//  AntiLoss
//
//  Created by cbuu on 15/12/11.
//  Copyright © 2015年 cbuu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class AFURLSessionManager;

@protocol ImageLoaderDelegate <NSObject>

- (void)onUploadImage:(NSString*)urlStr;
- (void)onDownloadImage:(UIImage*)image;

@end

@interface ImageLoader : NSObject

@property (nonatomic,assign) id<ImageLoaderDelegate>delegate;

- (instancetype)initWithSessionManager:(AFURLSessionManager*)manager;

//- (void)uploadImage:(UIImage*)image withDeviceMac:(NSString*)mac;

- (void)uploadImage:(UIImage*)image;
- (void)downloadImage:(NSString*)urlStr;

@end
