//
//  DiaryViewController.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/31.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "DiaryViewController.h"
#import "CalendarViewController.h"



@interface DiaryViewController ()

@end

@implementation DiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日记";
    self.view.backgroundColor = [UIColor redColor];
    //

    
    
    [self setLeftBtn];
    // Do any additional setup after loading the view.
}

- (void)setLeftBtn
{
    [self setLeftNavigationBarWithImage:[UIImage imageNamed:@"Calendar"] andTarget:self andAction:@selector(presentCalendar) andTag:0];
}

- (void)presentCalendar
{
    [self.navigationController pushViewController:[[CalendarViewController alloc]init] animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
