//
//  DiaryViewController.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/31.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "DiaryViewController.h"
#import "CalendarViewController.h"
#import "DiaryMenuView.h"
#import "EditDiaryViewController.h"

@interface DiaryViewController ()<UITableViewDelegate,UITableViewDataSource,DiaryMenuViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation DiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日记";
    [self setLeftBtn];
    [self setupUITableView];
    [self setupDiaryMenu];
}

#pragma mark - UI
- (void)setupUITableView
{
    // addTableView
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49) style:UITableViewStylePlain];
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleWidth;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.showsHorizontalScrollIndicator = NO;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.opaque = NO;
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.backgroundView = nil;
    self.myTableView.separatorColor = UITableViewCellSeparatorStyleNone;
    self.myTableView.bounces = YES;
    
    // 右侧索引
    self.myTableView.sectionIndexColor = [UIColor redColor];
    self.myTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //self.myTableView.sectionIndexTrackingBackgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.myTableView];
    
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.myTableView setTableFooterView:view];
}
- (void)setLeftBtn
{
    [self setLeftNavigationBarWithImage:[UIImage imageNamed:@"Calendar"] andTarget:self andAction:@selector(presentCalendar) andTag:0];
}
- (void)setupDiaryMenu
{
    DiaryMenuView *menuView = [[DiaryMenuView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - 49, SCREENWIDTH, 49)];
    menuView.delegate = self;
    [self.view addSubview:menuView];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DiaryCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"shoucang.png"];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.textLabel.text = @"收藏";
    } else if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"dizhi.png"];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.textLabel.text = @"地址";
        
    } else if (indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"comiisfariji.png"];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.textLabel.text = @"日记";
    }else if (indexPath.row == 3){
        cell.imageView.image = [UIImage imageNamed:@"hongbao.png"];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.textLabel.text = @"红包";
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark --DiaryMenuViewDelegate
-(void)pushEditViewController
{
    EditDiaryViewController *editVC = [[EditDiaryViewController alloc]init];
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark -- Action
- (void)presentCalendar
{
    [self.navigationController pushViewController:[[CalendarViewController alloc]init] animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
