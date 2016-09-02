//
//  DateView.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/9/1.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DateModel;
@interface DateView : UIView
@property (nonatomic, strong) UILabel *solarCalendarLabel; // 阳历
@property (nonatomic, strong) UILabel *lunarCalendarLabel; //阴历
@property (nonatomic, strong) DateModel *dateModel;

- (void)fillDate:(DateModel *)dateModel;




























@end
