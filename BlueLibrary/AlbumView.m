//
//  AlbumView.m
//  BlueLibrary
//
//  Created by Miranda on 10/24/15.
//  Copyright © 2015 Eli Ganem. All rights reserved.
//
//  Observer Pattern (Notifications)
//  In the Observer pattern, one object notifies other objects of any state changes. The objects involved don’t need to know about one another – thus encouraging a decoupled design. This pattern’s most often used to notify interested objects when a property has changed.

//  Notification: Notifications are based on a subscribe-and-publish model that allows an object (the publisher) to send messages to other objects (subscribers/listeners). The publisher never needs to know anything about the subscribers.
//
//  KVO: allows an object to observe changes to a property.In this case, it uses KVO to observe changes to the image property of the UIImageView that holds the image.

#import "AlbumView.h"

@implementation AlbumView {
    UIImageView *coverImage;
    UIActivityIndicatorView *indicator;
}

- (instancetype) initWithFrame:(CGRect)frame albumCover:(NSString *)albumCover {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        // The coverImage has a 5 pixel margin from its frame
        coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        [self addSubview:coverImage];
        
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = self.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [self addSubview:indicator];
        
        // KVO starts here, part 1
        // This adds self, which is the current class, as an observer for the image property of coverImage.
        [coverImage addObserver:self forKeyPath:@"image" options:0 context:nil];
        
        // Notification starts here, part 1
        // sends a notification through the NSNotificationCenter singleton. The notification info contains the UIImageView to populate and the URL of the cover image to be downloaded. That’s all the information you need to perform the cover download task.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BLDownloadImageNotification" object:self userInfo:@{@"imageView":coverImage, @"coverUrl":albumCover}];
    }
    return  self;
}

// KVO, part 2
// unregister the observer when it is done.
- (void) dealloc {
    [coverImage removeObserver:self forKeyPath:@"image"];
}

// KVO, part 3
// Must implement this method in every class acting as an observer. The system executes this method every time the observed property changes. Stops the spinner when the "image" property changes.
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        [indicator stopAnimating];
    }
}
@end
