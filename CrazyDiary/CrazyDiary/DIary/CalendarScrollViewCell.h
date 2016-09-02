//
//  CalenderScrollViewCell.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/31.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellDateModel;
@interface CalendarScrollViewCell : UIView
@property (nonatomic, assign) NSInteger deviation;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) UILabel *label;
- (instancetype)initWithIdentifier:(NSString *)identifier;
- (void)fillDate:(CellDateModel *)cellDateModel;
























@end
