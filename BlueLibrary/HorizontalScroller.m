//
//  HorizontalScroller.m
//  BlueLibrary
//
//  Created by Miranda on 10/27/15.
//  Copyright © 2015 Eli Ganem. All rights reserved.
//
//  Adapter Deisng Pattern: allows classes with incompatible interfaces to work together. It wraps itself around an object and exposes a standard interface to interact with that object.

#import "HorizontalScroller.h"

#define VIEW_PADDING 10
#define VIEW_DIMENSIONS 100
#define VIEWS_OFFSET 100

@interface HorizontalScroller () <UIScrollViewDelegate>
@end

@implementation HorizontalScroller {
    UIScrollView *scroller;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 16, frame.size.width, frame.size.height)];
        scroller.delegate = self;
        [self addSubview:scroller];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
        [scroller addGestureRecognizer:tapRecognizer];
    }
    return  self;
}

- (void)scrollerTapped:(UITapGestureRecognizer*)gesture {
    CGPoint location = [gesture locationInView:gesture.view];
    
    // we can't use an enumerator here, because we don't want to enumerate over ALL of the UIScrollView subviews.
    // we want to enumerate only the subviews that we added
    for (int index = 0; index < [self.delegate numberOfViewsForHorizontalScroller:self]; index++) {
        UIView *view = scroller.subviews[index];
        if (CGRectContainsPoint(view.frame, location)) {
            [self.delegate horizontalScrolle:self clickedViewAtIndex:index];
            [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated:YES];
            break;
        }
    }
}

// chao de
- (void)reload
{
    // 1 - nothing to load if there's no delegate
    if (self.delegate == nil) return;
    
    // 2 - remove all subviews
    [scroller.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    // 3 - xValue is the starting point of the views inside the scroller
    CGFloat xValue = VIEWS_OFFSET;
    for (int i=0; i<[self.delegate numberOfViewsForHorizontalScroller:self]; i++)
    {
        // 4 - add a view at the right position
        xValue += VIEW_PADDING;
        UIView *view = [self.delegate horizontalScroller:self viewAtIndex:i];
        view.frame = CGRectMake(xValue, VIEW_PADDING, VIEW_DIMENSIONS, VIEW_DIMENSIONS);
        [scroller addSubview:view];
        xValue += VIEW_DIMENSIONS+VIEW_PADDING;
    }
    
    // 5
    [scroller setContentSize:CGSizeMake(xValue+VIEWS_OFFSET, self.frame.size.height)];
    
    // 6 - if an initial view is defined, center the scroller on it
    if ([self.delegate respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)])
    {
        int initialView = [self.delegate initialViewIndexForHorizontalScroller:self];
        [scroller setContentOffset:CGPointMake(initialView*(VIEW_DIMENSIONS+(2*VIEW_PADDING)), 0) animated:YES];
    }
}

// The didMoveToSuperview message is sent to a view when it’s added to another view as a subview. This is the right time to reload the contents of the scroller
- (void)didMoveToSuperview
{
    [self reload];
}

// make sure the album you’re viewing is always centered inside the scroll view
- (void)centerCurrentView
{
    int xFinal = scroller.contentOffset.x + (VIEWS_OFFSET/2) + VIEW_PADDING;
    int viewIndex = xFinal / (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    xFinal = viewIndex * (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    [scroller setContentOffset:CGPointMake(xFinal,0) animated:YES];
    [self.delegate horizontalScrolle:self clickedViewAtIndex:viewIndex]; // The last line is important: once the view is centered, you then inform the delegate that the selected view has changed.
}

// To detect that the user finished dragging inside the scroll view, you must add the following UIScrollViewDelegate method
// In both cases we should call the new method to center the current view since the current view probably has changed after the user dragged the scroll view.

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
// informs the delegate when the user finishes dragging. The decelerate parameter is true if the scroll view hasn’t come to a complete stop yet.
{
    if (!decelerate)
    {
        [self centerCurrentView];
    }
}

// When the scroll action ends, the the system calls scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self centerCurrentView];
}

// Your HorizontalScroller is ready for use! Browse through the code you’ve just written; you’ll see there’s not one single mention of the Album or AlbumView classes. That’s excellent, because this means that the new scroller is truly independent and reusable.


@end
