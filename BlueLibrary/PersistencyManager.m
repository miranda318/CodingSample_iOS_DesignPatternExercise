//
//  PersistencyManager.m
//  BlueLibrary
//
//  Created by Miranda on 10/24/15.
//  Copyright © 2015 Eli Ganem. All rights reserved.
//
//  Notification Design Pattern (saveImage, getImage)
//


#import "PersistencyManager.h"

// Just another way to add private methods/variables
@interface PersistencyManager () {
    NSMutableArray *albums;
}
@end

@implementation PersistencyManager

- (instancetype) init {
    self = [super init];
    if (self) {
        Album *album1 = [[Album alloc] initWithTitle:@"Best of Bowie" artist:@"David Bowie" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_david%20bowie_best%20of%20bowie.png" year:@"1992"];
        Album *album2 = [[Album alloc] initWithTitle:@"It's My Life" artist:@"No Doubt" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_no%20doubt_its%20my%20life%20%20bathwater.png" year:@"2003"];
        Album *album3 = [[Album alloc] initWithTitle:@"Nothing Like The Sun" artist:@"Sting" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_sting_nothing%20like%20the%20sun.png" year:@"1999"];
        Album *album4 = [[Album alloc] initWithTitle:@"Staring at the Sun" artist:@"U2" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_u2_staring%20at%20the%20sun.png" year:@"2000"];
        albums = [NSMutableArray arrayWithArray:@[album1,album2,album3,album4]];
    }
    return self;
}

- (NSArray*) getAlbums {
    return albums;
}

- (void)addAlbum:(Album *)album atIndex:(int)index {
    if (albums.count >= index) {
        [albums insertObject:album atIndex:index];
    }
    else {
        [albums addObject:album];
    }
}

- (void)deleteAlbumAtIndex:(int)index {
    [albums removeObjectAtIndex:index];
}

// save the album cover once it is downloaded, part 2 (Notification)

- (void)saveImage:(UIImage *)image filename:(NSString *)filename {
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:filename atomically:YES];
}

- (UIImage*)getImage:(NSString *)filename {
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    return [UIImage imageWithData:data];
}

@end
