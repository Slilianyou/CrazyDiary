//
//  SLLYMenuView.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/16.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "SLLYMenuView.h"

#define EXTRAAREA  0
#define BUTTONHEIGHT 40.0

@implementation SLLYMenuView
{
    UIWindow *keyWindow;
    BOOL triggered;
    CGFloat diff;
    UIColor *_menuColor;
}

#pragma mark ---init
-(instancetype)init
{
    self = [super init];
    if (self) {
      // custom...
    }
    return self;
}

- (id)initWithTitles:(NSArray *)titles
{
    return [self initWithTitles:titles withButtonHeight:BUTTONHEIGHT withMenuColor:kGetColor(57, 67, 89) withBackBlurStyle:UIBlurEffectStyleDark];
}

- (id)initWithTitles:(NSArray *)titles withButtonHeight:(CGFloat)height withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style
{
    self = [super init];
    if (self) {
        keyWindow = [self lastWindow];
        
    }
    return self;
}
#pragma mark --DrawRect:
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.width - EXTRAAREA, 0)];
    //
    [path addQuadCurveToPoint:CGPointMake(self.width - EXTRAAREA, self.height) controlPoint:CGPointMake(300, 200)];
    [path addLineToPoint:CGPointMake(0, self.height)];
    [path closePath];
    //
    [_menuColor set];
    [kGetColor(57, 67, 89) set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);
    
}
#pragma mark --Action
- (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in [windows reverseObjectEnumerator]) {
        if([windows isKindOfClass:[UIWindow class]] && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
        {
            return window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}






















@end
