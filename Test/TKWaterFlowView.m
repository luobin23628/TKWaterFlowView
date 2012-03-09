

#import <QuartzCore/QuartzCore.h>
#import "TKWaterFlowView.h"

#define kTKCellDefaultHeight 100

@implementation TKWaterFlowViewCell

    

@end

@implementation TKWaterFlowView
@synthesize containerView;
@synthesize dataSource;
@synthesize numberOfCells;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.alwaysBounceVertical = YES;
        
        // we will recycle cells by removing them from the view and storing them here
        reusableCells = [[NSMutableSet alloc] init];
        heights = [[NSMutableArray alloc] init];
        
        // we need a cell container view to hold all the cells. This is the view that is returned
        // in the -viewForZoomingInScrollView: delegate method, and it also detects taps.
        containerView = [[UIView alloc] initWithFrame:CGRectZero];
        [containerView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:containerView];
        
        // no rows or columns are visible at first; note this by making the firsts very high and the lasts very low
        firstVisibleIndex = NSIntegerMax;
        lastVisibleIndex = NSIntegerMin;
        
        // the celldScrollView is its own UIScrollViewDelegate, so we can handle our own zooming.
        // We need to return our cellContainerView as the view for zooming, and we also need to receive
        // the scrollViewDidEndZooming: delegate callback so we can update our resolution.
        [super setDelegate:self];
    }
    return self;
}

- (void)dealloc {
    [heights release];
    [reusableCells release];
    [containerView release];
    [super dealloc];
}

- (TKWaterFlowViewCell *)dequeueReusableCell {
    TKWaterFlowViewCell *cell = [reusableCells anyObject];
    if (cell) {
        // the only object retaining the cell is our reusablecells set, so we have to retain/autorelease it
        // before returning it so that it's not immediately deallocated when we remove it from the set
        [[cell retain] autorelease];
        [reusableCells removeObject:cell];
    }
    return cell;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
}

- (void)reloadData {
    // recycle all cells so that every cell will be replaced in the next layoutSubviews
    for (TKWaterFlowViewCell *view in [containerView subviews]) {
        [reusableCells addObject:view];
        [view removeFromSuperview];
    }
    
    [heights removeAllObjects];
    numberOfCells = [self.dataSource numberOfRowsInWaterFlowView:self];
    
    if ([self.delegate respondsToSelector:@selector(waterFlowView:heightForCellAtIndex:)]) {
        for (int i = 0; i < numberOfCells; i++) {
            NSUInteger height = [self.delegate waterFlowView:self heightForCellAtIndex:i];
            [heights addObject:[NSNumber numberWithDouble:height]];
        }
    } else {
        for (int i = 0; i < numberOfCells; i++) {
            [heights addObject:[NSNumber numberWithDouble:kTKCellDefaultHeight]];
        }
    }
    
    // no rows or columns are now visible; note this by making the firsts very high and the lasts very low
    firstVisibleIndex = NSIntegerMax;
    lastVisibleIndex = NSIntegerMin;
    
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect visibleBounds = CGRectMake(0, self.contentOffset.y, self.bounds.size.width, self.bounds.size.height);
    
    // first recycle all cells that are no longer visible
    for (TKWaterFlowViewCell *cell in [containerView subviews]) {
        
        // If the cell doesn't intersect, it's not visible, so we can recycle it
        if (! CGRectIntersectsRect(cell.frame, visibleBounds)) {
            [reusableCells addObject:cell];
            [cell removeFromSuperview];
        }
    }
    
    int firstNeededRow = NSIntegerMax;
    int lastNeededRow  = NSIntegerMin;
    
    CGFloat leftHeight = 0, middleHeight = 0, rightHeight = 0;
    // iterate through needed rows, adding any cells that are missing
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
        
        CGRect rect = CGRectMake(col*100, mininum, 100, height);
        if (CGRectIntersectsRect(visibleBounds, rect)) {
            
            if (lastNeededRow == NSIntegerMin || row > lastNeededRow) {
                lastNeededRow = row;
            }
            
            if (firstNeededRow == NSIntegerMax) {
                firstNeededRow = row;
            }
            
            BOOL cellIsMissing = (firstVisibleIndex > row || lastVisibleIndex  < row);
            
            if (cellIsMissing) {
                TKWaterFlowViewCell *cell = [dataSource waterFlowView:self cellAtIndex:row];
                
                // set the cell's frame so we insert it at the correct position
                [cell setFrame:rect];
                [containerView addSubview:cell];
            }
        }
    }
    
    NSLog(@"firstNeededRow == %d, lastNeededRow == %d", firstNeededRow, lastNeededRow);
    
    CGFloat contentHeight = MAX(leftHeight, MAX(middleHeight, rightHeight));
    CGRect contentRect = CGRectMake(0, 0, self.frame.size.width, contentHeight);
    if (!CGRectEqualToRect(containerView.frame, contentRect)) {
        [containerView setFrame:contentRect];
        self.contentSize = CGSizeMake(self.frame.size.width, contentHeight);
    }
    
    //    contentHeight = MAX(contentHeight, self.bounds.size.height);
    
    // update our record of which rows are visible
    firstVisibleIndex = firstNeededRow;
    lastVisibleIndex  = lastNeededRow;     
    
}
@end
