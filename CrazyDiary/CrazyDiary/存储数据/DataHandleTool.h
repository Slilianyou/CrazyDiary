//
//  DataHandleTool.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/29.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHandleTool : NSObject
@property (nonatomic, strong) NSMutableArray *diaryList;
+ (id)manage;

//
- (void)loadData;
@end
