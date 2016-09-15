//
//  CountryDetailsViewController.m
//  Countries
//
//  Created by anoopm on 11/09/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

#import "CountryDetailsViewController.h"
#import "CountriesDataSource.h"

@interface CountryDetailsViewController ()

@property(nonatomic, strong) CountriesDataSource* countriesDataSource;
@end

@implementation CountryDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    countryDetailTableView.rowHeight = UITableViewAutomaticDimension;
    countryDetailTableView.estimatedRowHeight = 80.0f;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Load initial data
    [self loadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // Cancel the on-going network requests
    [self.countriesDataSource cancelOnGoingTasks];
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
    // Set the flag and country name as we already have that information
    flagView.image = [UIImage imageNamed:self.selectedCountryCode];
    name.text      = self.selectedCountryName;
    
    // Initialize the datasource with the detail celltype
    self.countriesDataSource = [[CountriesDataSource alloc] initWithCountryDataWithCellType:CountryDetailsCellType];
    countryDetailTableView.delegate = self;
    countryDetailTableView.dataSource = self.countriesDataSource;
    [self reloadData];
    
}
/*!
 Method load fresh data
 @param nil
 @result nil
 */
-(void) reloadData{
    
    [self showLoader];
    // Ask datasource to give the details of the country
    [self.countriesDataSource fetchDetailsForCountry:self.selectedCountryCode withCompletionBlock:^(BOOL isSuccess, NSString *message) {
        // If we have the data, reload the data
        if (isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [countryDetailTableView reloadData];
                [self hideLoader];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertWithError:message];
                [self hideLoader];
            });
        }
    }];
}
/*!
 Method to show alert incase of failure
 @param (NSString*) errorMessage
 @result nil
 */
-(void) showAlertWithError:(NSString*) errorMessage{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"Error", @"Error Message")
                                          message:errorMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel Button")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                           }];
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Retry", @"Retry Button")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self reloadData];
                                                         }];
    [alertController addAction:cancelAction];
    [alertController addAction:retryAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) showLoader{
    
    loaderView.hidden = NO;
    [activityIndicator startAnimating];
}

- (void) hideLoader{
    
    loaderView.hidden = YES;
    [activityIndicator stopAnimating];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
