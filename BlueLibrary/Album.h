//
//  Album.h
//  BlueLibrary
//
//  Created by Miranda on 10/24/15.
//  Copyright © 2015 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject
@property (nonatomic, copy, readonly) NSString *title, *artist, *genre, *coverUrl, *year;

- (instancetype) initWithTitle:(NSString*)title artist:(NSString*)artist coverUrl:(NSString*)coverUrl year:(NSString*)year;

@end
