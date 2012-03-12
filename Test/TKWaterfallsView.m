

//
//  TKWaterFlowView.m
//  HHelloCat
//
//  Created by luobin on 12-38.
//  Copyright (c) __MyCompanyName__. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "TKWaterfallsView.h"

#define kTKCellDefaultHeight 100

@implementation TKWaterfallsViewCell

- (void)prepareForReuse
{
    
}

@end

@implementation TKWaterfallsView
@synthesize containerView;
@synthesize dataSource;
@synthesize numberOfCells;
@synthesize delegate;
@synthesize headerView;
@synthesize footerView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.alwaysBounceVertical = YES;
        
        reusableCells = [[NSMutableSet alloc] init];
        heights = [[NSMutableArray alloc] init];
        visibleCellIndexes  = [[NSMutableSet alloc] init];
        
        containerView = [[UIView alloc] initWithFrame:CGRectZero];
        [containerView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:containerView];
    }
    return self;
}

- (void)dealloc {
    self.headerView = nil;
    self.footerView = nil;
    [heights release];
    [reusableCells release];
    [containerView release];
    [super dealloc];
}

- (void)setDelegate:(id<TKWaterfallsViewDelegate>)theDelegate
{
    [super setDelegate:theDelegate];
    delegate = theDelegate;
}

- (TKWaterfallsViewCell *)dequeueReusableCell {
    TKWaterfallsViewCell *cell = [reusableCells anyObject];
    if (cell) {
        [[cell retain] autorelease];
        [reusableCells removeObject:cell];
    }
    return cell;
}

- (void)setHeaderView:(UIView *)theHeaderView
{
    [self addSubview:theHeaderView];
    headerView = theHeaderView;
}

- (void)setFooterView:(UIView *)theFooterView
{
    [self addSubview:theFooterView];
    footerView = theFooterView;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
}

- (void)reloadData {
    // 重用所有cell
    
    for (TKWaterfallsViewCell *view in self.visibleCells) {
        [reusableCells addObject:view];
        [view removeFromSuperview];
    }
    [visibleCellIndexes removeAllObjects];
    [heights removeAllObjects];
    numberOfCells = [self.dataSource numberOfRowsInWaterfallsView:self];
    
    if ([self.delegate respondsToSelector:@selector(waterfallsView:heightForCellAtIndex:)]) {
        for (int i = 0; i < numberOfCells; i++) {
            NSUInteger height = [self.delegate waterfallsView:self heightForCellAtIndex:i];
            [heights addObject:[NSNumber numberWithDouble:height]];
        }
    } else {
        for (int i = 0; i < numberOfCells; i++) {
            [heights addObject:[NSNumber numberWithDouble:kTKCellDefaultHeight]];
        }
    }
    
    [self setNeedsLayout];
}

- (NSArray *)visibleCells
{
    return [containerView subviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect visibleBounds = CGRectMake(0, self.contentOffset.y, self.bounds.size.width, self.bounds.size.height);
    
    // 重用不可见的cell
    for (TKWaterfallsViewCell *cell in self.visibleCells) {
        
        if (! CGRectIntersectsRect(cell.frame, visibleBounds)) {
            [reusableCells addObject:cell];
            [cell removeFromSuperview];
        }
    }
    
    CGFloat colWidth = self.frame.size.width/3;
    
    CGFloat leftHeight = 0, middleHeight = 0, rightHeight = 0;
    
    NSMutableSet *theVisibleCellIndexes = [NSMutableSet set];
    
    //循环cell，计算出新增的cell
    for (NSUInteger row = 0; row < numberOfCells; row++) {
        
        int col = 0;
        double height = [[heights objectAtIndex:row] doubleValue];
        double mininum = MIN(leftHeight, MIN(middleHeight, rightHeight));
        if (leftHeight == mininum) {
            col = 0;
            leftHeight += height;
            
        } else if (middleHeight == mininum) {
            col = 1;
            middleHeight += height;
            
        } else if (rightHeight == mininum) {
            col = 2;
            rightHeight+=height;
        }
        
        CGRect rect = CGRectMake(col*colWidth, mininum, colWidth, height);
        
        if (CGRectIntersectsRect(visibleBounds, rect)) {
            
            [theVisibleCellIndexes addObject:[NSNumber numberWithUnsignedInteger:row]];

            BOOL cellIsMissing = ![visibleCellIndexes containsObject:[NSNumber numberWithUnsignedInteger:row]];
            
            if (cellIsMissing) {
                TKWaterfallsViewCell *cell = [dataSource waterfallsView:self cellAtIndex:row];
                
                // set the cell's frame so we insert it at the correct position
                [cell setFrame:rect];
                [containerView addSubview:cell];
            }
        }
    }
    [visibleCellIndexes release];
    visibleCellIndexes = [theVisibleCellIndexes retain];
    
    CGFloat contentHeight = MAX(leftHeight, MAX(middleHeight, rightHeight));
    CGRect contentRect = CGRectMake(0, 0, self.frame.size.width, contentHeight);
//    if (!CGRectEqualToRect(containerView.frame, contentRect)) {
        [containerView setFrame:contentRect];
        
        CGFloat heightForHeader = 0;
        if ([delegate respondsToSelector:@selector(heightForHeaderInWaterfallsView:)]) {
            heightForHeader = [delegate heightForHeaderInWaterfallsView:self];
        }
        
        CGFloat heightForFooter = 0;
        if ([delegate respondsToSelector:@selector(heightForFooterInWaterfallsView:)]) {
            heightForFooter = [delegate heightForFooterInWaterfallsView:self];
        }
        self.footerView.frame = CGRectMake(0, heightForHeader + contentHeight, self.frame.size.width, heightForFooter);
        
        self.contentSize = CGSizeMake(self.frame.size.width, heightForHeader + contentHeight + heightForFooter);
//    }
    
    //    contentHeight = MAX(contentHeight, self.bounds.size.height);
    
}
@end
