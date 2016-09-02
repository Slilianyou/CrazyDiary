//
//  DateModel.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/9/1.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateModel : NSObject
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger weekday;
@property (nonatomic, copy) NSString *lunarDay; // 阴历



@end
