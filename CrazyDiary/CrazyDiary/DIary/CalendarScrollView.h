//
//  CalendarScrollView.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/31.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarScrollViewCell;
@class CalendarScrollView;


@protocol CalendarScrollViewDelegate <NSObject>

- (CalendarScrollViewCell *)calendarScrollViewCellWithDeviation:(NSInteger)deviation calendarScrollView:(CalendarScrollView *)calendarScrollView;
@optional
- (CGFloat)calendarScrollViewCellHeightWithDeviation:(NSInteger)deviation calendarScrollView:(CalendarScrollView *)calendarScrollView;
- (void)didSelectedWithDeviation:(NSInteger)deviation calendarScrollView:(CalendarScrollView *)calendarScrollView;
- (void)boundlessScrollViewArriveTopVisible:(NSInteger)deviation;

@end

@interface CalendarScrollView : UIScrollView
@property (nonatomic, assign) id <CalendarScrollViewDelegate> delegateForCell;
- (CalendarScrollViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;




















@end
