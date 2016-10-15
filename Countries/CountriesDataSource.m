//
//  CountriesDataSource.m
//  Countries
//
//  Created by anoopm on 10/09/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

#import "CountriesDataSource.h"
#import "CountriesStore.h"
#import "CountryTableCell.h"
#import "SimpleCountry.h"
#import "GenericCellData.h"
#import "CountryDetailTableViewCell.h"


@interface CountriesDataSource()

@property(nonatomic, strong) NSMutableArray *countryListArray;
@property(nonatomic, strong) NSArray *filteredCountryListArray;
@property(nonatomic) TableViewCellType cellType;

@end

@implementation CountriesDataSource

-(instancetype) initWithCountryDataWithCellType:(TableViewCellType) tableCellType{
    
    self = [super init];
    if(self){
        if (tableCellType == CountryCellType) {
            // Basic cell data, Get country name and code.
            _countryListArray= [[CountriesStore sharedStore] basicCountryData];
        }
        _cellType = tableCellType;
    }
    return self;
}

#pragma mark tableviewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (_cellType == CountryCellType) {
        if (_isSearchActive) {
            // If search is active, return filtered array
            count = _filteredCountryListArray.count;
        }else{
            count = _countryListArray.count;
        }
    }
    else{
        // Data for Details screen
        count = _countryListArray.count;
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_cellType == CountryCellType) {
        // Get country cell
        return [self configureCountryCellWithTableView:tableView forIndexPath:indexPath];
    }
    else if(_cellType == CountryDetailsCellType){
        // Set up country detail cell
        return [self configureCountryDetailCellWithTableView:tableView forIndexPath:indexPath];
    }
    
    // Ideally code should not reach here
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    return cell;
}
// Method to configure the country list cells
- (CountryTableCell*) configureCountryCellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier=@"CountryCell";
    SimpleCountry *country;
    if (_isSearchActive) {
        country = _filteredCountryListArray[indexPath.row];
    }
    else{
        country = _countryListArray[indexPath.row];
    }
    CountryTableCell *cell = (CountryTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.countryNameLabel.text = country.countryName;
    cell.flagImageView.image   = [UIImage imageNamed:country.countryCode.lowercaseString];
    return cell;
}

// Method to configure the country details cells
- (CountryDetailTableViewCell*) configureCountryDetailCellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier=@"CountryDetailCell";
    GenericCellData *cellData = _countryListArray[indexPath.row];
    
    CountryDetailTableViewCell *cell = (CountryDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.title.text  = cellData.title;
    cell.detail.text = cellData.detail;
    return cell;
}
#pragma mark custom methods
// Used to get the country name at selected index by the user
- (NSString*) getCountryNameAtIndex:(NSInteger) index{
    
    SimpleCountry *country;
    if (_isSearchActive) {
        country = _filteredCountryListArray[index];
    }
    else{
        country = _countryListArray[index];
    }
    
    return country.countryName;
}

// Used to get the country code at selected index by the user
- (NSString*) getCountryCodeAtIndex:(NSInteger) index{
    
    SimpleCountry *country;
    if (_isSearchActive) {
        country = _filteredCountryListArray[index];
    }
    else{
        country = _countryListArray[index];
    }
    
    return [country.countryCode lowercaseString];
}

#pragma mark filtering

// Method which provides the filtered list
- (void) filterUsingSearchText:(NSString*) searchString{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"countryName contains[c] %@", searchString];
    _filteredCountryListArray = [_countryListArray filteredArrayUsingPredicate:predicate];
}
#pragma marks Data operation
- (void) cancelOnGoingTasks{
    [[CountriesStore sharedStore] cancelOnGoingTasks];
}
/*!
 Method to fetch the details of country from Country store
 @param countryCode, completionBlock
 @result nil
 */
- (void) fetchDetailsForCountry:(NSString*) countryCode withCompletionBlock:(void (^)(BOOL isSuccess,NSString* message))completionBlock{
    
    [[CountriesStore sharedStore] fetchDetailsForCountryWithCode:countryCode
                                                 withSuccesBlock:^(NSArray *countryData) {
                                                     _countryListArray = [countryData mutableCopy];
                                                     completionBlock(YES,nil);
                                                 } andErrorBlock:^(NSString *errorMessage) {
                                                     completionBlock(NO,errorMessage);
                                                 }];
}
@end
