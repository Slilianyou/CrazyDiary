//
//  SLLYMenuView.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/16.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void (^MenuButtonCallBack)(NSInteger index,NSString *title, NSInteger titleCounts);

@interface SLLYMenuView : UIView
@property (nonatomic, copy) MenuButtonCallBack  menuClickBlock;
- (id)initWithTitles:(NSArray *)titles;
- (id)initWithTitles:(NSArray *)titles withButtonHeight:(CGFloat)height withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style;






























@end
