//
//  SLLYMenuView.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/16.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "SLLYMenuView.h"
#import "SLLYMenuButton.h"

#define EXTRAAREA  0
#define BUTTONHEIGHT 40.0
#define SPACE 30.f //按钮间距

@interface SLLYMenuView ()

/**
 *   做动画标记的view的X坐标
 */
@property (nonatomic, assign) CGFloat curveX;
/**
 *   做动画标记的view的Y坐标
 */
@property (nonatomic, assign) CGFloat curveY;
@property (nonatomic, strong) UIView *curveView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL isOpeningMenu;
@end


@implementation SLLYMenuView
{
    UIView *helperCenterView;
    UIView *helperSideView;
    UIVisualEffectView *blurView;
    UIWindow *keyWindow;
    BOOL triggered;
    CGFloat diff;
    UIColor *_menuColor;
}
static NSString * kX = @"curveX";
static NSString * kY = @"curveY";

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
        self.backgroundColor = [UIColor blueColor];
        keyWindow = [self lastWindow];

        [self addObserver:self forKeyPath:kX options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:kY options:NSKeyValueObservingOptionNew context:nil];
        [self configShapeLayer];
        [self configCurveView];
        [self confingAction];
        
        blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:style]];
        blurView.frame = keyWindow.frame;
        blurView.alpha = 0.5f;
        
        
//        self.frame = CGRectMake(-keyWindow.width / 2.f - EXTRAAREA, 0, keyWindow.width / + 2 + EXTRAAREA, keyWindow.height);
//        self.backgroundColor = [UIColor redColor];
//        [keyWindow addSubview: self];
        
        self.frame = CGRectMake(0, 0, keyWindow.width / + 2 + EXTRAAREA, keyWindow.height);
        self.backgroundColor = [UIColor redColor];
        [keyWindow addSubview: self];
        
        _menuColor = menuColor;
        self.menuButtonHeight = height;
        [self addButtons:titles];
        
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
    [path addQuadCurveToPoint:CGPointMake(self.width - EXTRAAREA, self.height) controlPoint:CGPointMake(keyWindow.width/2.f + diff, keyWindow.height / 2.f)];
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
- (void)addButtons:(NSArray *)titles
{
    if ((titles.count & 1) == 0) {
        NSInteger  index_down = titles.count / 2;
        NSInteger index_up = -1;
        for (NSInteger i = 0; i < titles.count; i++) {
            SLLYMenuButton *menuBtn = [[SLLYMenuButton alloc]initWithTitle:titles[i]];
            if (i > titles.count / 2) {
                index_up ++;
                menuBtn.center = CGPointMake(keyWindow.width / 4.f, keyWindow.height / 2.f + self.menuButtonHeight *index_up + SPACE *index_up + SPACE /2 + self.menuButtonHeight / 2.f);
            } else {
                index_down --;
                 menuBtn.center = CGPointMake(keyWindow.width / 4.f, keyWindow.height / 2.f - self.menuButtonHeight *index_up - SPACE *index_up - SPACE /2 - self.menuButtonHeight / 2.f);
                
            }
            menuBtn.bounds = CGRectMake(0, 0, keyWindow.width /2 - 20 *2, self.menuButtonHeight);
            menuBtn.btnColor = _menuColor;
            [self addSubview:menuBtn];
            
            __weak typeof (self) weakSelf = self;
            menuBtn.buttonClickBlock = ^(){
                // ????????
                weakSelf.menuClickBlock(i,titles[i],titles.count);
            };
        }
    } else {
        NSInteger index = (titles.count + 1)/2;
        for (NSInteger i = 0; i < titles.count; i++) {
            index --;
            SLLYMenuButton *menuBtn = [[SLLYMenuButton alloc]initWithTitle:titles[i]];
            menuBtn.center = CGPointMake(keyWindow.width / 4, keyWindow.height / 2 - self.menuButtonHeight *index - 20 *index);
            menuBtn.bounds = CGRectMake(0, 0, keyWindow.width / 2 - 20 *2, self.menuButtonHeight);
            
            menuBtn.btnColor = _menuColor;
            [self addSubview:menuBtn];
            
            __weak typeof (self) weakSelf = self;
            menuBtn.buttonClickBlock = ^(){
                // ????????
                weakSelf.menuClickBlock(i,titles[i],titles.count);
            };

        }
    }
}
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

- (void)configShapeLayer
{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.fillColor = kGetColor(57.f, 67.f, 89.f).CGColor;
    [keyWindow.layer addSublayer:_shapeLayer];
}

- (void)configCurveView
{
    _curveView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT / 2.0, 3, 3)];
    _curveView.backgroundColor = [UIColor orangeColor];
    [keyWindow addSubview:_curveView];
}

- (void)confingAction
{
    _isAnimating = NO; // 是否处于动效状态
    _isOpeningMenu = NO; //是否处于菜单栏打开过程状态
    UIScreenEdgePanGestureRecognizer *span = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanAction:)];
    span.edges = UIRectEdgeLeft;
    [keyWindow addGestureRecognizer:span];
}

- (void)handlePanAction:(UIPanGestureRecognizer *)pan
{
    if (!_isAnimating) {
        if (pan.state == UIGestureRecognizerStateChanged) {
            CGPoint point = [pan translationInView:self];
            self.curveX = point.x;
            self.curveY = SCREENHEIGHT /2.0;
            _curveView.frame = CGRectMake(_curveX, _curveY, _curveView.width, _curveView.height);
            if (point.x > 80.0 && !_isOpeningMenu) {
//                []
                _isOpeningMenu = YES;
            }
        }
    }
}

- (void)updateShaperLayerPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path moveToPoint:CGPointMake(0, SCREENHEIGHT)];
    [path addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:CGPointMake(_curveX, _curveY)];
    [path closePath];
    _shapeLayer.path = path.CGPath;
}
#pragma mark --键值观察
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:kX] || [keyPath isEqualToString:kY]) {
        [self updateShaperLayerPath];
    }
}




















@end
