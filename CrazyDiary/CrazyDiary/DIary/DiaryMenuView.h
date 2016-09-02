//
//  DiaryMenuView.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/9/2.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiaryMenuViewDelegate <NSObject>

- (void)pushEditViewController;

@end
@interface DiaryMenuView : UIView
@property (nonatomic, assign) id<DiaryMenuViewDelegate> delegate;
@property (nonatomic, strong) UIButton *editBtn;
@end
