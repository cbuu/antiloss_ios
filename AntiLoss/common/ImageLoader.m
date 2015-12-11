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
    
}

@end
