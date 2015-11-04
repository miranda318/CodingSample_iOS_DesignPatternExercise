//
//  Album+TableRepresentation.h
//  BlueLibrary
//
//  Created by Miranda on 10/26/15.
//  Copyright © 2015 Eli Ganem. All rights reserved.
//

#import "Album.h"

@interface Album (TableRepresentation)

- (NSDictionary*)tr_tableRepresentation; // tr as an abbreviation of the name of the category: TableRepresentation.

@end
