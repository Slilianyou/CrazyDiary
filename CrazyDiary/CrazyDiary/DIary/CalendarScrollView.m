//
//  CalendarScrollView.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/31.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "CalendarScrollView.h"
#import "CalendarScrollViewCell.h"

@interface CalendarScrollView ()
@property (nonatomic, strong) NSMutableArray *visiableCells;
@property (nonatomic, strong) NSMutableDictionary *reusableTableCells;
@property (nonatomic, strong) UIView *subViewContainerView;
@end

@implementation CalendarScrollView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        self.contentSize = CGSizeMake(self.frame.size.width, 8000);
        _visiableCells = [NSMutableArray arrayWithCapacity:0];
        _reusableTableCells = [[NSMutableDictionary alloc]initWithCapacity:2];
        _subViewContainerView = [[UIView alloc]init];
        self.subViewContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        [self addSubview:self.subViewContainerView];
        [self.subViewContainerView setUserInteractionEnabled:YES];
        [self setShowsVerticalScrollIndicator:NO];
    }
    return self;
}

#pragma mark - Action
// 实现无限滚动
- (void)recenterIFNeccessary
{
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentHeight = [self contentSize].height;
    CGFloat centerOffsetY = (contentHeight - [self bounds].size.height) / 2.f;
    CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetY);
    if (distanceFromCenter > (contentHeight / 4.f)) {
        self.contentOffset = CGPointMake(currentOffset.x, centerOffsetY);
        
        for (UIView *view in self.visiableCells) {
            CGPoint center = [self.subViewContainerView convertPoint:view.center toView:self];
            center.y += (centerOffsetY - currentOffset.y);
            view.center = [self convertPoint:center toView:self.subViewContainerView];
        }
    }
}


#pragma mark --Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self recenterIFNeccessary];
    
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.subViewContainerView];
    CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
    CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);
    
    for (CalendarScrollViewCell *cell in self.visiableCells) {
        if (fabs(cell.frame.origin.y - minimumVisibleY) < 20) {
            [self.delegateForCell boundlessScrollViewArriveTopVisible:cell.deviation];
        }
    }
    
    [self  titleLabelsFromMinY:minimumVisibleY toMaxY:maximumVisibleY];
}
- (void)titleLabelsFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY
{
    
    // 确保至少有一个label
    if ([self.visiableCells count] == 0) {
        [self placeNewViewOnBottom:minimumVisibleY];
    }
    
    // add labels that are missing on right side
    CalendarScrollViewCell *lastCell = [self.visiableCells lastObject];
    CGFloat bottomEdge = CGRectGetMaxY([lastCell frame]);
    while (bottomEdge < maximumVisibleY) {
        bottomEdge = [self placeNewViewOnBottom:bottomEdge];
    }
    
    CalendarScrollViewCell *firstCell = self.visiableCells[0];
    CGFloat topEdge = CGRectGetMinY([firstCell frame]);
    while (topEdge > minimumVisibleY) {
        topEdge = [self placeNewViewOnTop:topEdge];
    }
    
    // 删除已脱落右边缘的标签
     // remove labels that have fallen off right edge
    lastCell = [self.visiableCells lastObject];
    while ([lastCell frame].origin.y > maximumVisibleY) {
        [lastCell removeFromSuperview];
        [self.visiableCells removeLastObject];
        [self addReusableTableCellsObject:lastCell];
        lastCell = [self.visiableCells lastObject];
    }
       // remove labels that have fallen off left edge
    firstCell = self.visiableCells[0];
    while (CGRectGetMaxY([firstCell frame]) < minimumVisibleY) {
        [firstCell removeFromSuperview];
        [self.visiableCells removeObjectAtIndex:0];
        [self addReusableTableCellsObject:firstCell];
        firstCell = self.visiableCells[0];
    }
}
- (CGFloat)placeNewViewOnBottom:(CGFloat)bottomEdge
{
    // 偏离
    NSInteger deviation = [self getMaxDeviationInVisiableCells];
    CalendarScrollViewCell *cell = [self insertCell:deviation];
    [self.visiableCells addObject:cell];
    
    CGRect frame = [cell frame];
    frame.origin.y = bottomEdge;
    frame.origin.x = [self.subViewContainerView bounds].size.width -frame.size.width;
    if ([self.delegateForCell respondsToSelector:@selector(calendarScrollViewCellHeightWithDeviation:calendarScrollView:)]) {
        CGFloat height = [self.delegateForCell calendarScrollViewCellHeightWithDeviation:deviation calendarScrollView:self];
        frame.size.height = height;
    }
    [cell setFrame:frame];
    return CGRectGetMaxY(frame);
}
//
- (CGFloat)placeNewViewOnTop:(CGFloat)topEdge
{
    NSInteger deviation = [self getMinDeviationInVisiableCells];
    CalendarScrollViewCell *cell = [self insertCell:deviation];
    [self.visiableCells insertObject:cell atIndex:0]; // add leftmost label at the beginning of the array
    CGRect frame = [cell frame];
    if ([self.delegateForCell respondsToSelector:@selector(calendarScrollViewCellHeightWithDeviation:calendarScrollView:)]) {
        CGFloat height = [self.delegateForCell calendarScrollViewCellHeightWithDeviation:deviation calendarScrollView:self];
        frame.size.height = height;
        NSLog(@"height:%g",height);
    }
    frame.origin.y = topEdge - frame.size.height;
    frame.origin.x = [self.subViewContainerView bounds].size.width - frame.size.width;
    
    [cell setFrame:frame];
    
    return CGRectGetMinY(frame);
}

//TODO:获取最大偏离数
- (NSInteger)getMaxDeviationInVisiableCells
{
    if (self.visiableCells.count <= 0) {
        return 0;
    }
    
    CalendarScrollViewCell *cell = (CalendarScrollViewCell *)self.visiableCells[0];
    NSInteger deviation = cell.deviation;
    for (CalendarScrollViewCell *cell in self.visiableCells) {
        if (deviation < cell.deviation) {
            deviation = cell.deviation;
        }
    }
    return ++deviation;
}

-(NSInteger)getMinDeviationInVisiableCells
{
    if (self.visiableCells.count <= 0) {
        return 0;
    }
    CalendarScrollViewCell *cell = (CalendarScrollViewCell *)self.visiableCells[0];
    NSInteger deviation = cell.deviation;
    for (CalendarScrollViewCell *cell in self.visiableCells) {
        if (deviation > cell.deviation) {
            deviation = cell.deviation;
        }
    }
    return --deviation;
}
#pragma mark - Label Tiling 平铺
- (CalendarScrollViewCell *)insertCell:(NSInteger)deviation
{
    CalendarScrollViewCell *cell = [self.delegateForCell  calendarScrollViewCellWithDeviation:deviation calendarScrollView:self];
    cell.deviation = deviation;
    [self.subViewContainerView addSubview:cell];
    return cell;
}

#pragma mark---Method
- (void)addReusableTableCellsObject:(CalendarScrollViewCell *)cell
{
    NSString *identifier = cell.identifier;
    NSMutableArray *mutableArray = [self.reusableTableCells objectForKey:identifier];
    if (mutableArray == nil) {
        mutableArray = [[NSMutableArray alloc]initWithCapacity:10];
        [self.reusableTableCells setObject:mutableArray forKey:identifier];
    }
    [mutableArray addObject:cell];
}

- (CalendarScrollViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSMutableArray *cellArray = [self.reusableTableCells objectForKey:identifier];
    if (cellArray.count <= 0) {
        return nil;
    }
    CalendarScrollViewCell *cell = [cellArray objectAtIndex:0];
    [cellArray removeObject:cell];
    return cell;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray *array = [touches allObjects];
    for (UITouch *touch in array) {
        if ([touch.view isKindOfClass:[CalendarScrollViewCell class]]) {
            CalendarScrollViewCell* cell = (CalendarScrollViewCell *)(touch.view);
            if ([self.delegateForCell respondsToSelector:@selector(didSelectedWithDeviation:calendarScrollView:)]) {
                [self.delegateForCell didSelectedWithDeviation:cell.deviation calendarScrollView:self];
            }

        }
    }
}


















































@end
