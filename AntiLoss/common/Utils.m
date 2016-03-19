//
//  Utils.m
//  AntiLoss
//
//  Created by cbuu on 15/12/9.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Utils

+(void)makeRoundButton:(UIButton *)button{
    button.layer.cornerRadius = 5.0f;
    //button.backgroundColor = [UIColor greenColor];
    button.clipsToBounds = YES;
}


+(UIImage *)getThumbImage:(UIImage *)oImage size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [oImage drawInRect:CGRectMake(0,0,size.width,size.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (NSString *)md5:(NSString *)str
{
    if (str==nil||[str isEqualToString:@""]) {
        return @"";
    }
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
