//
//  EditDiaryViewController.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/9/2.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "EditDiaryViewController.h"
#import "StudyHierarchy3D.h"




@interface EditDiaryViewController ()

@end

@implementation EditDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑日记";
    // 3D结构(funuy)
    [StudyHierarchy3D show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
