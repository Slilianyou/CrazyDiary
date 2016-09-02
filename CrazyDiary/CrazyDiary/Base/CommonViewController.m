//
//  CommonViewController.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/15.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)viewDidLoad {
    DataHandleTool *tool = [DataHandleTool manage];
    [tool loadData];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)setLeftNavigationBarWithImage:(UIImage *)backImage andTarget:(id)target andAction:(SEL)targetAction andTag:(int)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 22, 22);
    [btn setImage:backImage forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:target action:targetAction forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (IOSversion >= 7.0) {
        space.width =-10;
    }
    NSArray *itemArr = [NSArray arrayWithObjects:space,item, nil];
    self.navigationItem.leftBarButtonItems = itemArr;

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
