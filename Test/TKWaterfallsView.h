


//
//  TKWaterFlowView.h
//  HHelloCat
//
//  Created by luobin on 12-38.
//  Copyright (c) __MyCompanyName__. All rights reserved.
//


@interface TKWaterfallsViewCell : UIView

- (void)prepareForReuse;

@end

@class TKWaterfallsView;
@class TKWaterfallsViewCell;

@protocol TKWaterfallsViewDataSource <NSObject>

- (NSInteger)numberOfRowsInWaterfallsView:(TKWaterfallsView *)waterfallsView;

- (TKWaterfallsViewCell *)waterfallsView:(TKWaterfallsView *)waterfallsView cellAtIndex:(NSUInteger)index;

@end


@protocol TKWaterfallsViewDelegate<UIScrollViewDelegate>

@optional

// Variable height support

- (CGFloat)waterfallsView:(TKWaterfallsView *)waterfallsView heightForCellAtIndex:(NSUInteger)index;
- (CGFloat)heightForHeaderInWaterfallsView:(TKWaterfallsView *)waterfallsView;
- (CGFloat)heightForFooterInWaterfallsView:(TKWaterfallsView *)waterfallsView;

// Display customization

/* todo 
- (void)waterFlowView:(TKWaterFlowView *)waterFlowView willDisplayCell:(TKWaterFlowViewCell *)cell forRowAtIndex:(NSUInteger)index;

// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSUInteger)waterFlowView:(TKWaterFlowView *)waterFlowView willSelectRowAtIndex:(NSUInteger)index;
- (NSUInteger)waterFlowView:(TKWaterFlowView *)waterFlowView willDeselectRowAtIndex:(NSUInteger)index;

// Called after the user changes the selection.
- (void)waterFlowView:(TKWaterFlowView *)waterFlowView didSelectRowAtIndex:(NSUInteger)index;
- (void)waterFlowView:(TKWaterFlowView *)waterFlowView didDeselectRowAtIndex:(NSUInteger)index;
*/
@end


@interface TKWaterfallsView : UIScrollView{
    id <TKWaterfallsViewDataSource>  dataSource;
    UIView                          *containerView;
    NSMutableSet                    *reusableCells;    
    NSMutableArray                  *heights;
    NSMutableSet                    *visibleCellIndexes;
}

@property (nonatomic, assign) id <TKWaterfallsViewDataSource> dataSource;
@property (nonatomic, assign) id <TKWaterfallsViewDelegate> delegate;
@property (nonatomic, readonly) NSUInteger numberOfCells;
@property (nonatomic, readonly) NSArray *visibleCells;
@property (nonatomic, readonly) UIView *containerView;
@property (nonatomic, retain) UIView *headerView;                 //default is nil
@property (nonatomic, retain) UIView *footerView;                 //default is nil

- (TKWaterfallsViewCell *)dequeueReusableCell;
- (void)reloadData;

@end




