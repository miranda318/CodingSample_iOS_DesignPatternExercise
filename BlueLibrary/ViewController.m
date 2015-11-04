//
//  ViewController.m
//  BlueLibrary
//
//  Created by Eli Ganem on 31/7/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//
//  Decerator Design Pattern (Delegate Pattern)
//  Adaptor Deisign Patterb (HorizontalScroller + AlbumView)
//  Memento Design Pattern (saveCurrentState)
//

#import "ViewController.h"
#import "LibraryAPI.h"
#import "Album+TableRepresentation.h"
#import "HorizontalScroller.h"
#import "AlbumView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, HorizontalScrollerDelegate> {

    UITableView *dataTable;
    NSArray *allAlbums;
    NSDictionary *currentAlbumData;
    int currentAlbumAtIndex;
    HorizontalScroller *scroller;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.76f green:0.81f blue:0.87f alpha:1.0];
    currentAlbumAtIndex = 0;
    
    // Get a list of all the albums via the API. You don’t use PersistencyManager directly!
    allAlbums = [[LibraryAPI sharedInstance] getAlbums];
    
    // the UITableView that presents the album data
    dataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 136, self.view.frame.size.width, self.view.frame.size.height-120) style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.backgroundView = nil;
    [self.view addSubview:dataTable];
    
    // load previous album index
    [self loadPreviousState];
    
    // initialize the scroller
    scroller = [[HorizontalScroller alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 136)];
    scroller.backgroundColor = [UIColor colorWithRed:0.24f green:0.35f blue:0.49f alpha:1.0];
    scroller.delegate = self;
    [self.view addSubview:scroller];
    
    [self reloadScroller];
    
    // loads the current album at app launch. And since currentAlbumIndex was previously set to 0, this shows the first album in the collection.
    [self showDataForAblumAtIndex:currentAlbumAtIndex];
    
    // save the current state when app enters the background
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationBackgroundRefreshStatusDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDataForAblumAtIndex:(int)albumIndex {
    if (albumIndex < allAlbums.count) {
        // fetch the album
        Album *album = allAlbums[albumIndex];
        // save the albums data present it later in the tableview
        currentAlbumData = [album tr_tableRepresentation];
    }
    else {
        currentAlbumData = nil;
    }
    
    // refresh tableview and present data. This causes UITableView to ask its delegate such things as how many sections should appear in the table view, how many rows in each section, and how each cell should look.
    [dataTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [currentAlbumData[@"titles"] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = currentAlbumData[@"titles"][indexPath.row];
    cell.detailTextLabel.text = currentAlbumData[@"values"][indexPath.row];
    
    return  cell;
}

// This method loads album data via LibraryAPI and then sets the currently displayed view based on the current value of the current view index. If the current view index is less than 0, meaning that no view was currently selected, then the first album in the list is displayed. Otherwise, the last album is displayed.
- (void)reloadScroller {
    allAlbums = [[LibraryAPI sharedInstance]getAlbums];
    if (currentAlbumAtIndex < 0) {
        currentAlbumAtIndex = 0;
    }
    else if (currentAlbumAtIndex >= allAlbums.count) currentAlbumAtIndex = allAlbums.count - 1;
    [scroller reload];
    
    [self showDataForAblumAtIndex:currentAlbumAtIndex];
}

#pragma mark - HorizontalScrollerDelegate methods
// This sets the variable that stores the current album and then calls showDataForAlbumAtIndex: to display the data for the new album.
- (void)horizontalScrolle:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index {
    currentAlbumAtIndex = index;
    [self showDataForAblumAtIndex:index];
}

- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller *)scroller {
    return allAlbums.count;
}

// create an AlbumView and pass to it to the HorizontalScroller
- (UIView*)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index {
    Album *album = allAlbums[index];
    return [[AlbumView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) albumCover:album.coverUrl];
}

#pragma mark - helper methods for Memento Pattern
- (void)saveCurrentState {
    // When the user leaves the app and then comes back again, he wants it to be in the exact same state
    // he left it. In order to do this we need to save the currently displayed album.
    // Since it's only one piece of information we can use NSUserDefaults.
    [[NSUserDefaults standardUserDefaults] setInteger:currentAlbumAtIndex forKey:@"currentAlbumIndex"];
}

- (void)loadPreviousState {
    currentAlbumAtIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentAlbumIndex"];
    [self showDataForAblumAtIndex:currentAlbumAtIndex];
}

@end
