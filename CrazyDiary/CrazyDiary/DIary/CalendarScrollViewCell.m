//
//  CalenderScrollViewCell.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/31.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "CalendarScrollViewCell.h"
#import "CellDateModel.h"
#import "DateModel.h"
#import "DateView.h"

@implementation CalendarScrollViewCell
- (instancetype)initWithIdentifier:(NSString *)identifier
{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    self = [super initWithFrame:frame];
    if (self) {
        self.identifier = identifier;
    }
    return self;
}

- (void)fillDate:(CellDateModel *)cellDateModel
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = (self.frame.size.width - 20) /7.0f;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((cellDateModel.beginWeekDay - 1)*width, 5, width, 30)];
    label.text = [NSString stringWithFormat:@"%ld月",cellDateModel.month];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    [self addSubview:label];
    
    for (int i = 0; i < cellDateModel.monthDays; i++) {
        DateModel *dateModel = cellDateModel.dateModelArray[i];
        NSInteger column = dateModel.weekday;
        NSInteger row = (i + cellDateModel.drawDayBeginIndex) / 7;
        DateView *dateView = [[DateView alloc]initWithFrame:CGRectMake(column *width + 10, row *(width + 15)+ 5 + 30 + 5, width, width)];
        [dateView fillDate:dateModel];
        [self addSubview:dateView];
    }
 
}

-(void)setDeviation:(NSInteger)deviation
{
    _deviation = deviation;
}

















@end
