//
//  LibraryAPI.m
//  BlueLibrary
//
//  Created by Miranda on 10/24/15.
//  Copyright © 2015 Eli Ganem. All rights reserved.
//
//  Singleton Design Pattern, Facade Design Pattern
//  Notification Deisng Pattern
//

#import "LibraryAPI.h"
#import "PersistencyManager.h"
#import "HTTPClient.h"

@interface LibraryAPI () {
    PersistencyManager *persistencyManager;
    HTTPClient *httpClient;
    BOOL isOnline;
}

@end

@implementation LibraryAPI

+ (LibraryAPI*)sharedInstance {
    // Declare a static variable to hold the instance of your class,
    // ensuring it’s available globally inside your class
    static LibraryAPI *_sharedInstance = nil;
    
    // Declare the static variable dispatch_once_t which ensures that the initialization code executes only once.
    static dispatch_once_t oncePredicate;
    
    // Use GCD to execute a block which initializes an instance of LibraryAPI. (the ESSENCE of signleton)
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    return _sharedInstance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        persistencyManager = [[PersistencyManager alloc]init];
        httpClient = [[HTTPClient alloc] init];
        isOnline = NO;
        
        // Notification starts here, part 2
        // This is the other side of the equation: the observer. Every time an AlbumView class posts a BLDownloadImageNotification notification, since LibraryAPI has registered as an observer for the same notification, the system notifies LibraryAPI. And LibraryAPI executes downloadImage: in response.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadImage:) name:@"BLDownloadImageNotification" object:nil];
    }
    return  self;
}


// However, before you implement downloadImage: you must remember to unsubscribe from this notification when your class is deallocated. If you do not properly unsubscribe from a notification your class registered for, a notification might be sent to a deallocated instance. This can result in application crashes.

- (void)dealloc {
    // When this class is deallocated, it removes itself as an observer from all notifications it had registered for.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma marks - LibraryAPI helper methods

- (NSArray*)getAlbums {
    return  [persistencyManager getAlbums];
}

- (void)addAlbum:(Album *)album atIndex:(int)index {
    [persistencyManager addAlbum:album atIndex:index];
    if (isOnline) {
        [httpClient postRequest:@"/api/addAlbum" body:[album description]];
    }
}

- (void)deleteAlbumAtIndex:(int)index {
    [persistencyManager deleteAlbumAtIndex:index];
    if (isOnline) {
        [httpClient postRequest:@"/api/deleteAlbum" body:[@(index) description]];
    }
}

#pragma marks - cover image part 3
- (void)downloadImage:(NSNotification*)notification {
    // downloadImage is executed via notifications and so the method receives the notification object as a parameter. The UIImageView and image URL are retrieved from the notification.
    UIImageView *imageView = notification.userInfo[@"imageView"];
    NSString *coverUrl = notification.userInfo[@"coverUrl"];
    NSLog(@"coverUrl: %@",coverUrl);
    
    // Retrieve the image from the PersistencyManager if it’s been downloaded previously.
    imageView.image = [persistencyManager getImage:[coverUrl lastPathComponent]];
    
    if (imageView.image == nil) {
        
        // If the image hasn’t already been downloaded, then retrieve it using HTTPClient.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [httpClient downloadImage:coverUrl];
            
            // When the download is complete, display the image in the image view and use the PersistencyManager to save it locally.
            dispatch_sync(dispatch_get_main_queue(), ^{
                imageView.image = image;
                [persistencyManager saveImage:image filename:[coverUrl lastPathComponent]];
            });
            
        });
    }
}

@end
