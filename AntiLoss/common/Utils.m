//
//  Utils.m
//  AntiLoss
//
//  Created by cbuu on 15/12/9.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "Utils.h"

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
@end
