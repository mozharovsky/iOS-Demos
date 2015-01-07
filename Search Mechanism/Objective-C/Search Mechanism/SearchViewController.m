//
//  SearchViewController.m
//  Search Mechanism
//
//  Created by E. Mozharovsky on 1/7/15.
//  Copyright (c) 2015 GameApp. All rights reserved.
//

#import "SearchViewController.h"

#define ResultsTableView self.searchResultsTableViewController.tableView

#define Identifier @"Cell"

@interface SearchViewController ()

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UITableViewController *searchResultsTableViewController;

@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) NSArray *results;

@end

@implementation SearchViewController {

}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Arrays init & sorting.
    self.cities = [@[@"Boston", @"New York", @"Oregon", @"Tampa", @"Los Angeles", @"Dallas", @"Miami", @"Olympia", @"Montgomery", @"Washington", @"Orlando", @"Detroit"] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj2 localizedCaseInsensitiveCompare:obj1] == NSOrderedAscending;
    }];
    
    self.results = [[NSMutableArray alloc] init];
    
    // A table view for results.
    UITableView *searchResultsTableView = [[UITableView alloc] initWithFrame:self.tableView.frame];
    searchResultsTableView.dataSource = self;
    searchResultsTableView.delegate = self;
    
    // Registration of reuse identifiers.
    [searchResultsTableView registerClass:UITableViewCell.class forCellReuseIdentifier:Identifier];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:Identifier];
    
    // Init a search results table view controller and setting its table view.
    self.searchResultsTableViewController = [[UITableViewController alloc] init];
    self.searchResultsTableViewController.tableView = searchResultsTableView;
    
    // Init a search controller with its table view controller for results.
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsTableViewController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    
    // Make an appropriate size for search bar and add it as a header view for initial table view.
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // Enable presentation context.
    self.definesPresentationContext = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Hide search bar.
    [self dismissSearchBarAnimated:NO];
}

#pragma mark - Util methods

- (void)dismissSearchBarAnimated: (BOOL)animated {
    CGFloat offset = (self.searchController.searchBar.bounds.size.height) - (self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
    
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.contentOffset = CGPointMake(0, offset);
        }];
    } else {
        self.tableView.contentOffset = CGPointMake(0, offset);
    }
}


#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:ResultsTableView]) {
        if (self.results) {
            return self.results.count;
        } else {
            return 0;
        }
    } else {
        
        return self.cities.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSString *text;
    if ([tableView isEqual:ResultsTableView]) {
        text = self.results[indexPath.row];
    } else {
        text = self.cities[indexPath.row];
    }
    
    cell.textLabel.text = text;
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - Search Results Updating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    UISearchBar *searchBar = searchController.searchBar;
    if (searchBar.text.length > 0) {
        NSString *text = searchBar.text;
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *city, NSDictionary *bindings) {
            NSRange range = [city rangeOfString:text options:NSCaseInsensitiveSearch];
            
            return range.location != NSNotFound;
        }];
        
        // Set up results.
        NSArray *searchResults = [self.cities filteredArrayUsingPredicate:predicate];
        self.results = searchResults;
        
        // Reload search table view.
        [self.searchResultsTableViewController.tableView reloadData];
    }
}

#pragma mark - Search Controller Delegate 

- (void)didDismissSearchController:(UISearchController *)searchController {
    [self dismissSearchBarAnimated:YES];
}


@end
