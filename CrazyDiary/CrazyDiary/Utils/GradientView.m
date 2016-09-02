//
//  GradientView.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/9/1.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawGradient:context];
}
#pragma mark -- 线性渐变
- (void)drawGradient:(CGContextRef)context
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[8] = {1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,1.0f,0.8f};
    CGFloat locations[2] = {0.f,1.0f};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    // 渐变区域裁剪
////    CGContextClipToRect(context, CGRectMake(0, 80, 300, 200));
//    CGRect rect[5] = {CGRectMake(0, 0, 100, 100),CGRectMake(100, 100, 100, 100),CGRectMake(200, 0, 100, 100),CGRectMake(0, 200, 100, 100),CGRectMake(200, 200, 100, 100)};
//    CGContextClipToRects(context, rect, 5);
    
    // 绘制渐变
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0f, 0.0f), CGPointMake(0.0f, self.frame.size.height), 0);
    
    // 释放对象
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}






















@end
