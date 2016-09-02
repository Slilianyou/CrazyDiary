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
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger  animationCount;
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
        
        keyWindow = [self lastWindow];
        [self addObserver:self forKeyPath:kX options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:kY options:NSKeyValueObservingOptionNew context:nil];
        [self configShapeLayer];
        [self configCurveView];
        [self confingAction];
        
//        // 模糊效果
//        blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:style]];
//        blurView.frame = keyWindow.frame;
//        blurView.alpha = 0.0f;
        
        // ???
        helperSideView = [[UIView alloc]initWithFrame:CGRectMake(-40, 0, 40, 40)];
        helperSideView.backgroundColor = [UIColor blackColor];
        helperSideView.hidden = NO;
        [keyWindow addSubview:helperSideView];
        
        helperCenterView = [[UIView alloc]initWithFrame:CGRectMake(-40, keyWindow.height / 2 - 20, 40, 40)];
        helperCenterView.backgroundColor = [UIColor blackColor];
        helperCenterView.hidden = NO;
        [keyWindow addSubview:helperCenterView];
        
        
        self.frame = CGRectMake(-keyWindow.width / 2.f - EXTRAAREA, 0, keyWindow.width / 2.f + EXTRAAREA, keyWindow.height);
        self.backgroundColor = [UIColor clearColor];
        [keyWindow insertSubview:self belowSubview:helperSideView];
        
        
        
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
    NSLog(@"%f",diff);
    [path addLineToPoint:CGPointMake(0, self.height)];
    [path closePath];
    //
    
//    [kGetColor(57, 67, 89) set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [_menuColor set];
    CGContextFillPath(context);
    [self updateShaperLayerPath];
    [self calculatePath];
}
#pragma mark --Action
- (void)beforeAnimation
{
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount ++;
}
- (void)finishAnimation
{
    self.animationCount --;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}
- (void)displayLinkAction:(CADisplayLink *)dis
{
    CALayer *sideHelperPresentationLayer = [helperSideView.layer presentationLayer];
    CALayer *centerHelperPresentationLayer = (CALayer *)[helperCenterView.layer presentationLayer];
    CGRect centerRect = [[centerHelperPresentationLayer valueForKeyPath:@"frame"]CGRectValue];
    CGRect siderRect = [[sideHelperPresentationLayer valueForKeyPath:@"frame"]CGRectValue];
    // 连个helperView的横坐标之差
    diff = siderRect.origin.x - centerRect.origin.x;
    [self setNeedsDisplay];
}
- (void)trigger
{
    if (!triggered) {
        [keyWindow insertSubview:blurView belowSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.bounds;
        }];
        
        [self beforeAnimation];
        [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState |UIViewAnimationOptionAllowUserInteraction animations:^{
            helperSideView.center = CGPointMake(keyWindow.center.x, helperSideView.height /2.f);
        } completion:^(BOOL finished) {
            //
            [self finishAnimation];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            blurView.alpha = 0.6;
        }];
        
        [self beforeAnimation];
        [UIView animateWithDuration:0.7f delay:0.f usingSpringWithDamping:0.8f initialSpringVelocity:2.f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            helperCenterView.center = keyWindow.center;
        } completion:^(BOOL finished) {
            //
            if (finished) {
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToUntrigger:)];
                [blurView addGestureRecognizer:tapGes];
                [self finishAnimation];
            }
        }];
        [self animateButtons];
        triggered = YES;
    } else {
        [self tapToUntrigger:nil];
    }
}
- (void)animateButtons
{
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIView *menuButton = self.subviews[i];
        menuButton.transform = CGAffineTransformMakeTranslation(-90, 0);
        [UIView animateWithDuration:0.7f delay:i *(0.3 /self.subviews.count) usingSpringWithDamping:0.6f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction  animations:^{
            menuButton.transform = CGAffineTransformIdentity;
            _isOpeningMenu = NO;
        } completion:^(BOOL finished) {
            NSLog(@"animation  ended!!!");
        }];
    }
}
- (void)tapToUntrigger:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(-keyWindow.width / 2 - EXTRAAREA, 0, keyWindow.width / 2 + EXTRAAREA, keyWindow.height);
    }];
    [self beforeAnimation];
  
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        helperSideView.center = CGPointMake(-helperSideView.frame.size.height/2, helperSideView.frame.size.height/2);
        
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        blurView.alpha = 0.0f;
        
    }];
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        helperCenterView.center = CGPointMake(-helperSideView.frame.size.height/2, CGRectGetHeight(keyWindow.frame)/2);
        
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    [self showAnimation];
    _curveView.frame = CGRectMake(0, SCREENHEIGHT / 2.f, 3, 3);
    [self  updateShaperLayerPath];
    [self calculatePath];
    triggered = NO;
}
- (void)showAnimation
{
    //菜单关闭时的弹黄动效
    [self beginAnimation];
    [UIView animateWithDuration:3.f delay:0.f usingSpringWithDamping:0.1f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // 曲线点(r5点)是一个view.所以在block中有弹簧效果.然后根据他的动效路径,在calculatePath中计算弹性图形的形状
        _curveView.frame = CGRectMake(0, SCREENHEIGHT /2.f, 3, 3);
    } completion:^(BOOL finished) {
        if (finished) {
            _isAnimating = NO;
            _isOpeningMenu = NO;
            [self finishAnimation];
        }
    }];
 
}
- (void)beginAnimation
{
    // CADisplayLink默认每秒运行60次calculatePath是算出在运行期间_curveView的坐标，从而确定_shapeLayer的形状
    if (self.displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calculatePath)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount ++;
}
- (void)calculatePath
{
    // 由于手势结束时,r5执行了一个UIView的弹簧动画,把这个过程的坐标记录下来,并相应的画出_shapeLayer形状
    CALayer *layer = _curveView.layer.presentationLayer;
    self.curveX = layer.position.x;
    self.curveY = layer.position.y;
}
- (void)addButtons:(NSArray *)titles
{
    if ((titles.count & 1) == 0) {
        NSInteger  index_down = titles.count / 2;
        NSInteger index_up = -1;
        for (NSInteger i = 0; i < titles.count; i++) {
            SLLYMenuButton *menuBtn = [[SLLYMenuButton alloc]initWithTitle:titles[i]];
            if (i >= titles.count / 2) {
                index_up ++;
                menuBtn.center = CGPointMake(keyWindow.width / 4.f, keyWindow.height / 2.f + self.menuButtonHeight *index_up + SPACE *index_up + SPACE /2 + self.menuButtonHeight / 2.f);
            } else {
                index_down --;
                menuBtn.center = CGPointMake(keyWindow.width / 4.f, keyWindow.height / 2.f - self.menuButtonHeight *index_down - SPACE *index_down - SPACE /2 - self.menuButtonHeight / 2.f);
            }
            
            
            menuBtn.bounds = CGRectMake(0, 0, keyWindow.width /2 - 20 *2, self.menuButtonHeight);
            menuBtn.btnColor = _menuColor;
            [self addSubview:menuBtn];
            NSLog(@"%@",NSStringFromCGRect(menuBtn.frame));
            __weak typeof (self) weakSelf = self;
            menuBtn.buttonClickBlock = ^(){
                [self tapToUntrigger:nil];
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
                [self tapToUntrigger:nil];
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
            // 手势移动时，_shapeLayer跟着手势向下扩大区域
            CGPoint point = [pan translationInView:self];
            // 这部分代码使r5红点跟着手势走
            self.curveX = point.x;
            self.curveY = SCREENHEIGHT /2.0;
            _curveView.frame = CGRectMake(_curveX, _curveY, _curveView.width, _curveView.height);
            if (point.x > 80.0f && !_isOpeningMenu) {
                [self trigger];
                _isOpeningMenu = YES;
            }
        }else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed)
        {
            // 手势结束时,_shapeLayer返回原状并产生弹簧动效
            _isAnimating = YES;
            [self showAnimation];
        }
    }
}

- (void)updateShaperLayerPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, SCREENHEIGHT)];
    [path addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:CGPointMake(_curveX, _curveY)];// r3,r4,r5确定的一个弧线
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

#pragma mark --remove
-(void)dealloc
{
    [self removeObserver:self forKeyPath:kX];
    [self removeObserver:self forKeyPath:kY];
}

@end
