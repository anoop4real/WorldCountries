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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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
    flagView.image = [UIImage imageNamed:self.selectedCountryCode];
    name.text =self.selectedCountryName;
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
    [self.countriesDataSource fetchDetailsForCountry:self.selectedCountryName withCompletionBlock:^(BOOL isSuccess, NSString *message) {
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

-(void) showAlertWithError:(NSString*) errorMessage{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Error"
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
