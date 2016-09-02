//
//  DiaryMenuView.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/9/2.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "DiaryMenuView.h"

@interface DiaryMenuView ()
{
    UILabel *_editLabel;
}
@end
@implementation DiaryMenuView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        _editBtn.backgroundColor = [UIColor redColor];
        [self addSubview:_editBtn];
        
        _editLabel = [[UILabel alloc]init];
        _editLabel.backgroundColor = [UIColor clearColor];
        _editLabel.textColor = [UIColor blackColor];
        _editLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_editLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_editBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _editBtn.frame = CGRectMake(0 , 0, 50.f,  50.f);
    _editBtn.center = CGPointMake(self.center.x, 0.f);
    _editBtn.layer.cornerRadius = 4.0f;
    _editBtn.layer.masksToBounds = YES;
    
    _editLabel.frame = CGRectMake(0, 0, 80, 20);
    _editLabel.center = CGPointMake(_editBtn.center.x, 12.f + 25.f);
    _editLabel.text = @"编辑";
}

- (void)buttonClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(pushEditViewController)]) {
        [self.delegate pushEditViewController];
    }
}









@end
