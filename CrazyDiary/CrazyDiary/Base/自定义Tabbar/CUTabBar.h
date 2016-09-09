//
//  CUTabBar.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/9/9.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CUTabBar;
@protocol CUTabBarDelegate <NSObject>

@optional
- (void)tabBarPlusBtnClick:(CUTabBar *)tabBar;

@end
@interface CUTabBar : UITabBar
@property (nonatomic, weak) id<CUTabBarDelegate> mydelegate;
@property (nonatomic, strong) UIButton *plusBtn;


@end
