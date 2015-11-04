//
//  Album+TableRepresentation.m
//  BlueLibrary
//
//  Created by Miranda on 10/26/15.
//  Copyright © 2015 Eli Ganem. All rights reserved.
//
//  Decorator Design Pattern (Category)
//

#import "Album+TableRepresentation.h"

@implementation Album (TableRepresentation)

-(NSDictionary*) tr_tableRepresentation {

    return @{@"titles":@[@"Artist", @"Album", @"Genre", @"Year"],
             @"values":@[self.artist, self.title, self.genre, self.year]};
}

//Advantages of Category Design Pattern:
//Uses properties directly from Album.
//Adds to the Album class but haven’t subclassed it. If you need to sub-class Album, you can still do that too.
//Allows to return a UITableView–ish representation of an Album, without modifying Album‘s code.

@end
