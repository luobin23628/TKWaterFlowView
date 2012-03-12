//
//  TestViewController.m
//  Test
//
//  Created by luobin on 3/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TestViewController.h"

@implementation TestViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TKWaterfallsView *view = [[TKWaterfallsView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    view.dataSource = self;
    view.delegate = self;
    [self.view addSubview:view];
    [view release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfRowsInWaterfallsView:(TKWaterfallsView *)waterFlowView
{
    return 100;
}

- (TKWaterfallsViewCell *)waterfallsView:(TKWaterfallsView *)waterfallsView cellAtIndex:(NSUInteger)index;
{
    TKWaterfallsViewCell *cell = [waterfallsView dequeueReusableCell];
    if (!cell) {
        cell = [[[TKWaterfallsViewCell alloc] init] autorelease];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
        label.tag = 5;
        [cell addSubview:label];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:5];
    label.text = [NSString stringWithFormat:@"%d", index];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()*1.0/INT_MAX green:arc4random()*1.0/INT_MAX blue:arc4random()*1.0/INT_MAX alpha:1];
    return cell;
}

- (CGFloat)waterfallsView:(TKWaterfallsView *)waterfallsView heightForCellAtIndex:(NSUInteger)index
{
    return arc4random()%20 + 50;
}

@end
