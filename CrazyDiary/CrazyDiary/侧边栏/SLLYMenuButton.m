//
//  SLLYMenuButton.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/19.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "SLLYMenuButton.h"

@interface SLLYMenuButton ()
@property (nonatomic, strong) NSString *buttonTitle;
@end
@implementation SLLYMenuButton
- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.buttonTitle = title;
    }
    return self;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSInteger tapCount = touch.tapCount;
    
    switch (tapCount) {
        case 1:
            self.buttonClickBlock();
            break;
            
        default:
            break;
    }
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, rect);
    [self.btnColor set];
    CGContextFillPath(context);
    
    
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1, 1) cornerRadius:rect.size.height / 2];
    [self.btnColor setFill];

    [roundedRectanglePath fill];
    [[UIColor whiteColor] setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle]mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attr = @{NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:_titleFontSize ? _titleFontSize : 18.f]};
    
    CGSize size = [self.buttonTitle sizeWithAttributes:attr];
    CGRect r = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - size.height)/2.f, rect.size.width, rect.size.height);
    [self.buttonTitle drawInRect:r withAttributes:attr];
}


@end
