//
//  UIImage+Image.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/9/9.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    // 获得上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //使用color 演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    // 渲染上下文
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
   
    return  image;
}
@end






























































