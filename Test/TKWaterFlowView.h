



@interface TKWaterFlowViewCell : UIView

    

@end

@class TKWaterFlowView;
@class TKWaterFlowViewCell;

@protocol TKWaterFlowViewDataSource <NSObject>

- (NSInteger)numberOfRowsInWaterFlowView:(TKWaterFlowView *)waterFlowView;

- (TKWaterFlowViewCell *)waterFlowView:(TKWaterFlowView *)waterFlowView cellAtIndex:(NSUInteger)index;

@end


@protocol TKWaterFlowViewDelegate<UIScrollViewDelegate>

@optional

// Variable height support

- (CGFloat)waterFlowView:(TKWaterFlowView *)waterFlowView heightForCellAtIndex:(NSUInteger)index;

// Display customization

- (void)waterFlowView:(TKWaterFlowView *)waterFlowView willDisplayCell:(TKWaterFlowViewCell *)cell forRowAtIndex:(NSUInteger)index;

// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSUInteger)waterFlowView:(TKWaterFlowView *)waterFlowView willSelectRowAtIndex:(NSUInteger)index;
- (NSUInteger)waterFlowView:(TKWaterFlowView *)waterFlowView willDeselectRowAtIndex:(NSUInteger)index;

// Called after the user changes the selection.
- (void)waterFlowView:(TKWaterFlowView *)waterFlowView didSelectRowAtIndex:(NSUInteger)index;
- (void)waterFlowView:(TKWaterFlowView *)waterFlowView didDeselectRowAtIndex:(NSUInteger)index;

@end


@interface TKWaterFlowView : UIScrollView <UIScrollViewDelegate> {
    id <TKWaterFlowViewDataSource>  dataSource;
    UIView                          *containerView;
    NSMutableSet                    *reusableCells;    
    NSMutableArray                  *heights;
    int                             firstVisibleIndex, lastVisibleIndex;
}

@property (nonatomic, assign) id <TKWaterFlowViewDataSource> dataSource;
@property (nonatomic, assign) id <TKWaterFlowViewDelegate> delegate;
@property (nonatomic, readonly) NSUInteger numberOfCells;
@property (nonatomic, readonly) UIView *containerView;

- (TKWaterFlowViewCell *)dequeueReusableCell;
- (void)reloadData;

@end




