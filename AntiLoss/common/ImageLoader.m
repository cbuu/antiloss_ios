//
//  ImageLoader.m
//  AntiLoss
//
//  Created by cbuu on 15/12/11.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "ImageLoader.h"
#import <AFNetworking.h>
#import "Constants.h"
#import "Utils.h"

@interface ImageLoader()
{
    AFURLSessionManager * manager;
}
@end

@implementation ImageLoader



- (instancetype)initWithSessionManager:(AFURLSessionManager *)aManager
{
    if (self=[super init]) {
        manager = aManager;
    }
    return self;
}

- (void)uploadImage:(UIImage *)image
{
    NSString * uploadPath = [NETWORK_PATH stringByAppendingPathComponent:@"images"];
    
    NSURL *URL = [NSURL URLWithString:uploadPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    NSData * data = UIImageJPEGRepresentation(image, 1.0f);
    
    request.HTTPBody = data;
    
    [request addValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (self.delegate) {
            if (error) {
                [self.delegate onUploadImage:nil];
            }else{
                [self.delegate onUploadImage:responseObject[@"imagePath"]];
            }
        }
        
    }];
    
    [dataTask resume];
    
}

- (void)downloadImage:(NSString *)urlStr
{
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSString * cacheName = [Utils md5:urlStr];
    NSURL * path = [documentsDirectoryURL URLByAppendingPathComponent:cacheName];
    NSData* imageData = [NSData dataWithContentsOfURL:path]; //3
    UIImage* image = [UIImage imageWithData:imageData];
    if (!image) {
        NSLog(@"unable to build image");
    }else if (self.delegate) {
        [self.delegate onDownloadImage:image];
        return;
    }
    
    
    NSString * downloadPath = [NETWORK_PATH stringByAppendingPathComponent:@"download"];
    
    downloadPath = [downloadPath stringByAppendingPathComponent:[NSString stringWithFormat:@"?imagePath=%@",urlStr]];
    
    NSURL *URL = [NSURL URLWithString:downloadPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask * downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        NSString * cacheName = [Utils md5:urlStr];
        
        NSURL * path = [documentsDirectoryURL URLByAppendingPathComponent:cacheName];
        
        return path;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        if (!error) {
            NSData* imageData = [NSData dataWithContentsOfURL:filePath]; //3
            UIImage* image = [UIImage imageWithData:imageData];
            if (!image) {
                NSLog(@"unable to build image");
            }
            if (self.delegate) {
                [self.delegate onDownloadImage:image];
            }
        }
    }];
    
    [downloadTask resume];
}

@end
