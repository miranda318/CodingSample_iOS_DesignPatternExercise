//
//  HorizontalScroller.h
//  BlueLibrary
//
//  Created by Miranda on 10/27/15.
//  Copyright © 2015 Eli Ganem. All rights reserved.
//
//  Adapter Pattern: An Adapter allows classes with incompatible interfaces to work together. It wraps itself around an object and exposes a standard interface to interact with that object.
//

#import <UIKit/UIKit.h>

@protocol HorizontalScrollerDelegate;
@interface HorizontalScroller : UIView

@property (weak) id<HorizontalScrollerDelegate> delegate; // weak: prevent retain cycle

- (void)reload;
@end


// This defines a protocol named HorizontalScrollerDelegate that inherits from the NSObject protocol in the same way that an Objective-C class inherits from its parent. It’s good practice to conform to the NSObject protocol — or to conform to a protocol that itself conforms to the NSObject protocol. This lets you send messages defined by NSObject to the delegate of HorizontalScroller.

@protocol HorizontalScrollerDelegate <NSObject>

// methods declaration goes in here
@required
- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller*)scroller; // ask the delegate how many views he wants to present inside the horizontal scroller
- (UIView*)horizontalScroller:(HorizontalScroller*)scroller viewAtIndex:(int)index; // ask the delegate to return the view that should appear at <index>
- (void)horizontalScrolle:(HorizontalScroller*)scroller clickedViewAtIndex:(int)index; // inform the delegate what the view at <index> has been clicked

@optional
- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller*)scroller; // defaults to 0 if it's not implemented by the delegate
@end 