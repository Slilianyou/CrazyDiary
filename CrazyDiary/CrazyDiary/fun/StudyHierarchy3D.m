//
//  StudyHierarchy3D.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/9/5.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "StudyHierarchy3D.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

#if !__has_feature(objc_arc)
#error add -fobjc-arc to compiler flags
#endif

#ifndef DEGREES_TO_RADIANS
#define DEGREES_TO_RADIANS(d)  ((d) * M_PI / 180)
#endif

@interface StudyHierarchy3D ()
{
    float rotateX;
    float rotateY;
    float dist;
    BOOL isAnimating;
}
+ (StudyHierarchy3D *)sharedInstance;
- (void)toggleShow;
@property (nonatomic, strong) NSMutableArray *holders;
@end

#pragma mark - Top

@interface StudyHierarchy3DTop : UIWindow
+ (StudyHierarchy3DTop *)sharedInstance;

@end
@implementation StudyHierarchy3DTop

+(StudyHierarchy3DTop *)sharedInstance
{
    static StudyHierarchy3DTop * _singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[StudyHierarchy3DTop alloc]init];
    });
    return _singleton;
}

-(instancetype)init
{
    CGRect frame = CGRectMake(40, 40, 40, 40);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.windowLevel = UIWindowLevelStatusBar + 100.0f;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        btn.frame = CGRectMake(5, 5, 30, 30);
        btn.layer.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.9f].CGColor;
        btn.layer.cornerRadius = CGRectGetWidth(btn.frame) / 2.f;
        btn.layer.shadowOpacity = YES;
        btn.layer.shadowRadius = 4;
        btn.layer.shadowColor = [UIColor blackColor].CGColor;
        btn.layer.shadowOffset = CGSizeMake(0, 0);
        UIPanGestureRecognizer *g = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [btn addGestureRecognizer:g];
        [btn addTarget:[StudyHierarchy3D sharedInstance] action:@selector(toggleShow) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)getstureRecognizer
{
    static CGRect oldFrame;
    if (getstureRecognizer.state == UIGestureRecognizerStateBegan) {
        oldFrame = self.frame;
    }
    // 这个函数是得到触点在屏幕上与开始触摸点的位移值
    CGPoint change = [getstureRecognizer translationInView:self];
    CGRect newFrame = oldFrame;
    newFrame.origin.x += change.x;
    newFrame.origin.y += change.y;
    self.frame = newFrame;
    
}
@end

@interface UIView (holderFrame)
@property (nonatomic, readonly) CGRect holderFrame;
- (CGRect)holderFrameWithDelta:(CGPoint)delta;
@end
@implementation UIView (holderFrame)
- (CGRect)holderFrame
{
    CGRect r = CGRectMake(self.center.x - self.bounds.size.width / 2, self.center.y - self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height);
    return r;
}
- (CGRect)holderFrameWithDelta:(CGPoint)delta
{
    CGRect r = CGRectMake(self.center.x - self.bounds.size.width / 2 + delta.x, self.center.y - self.bounds.size.height / 2 + delta.y, self.bounds.size.width, self.bounds.size.height);
    return r;
}
@end

@interface ViewImageHolder : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) float  deep;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, strong) UIView *view;

@end
@implementation ViewImageHolder
@synthesize image = _image;
@synthesize deep = _deep;
@synthesize rect = _rect;
@synthesize view = _view;


@end



@implementation StudyHierarchy3D
@synthesize holders = _holders;
+ (StudyHierarchy3D *)sharedInstance
{
    static StudyHierarchy3D *_singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[StudyHierarchy3D alloc]init];
    });
    return _singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame  = [UIScreen mainScreen].bounds;
        self.windowLevel = UIWindowLevelStatusBar + 99.0f;
        UIPanGestureRecognizer * gPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        UIPinchGestureRecognizer *gPinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
        [self addGestureRecognizer:gPan];
        [self addGestureRecognizer:gPinch];
    }
    return self;
}
+ (void)show
{
    [StudyHierarchy3DTop sharedInstance].hidden = NO;
    [StudyHierarchy3D sharedInstance].hidden = YES;
}
+(void)hide
{
    [StudyHierarchy3DTop sharedInstance].hidden = YES;
    [StudyHierarchy3D sharedInstance].hidden = YES;
}
- (void)toggleShow
{
    if (isAnimating) {
        return;
    }
    if (self.hidden) {
        self.hidden = NO;
        self.frame = [UIScreen mainScreen].bounds;
        [self startShow];
        [UIView animateWithDuration:0.4 animations:^{
            self.backgroundColor = [UIColor orangeColor];
        }];
    }else {
        [self startHide];
        [UIView animateWithDuration:0.4 animations:^{
            self.backgroundColor = [UIColor clearColor];
        }];
    }
    
}

- (void)startShow
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    self.holders = nil;
    rotateX = 0;
    rotateY = 0;
    self.holders = [NSMutableArray arrayWithCapacity:100];
    NSLog(@"%ld",(unsigned long)[UIApplication sharedApplication].windows.count);
    for (int i = 0; i < [UIApplication sharedApplication].windows.count; i++) {
        if ([UIApplication sharedApplication].windows[i] == [StudyHierarchy3DTop sharedInstance] ){
            continue;
        }
        [self dumpView:[UIApplication sharedApplication].windows[i] atDeep:i *5 atOriginDelta:CGPointMake(0, 0) toArray:_holders];
    }
  
    for (ViewImageHolder *h in _holders) {
        UIImageView *imgV = [[UIImageView alloc]initWithImage:h.image];
        imgV.frame = h.rect;
        [self addSubview:imgV];
        h.view = imgV;
        CGRect r = imgV.frame;
        CGRect scr = [UIScreen mainScreen].bounds;
        imgV.layer.anchorPoint = CGPointMake((scr.size.width / 2 - imgV.frame.origin.x) / imgV.frame.size.width, (scr.size.height / 2 - imgV.frame.origin.y)/ imgV.frame.size.height );
        imgV.layer.anchorPointZ = (-h.deep + 3) *50;
        
        imgV.frame = r;
        imgV.layer.opacity = 0.9;
        imgV.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    }
    [self anime:0.3];
    
}
- (void)startHide {
    isAnimating = YES;
    [UIView animateWithDuration:0.3 animations:^() {
        for (ViewImageHolder * holder in self.holders) {
            holder.view.layer.transform = CATransform3DIdentity;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^() {
            self.hidden = YES;
        } completion:^(BOOL finished) {
            for (ViewImageHolder * holder in self.holders) {
                [holder.view removeFromSuperview];
            }
            self.holders = nil;
            isAnimating = NO;
        }];
    }];
}

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer
{
    static CGPoint oldPan;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        oldPan = CGPointMake(rotateY, -rotateX);
    }
    CGPoint change = [gestureRecognizer translationInView:self];
    rotateY =  oldPan.x + change.x;
    rotateX = -oldPan.y - change.y;
    [self anime:0.1];
}
- (void)pinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
    static float oldDist;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        oldDist = dist;
    }
    dist = oldDist + (gestureRecognizer.scale - 1);
    dist = dist < -5 ? -5 : dist > 0.5 ? 0.5 : dist;
    [self anime:0.1];
}

- (void)dumpView:(UIView *)aView atDeep:(float)deep atOriginDelta:(CGPoint)originDelta toArray:(NSMutableArray *)holders
{
    NSMutableArray *notHiddens = [NSMutableArray arrayWithCapacity:0];
    for (UIView *v in aView.subviews) {
        if (!v.hidden) {
            [notHiddens addObject:v];
//            v.backgroundColor = [UIColor redColor];
            v.hidden = YES;
        }
    }
    UIImage *img = [self renderImageFromView:aView];
    for (UIView *v in notHiddens) {
        v.hidden = NO;
    }
    if (img) {
        ViewImageHolder *holder = [[ViewImageHolder alloc]init];
        holder.image = [self renderImageForAntialiasing:img];
        holder.deep = deep;
        CGRect rect = [aView holderFrameWithDelta:originDelta];
        rect.origin.x -= 1;
        rect.origin.y -= 1;
        rect.size.width += 2;
        rect.size.height += 2;
        holder.rect = rect;
        [holders addObject:holder];
    }
    CGPoint subDelta = [aView holderFrameWithDelta:originDelta].origin;
    for (int i = 0; i < aView.subviews.count; i++) {
        UIView *v = aView.subviews[i];
        [self dumpView:v atDeep:deep + 1 + i / 10.0f atOriginDelta:subDelta toArray:holders];
    }
}

- (UIImage *)renderImageFromView:(UIView *)view
{
    return [self renderImageFromView:view withRect:view.bounds];
}
- (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)frame
{
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }
    
    //CGContextTranslateCTM(context, -frame.origin.x, -frame.origin.y);
    [view.layer renderInContext:context];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}
- (UIImage *)renderImageForAntialiasing:(UIImage *)image {
    return [self renderImageForAntialiasing:image withInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
}

- (UIImage *)renderImageForAntialiasing:(UIImage *)image withInsets:(UIEdgeInsets)insets {
    CGSize imageSizeWithBorder = CGSizeMake([image size].width + insets.left + insets.right,
                                            [image size].height + insets.top + insets.bottom);
    
    UIGraphicsBeginImageContextWithOptions(imageSizeWithBorder,
                                           UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero), 0);
    
    [image drawInRect:(CGRect) {{ insets.left, insets.top }, [image size] }];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

//TODO:_________CATranform3D__animation
- (void)anime:(float)time;
{
    CATransform3D trans = CATransform3DIdentity;
    CATransform3D t = CATransform3DIdentity;
    /*transform的结构如下：
     struct CATransform3D
     {
     CGFloat m11, m12, m13, m14;
     CGFloat m21, m22, m23, m24;
     CGFloat m31, m32, m33, m34;
     CGFloat m41, m42, m43, m44;
     };
     
     首先要实现view（layer）的透视效果（就是近大远小），是通过设置m34的：
     
     CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
     rotationAndPerspectiveTransform.m34 = 1.0 / -500;
     
     m34负责z轴方向的translation（移动），m34= -1/D,  默认值是0，也就是说D无穷大，这意味layer in projection plane（投射面）和layer in world coordinate重合了。
     
     D越小透视效果越明显。
     
     所谓的D，是eye（观察者）到投射面的距离
     */
    t.m34 = -0.001;
    trans = CATransform3DMakeTranslation(0, 0, dist * 1000);
    trans = CATransform3DConcat(CATransform3DMakeRotation(DEGREES_TO_RADIANS(rotateX), 1, 0, 0), trans);
    trans = CATransform3DConcat(CATransform3DMakeRotation(DEGREES_TO_RADIANS(rotateY), 0, 1, 0), trans);
    trans = CATransform3DConcat(CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 0, 0, 1), trans);
    trans = CATransform3DConcat(trans, t);
    
    isAnimating = YES;
    [UIView animateWithDuration:time animations:^{
        for (ViewImageHolder *holder in self.holders) {
            holder.view.layer.transform = trans;
        }
    } completion:^(BOOL finished) {
        isAnimating = NO;
    }];
}


































@end
