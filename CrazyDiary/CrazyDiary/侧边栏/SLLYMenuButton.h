//
//  SLLYMenuButton.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/19.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLLYMenuButton : UIView
@property (nonatomic, strong) UIColor *btnColor;
@property (nonatomic, copy) void (^buttonClickBlock)(void);
@property (nonatomic, assign) CGFloat titleFontSize;
- (instancetype)initWithTitle:(NSString *)title;
@end
