//
//  SLLYMenuViewController.h
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/16.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLLYMenuViewController : UIViewController
@property (nonatomic, strong) UIViewController *frontViewController;
@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, strong) UIView *frontViewContainer;
@property (nonatomic, strong) NSArray <UIViewController *>* viewControllersArr;
- (instancetype)initWithFrontView:(UIViewController *)frontView
                andButtonTitleArr:(NSArray *)titleArr;





















@end
