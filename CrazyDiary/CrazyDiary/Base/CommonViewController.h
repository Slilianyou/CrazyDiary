//
//  CommonViewController.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/15.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonViewController : UIViewController
#pragma mark --Method
- (void)setLeftNavigationBarWithImage:(UIImage *)backImage andTarget:(id)target andAction:(SEL)targetAction andTag:(int)tag;
@end
