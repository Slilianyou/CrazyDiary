//
//  CalendarViewController.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/31.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarScrollView.h"
#import "CalendarScrollViewCell.h"
#import "GradientView.h"
#import "CellDateModel.h"
#import "DateTools.h"

@interface CalendarViewController ()<CalendarScrollViewDelegate>
{
    GradientView * _tipView;
}
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日历📅";

    [self.view addSubview:[self getTitleView]];
    
    CalendarScrollView *calendarView = [[CalendarScrollView alloc]initWithFrame:CGRectMake(0, 84, SCREENWIDTH, SCREENHEIGHT - 84)];
    calendarView.backgroundColor = [UIColor whiteColor];
    calendarView.decelerationRate = 1.f;
    calendarView.delegateForCell = self;
    [self.view addSubview:calendarView];
    
}

- (UIView *)getTitleView
{
    NSArray *titleArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 20) / 7;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 20)];
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i *width + 10, 0, width, 20)];
        label.text = titleArray[i];
        label.font = [UIFont systemFontOfSize:11.0];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
    }
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (GradientView *)getTipLabel:(NSString *)string
{
    if (!_tipView) {
        _tipView = [[GradientView alloc]initWithFrame:CGRectMake(0, 84, SCREENWIDTH, 50)];
        _tipView.backgroundColor = [UIColor redColor];
        _tipView.hidden = YES;
        
        // UILabel
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,35)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.f];
        label.tag = 100;
        [_tipView addSubview:label];
//        _tipView.alpha = 0.6f;
        [self.view addSubview:_tipView];
    }
    UILabel *label = (UILabel *)[_tipView viewWithTag:100];
    label.text = string;
    return _tipView;
}

#pragma mark -- CalendarScrollViewDelegate
- (CalendarScrollViewCell *)calendarScrollViewCellWithDeviation:(NSInteger)deviation calendarScrollView:(CalendarScrollView *)calendarScrollView
{
    static NSString *cellID = @"cellID";
    CalendarScrollViewCell *cell = [calendarScrollView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[CalendarScrollViewCell alloc]initWithIdentifier:cellID];
    }
    
    dispatch_async(dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //
        CellDateModel *cellDateModel = [DateTools dateToCell:deviation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell fillDate:cellDateModel];
        });
    });
    
    return  cell;
}

- (CGFloat)calendarScrollViewCellHeightWithDeviation:(NSInteger)deviation calendarScrollView:(CalendarScrollView *)calendarScrollView
{
    NSInteger row = [DateTools getDrawRow:deviation];
    CGFloat width = (SCREENWIDTH - 20) / 7.0;
    
    return (width + 15)*row + 10 + 30;
}
-(void)boundlessScrollViewArriveTopVisible:(NSInteger)deviation
{
    NSDateComponents *components = [DateTools getCellMonthDate:deviation];
    NSString *string = [NSString stringWithFormat:@"%ld年%ld月",(long)[components year],(long)[components month]];
    _tipView = [self getTipLabel:string];
    if (_tipView.hidden == YES) {
        _tipView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _tipView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 animations:^{
                _tipView.alpha = 0.6;
            }completion:^(BOOL finished) {
                _tipView.hidden = YES;
            }];
        }];
    }
}

-(void)didSelectedWithDeviation:(NSInteger)deviation calendarScrollView:(CalendarScrollView *)calendarScrollView
{
      NSLog(@"%ld",(long)deviation);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


























@end
