//
//  CountryViewController.m
//  Countries
//
//  Created by anoopm on 10/09/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

#import "CountriesViewController.h"
#import "CountriesDataSource.h"
#import "CountryDetailsViewController.h"

@interface CountriesViewController ()

@property(nonatomic, strong) CountriesDataSource* countriesDataSource;

@end

@implementation CountriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set up searchbar
    [self setUpSearchBar];
    // Load the basic country data
    [self loadData];
    countryTableView.rowHeight = UITableViewAutomaticDimension;
    countryTableView.estimatedRowHeight = 80.0f;
    // Do any additional setup after loading the view.
}
/*!
 Set up search bar
 @param nil
 @result nil
 */
- (void) setUpSearchBar{
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
    
    // Add the UISearchBar to the top header of the table view
    countryTableView.tableHeaderView = self.searchController.searchBar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*!
 Load country data in the tableview
 @param nil
 @result nil
 */
- (void) loadData{
    
    // Initialize the datasource
    self.countriesDataSource = [[CountriesDataSource alloc] initWithCountryDataWithCellType:CountryCellType];
    countryTableView.delegate = self;
    countryTableView.dataSource = self.countriesDataSource;
    
    [countryTableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowDetails"]){
        
        NSIndexPath *indexPath = countryTableView.indexPathForSelectedRow;
        // Set the selected country and code details to the details view.
        CountryDetailsViewController *countryDetailsVC = segue.destinationViewController;
        countryDetailsVC.selectedCountryName = [self.countriesDataSource getCountryNameAtIndex:indexPath.row];
        countryDetailsVC.selectedCountryCode = [self.countriesDataSource getCountryCodeAtIndex:indexPath.row];
        [countryTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark Searchbar delegates
- (void)updateSearchResultsForSearchController:(UISearchController *)aSearchController{
    
    NSString *searchString = aSearchController.searchBar.text;
    if (aSearchController.active && searchString.length>0) {
        [self.countriesDataSource setIsSearchActive:YES];
        [self.countriesDataSource filterUsingSearchText:searchString];
    }
    else{
        [self.countriesDataSource setIsSearchActive:NO];
    }
    [countryTableView reloadData];
    
}

@end
