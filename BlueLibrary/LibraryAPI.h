//
//  LibraryAPI.h
//  BlueLibrary
//
//  Created by Miranda on 10/24/15.
//  Copyright © 2015 Eli Ganem. All rights reserved.
//
//  Singleton Design Pattern (sharedInstance)
//  Facade Design Pattern (getAlbums, addAblum, deleteAlbumAtIndex)
//

#import <Foundation/Foundation.h>
#import "Album.h"

@interface LibraryAPI : NSObject

+ (LibraryAPI*)sharedInstance;
- (NSArray*)getAlbums;
- (void)addAlbum:(Album*)album atIndex:(int)index;
- (void)deleteAlbumAtIndex:(int)index;

@end
