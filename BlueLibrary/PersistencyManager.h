//
//  PersistencyManager.h
//  BlueLibrary
//
//  Created by Miranda on 10/24/15.
//  Copyright © 2015 Eli Ganem. All rights reserved.
//  Notification Design Pattern (saveImage, getImage)

#import <Foundation/Foundation.h>
#import "Album.h"

@interface PersistencyManager : NSObject

- (NSArray*)getAlbums;
- (void)addAlbum:(Album*)album atIndex:(int)index;
- (void)deleteAlbumAtIndex:(int)index;

// save the album cover once it is downloaded, part 1
- (void)saveImage:(UIImage*)image filename:(NSString*)filename;
- (UIImage*)getImage:(NSString*)filename;

@end
