//
//  SLLYMenuViewController.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/16.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "SLLYMenuViewController.h"
#import "SLLYMenuView.h"

@interface SLLYMenuViewController ()
@property (nonatomic, strong) SLLYMenuView *menuView;

@end

@implementation SLLYMenuViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _frontViewContainer = [[UIView alloc]init];
    }
    return self;
}

- (instancetype)initWithFrontView:(UIViewController *)frontView
                andButtonTitleArr:(NSArray *)titleArr
{
    self = [self init];
    if (self) {
        _frontViewController = frontView;
        _buttonTitles = titleArr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor greenColor];
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.frontViewContainer];
    [self creatMenuView];
    if (self.frontViewController) {
        [self setDefaultFrontView:self.frontViewController];
    }
}

- (void)creatMenuView
{
    _menuView = [[SLLYMenuView alloc]initWithTitles:self.buttonTitles];
    __block typeof(self) weakSelf  = self;
    _menuView.menuClickBlock = ^(NSInteger index,NSString *title, NSInteger titleCounts){
        NSLog(@"index : %ld\n title : %@\n titleCounts : %ld",(long)index,title,(long)titleCounts);
        if (weakSelf.viewControllersArr.count > 0) {
            [weakSelf changeViewControllerWithView:weakSelf.viewControllersArr[index]];
        }
    };
}

- (void)changeViewControllerWithView:(UIViewController *)viewController
{
    [self hideViewController:_frontViewController];
    _frontViewController = viewController;
    [self setDefaultFrontView:_frontViewController];
}

- (void)hideViewController:(UIViewController *)viewController
{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

- (void)setDefaultFrontView:(UIViewController *)frontViewController
{
    self.frontViewContainer.frame = self.view.bounds;
    self.frontViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addChildViewController:self.frontViewController];
    self.frontViewController.view.frame = self.view.bounds;
    [self.frontViewContainer addSubview:self.frontViewController.view];
    // 告诉iOS  视图控制器容器（self）已经完成添加子控制器的操作
    [self.frontViewController didMoveToParentViewController:self];
    
}
- (void)setFrontViewController:(UIViewController *)frontViewController
{
    if (_frontViewController == frontViewController) {
        return;
    }
    [self setDefaultFrontView:frontViewController];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
