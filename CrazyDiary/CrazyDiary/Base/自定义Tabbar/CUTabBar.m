//
//  CUTabBar.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/9/9.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "CUTabBar.h"
#import "UIImage+Image.h"

#define kMargin 10

@implementation CUTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        [self setShadowImage:[UIImage imageWithColor:[UIColor whiteColor]]];
        self.plusBtn.backgroundColor = [UIColor clearColor];
        [self.plusBtn setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
        [self.plusBtn addTarget:self action:@selector(plusBtnClicke:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.plusBtn];
    }
    return self;
}

// 懒加载
- (UIButton *)plusBtn
{
    if (!_plusBtn) {
        _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _plusBtn;
}
#pragma mark --Action
- (void)plusBtnClicke:(UIButton *)sender
{
    if ([self.mydelegate respondsToSelector:@selector(tabBarPlusBtnClick:)]) {
        [self.mydelegate tabBarPlusBtnClick:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    self.plusBtn.centerX = self.centerX;
    //调整发布按钮的中线点Y值
    self.plusBtn.centerY = self.height *0.5f - 2*kMargin;
    self.plusBtn.size = CGSizeMake(self.plusBtn.currentBackgroundImage.size.width, self.plusBtn.currentBackgroundImage.size.height);
    UILabel *label = [[UILabel alloc]init];
    label.text = @"发布";
    label.font = [UIFont systemFontOfSize:11];
    [label sizeToFit];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.centerX = self.plusBtn.centerX;
    label.centerY = CGRectGetMaxY(self.plusBtn.frame) + kMargin;
    [self addSubview:label];
    
    int btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            //每一个按钮的宽度==tabbar的五分之一
            btn.width = self.width / 3.f;
            btn.x = btn.width *btnIndex;
            btnIndex++;
            
            if (btnIndex == 1) {
                btnIndex ++;
            }
        }
    }
    [self bringSubviewToFront:self.plusBtn];
}

//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
     //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
     //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了

    if (self.isHidden == NO) {
         //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.plusBtn];
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ([self.plusBtn pointInside:newP withEvent:event]) {
            return self.plusBtn;
        }else {//如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    } else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return  [super hitTest:point withEvent:event];
    }
}



@end
