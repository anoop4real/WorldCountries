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
    [self loadData];
    // Do any additional setup after loading the view.
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
        CountryDetailsViewController *countryDetailsVC = segue.destinationViewController;
        countryDetailsVC.selectedCountryName = [self.countriesDataSource getCountryNameAtIndex:indexPath.row];
        countryDetailsVC.selectedCountryCode = [self.countriesDataSource getCountryCodeAtIndex:indexPath.row];
        [countryTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}



@end
