//
//  Album.m
//  BlueLibrary
//
//  Created by Miranda on 10/24/15.
//  Copyright © 2015 Eli Ganem. All rights reserved.
//

#import "Album.h"

@implementation Album

- (instancetype)initWithTitle:(NSString *)title artist:(NSString *)artist coverUrl:(NSString *)coverUrl year:(NSString *)year {
    self = [super init];
    if (self) {
        _title = title;
        _artist = artist;
        _coverUrl = coverUrl;
        _year = year;
        _genre = @"Pop";
    }
    return self;
}

@end
