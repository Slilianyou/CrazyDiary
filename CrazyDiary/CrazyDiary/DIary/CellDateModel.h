//
//  CellDateModel.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/9/1.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DateModel;
@interface CellDateModel : NSObject
@property (nonatomic, strong) NSArray <__kindof DateModel *> *dateModelArray;
@property (nonatomic, assign) NSInteger drawDayBeginIndex;
@property (nonatomic, assign) NSInteger drawDayRow;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger monthDays;
@property (nonatomic, assign) NSInteger beginWeekDay;






















@end
