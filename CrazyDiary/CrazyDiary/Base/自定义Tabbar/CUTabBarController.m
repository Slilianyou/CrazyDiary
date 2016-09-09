//
//  CUTabBarController.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/9/9.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "CUTabBarController.h"
#import "DiarySettingViewController.h"
#import "DiaryUnLockViewController.h"
#import "CUUINavigationController.h"
#import "EditDiaryViewController.h"
#import "CUTabBar.h"


@interface CUTabBarController ()<CUTabBarDelegate>

@end

@implementation CUTabBarController
#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+(void)initialize
{
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];

    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictSelected[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11.f];
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11.f];
    
    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpALLChildVC];
    CUTabBar *tabBar = [[CUTabBar alloc]init];
    
    tabBar.mydelegate = self;
    tabBar.translucent = NO;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabBar forKey:@"tabBar"];

}

#pragma mark -  初始化tabBar上除了中间按钮之外所有的按钮
- (void)setUpALLChildVC
{
    DiarySettingViewController *settingVC = [[DiarySettingViewController alloc]init];
    [self setUpOneChildVcWtihVc:settingVC Image:@"setting" selectedImage:@"setting_selected" title:@"设置"];
    DiaryUnLockViewController *unLockVC = [[DiaryUnLockViewController alloc]init];
    [self setUpOneChildVcWtihVc:unLockVC Image:@"unlock" selectedImage:@"unlock_selected" title:@"解锁"];
}

#pragma mark -初始化设置tabBar上面单个按钮的方法
/**
 *  设置单个tabBarButton
 *
 *  @param Vc                 每一个按钮对应的控制器
 *  @param image              每一个按钮对应的普通状态下图片
 *  @param selectedImage      每一个按钮对应的选中状态下的图片
 *  @param title              每一个按钮对应的标题
 */
- (void)setUpOneChildVcWtihVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    CUUINavigationController *Navi = [[CUUINavigationController alloc]initWithRootViewController:Vc];
    Vc.view.backgroundColor = [self randomColor];
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.title = title;
    Vc.navigationItem.title = title;
    [self addChildViewController:Navi];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    
    return [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b /255.f alpha:1];
}

#pragma mark --CUTabBarDelegate
-(void)tabBarPlusBtnClick:(CUTabBar *)tabBar
{
    EditDiaryViewController *editVc = [[EditDiaryViewController alloc]init];
    editVc.view.backgroundColor = [self randomColor];
    CUUINavigationController *navi = [[CUUINavigationController alloc]initWithRootViewController:editVc];
    [self presentViewController:navi animated:YES completion:nil];
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
