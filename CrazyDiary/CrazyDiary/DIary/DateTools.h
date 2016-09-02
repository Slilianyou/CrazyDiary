//
//  DateTools.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/9/1.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CellDateModel;
@interface DateTools : NSObject
+ (CellDateModel *)dateToCell:(NSInteger)deviation;
+ (NSDateComponents *)getCellMonthDate:(NSInteger)deviation;
+ (NSDateComponents *)getCurrentDate;
+ (NSInteger)getDrawRow:(NSInteger)deviation;























@end
