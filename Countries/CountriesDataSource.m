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
@property(nonatomic) TableViewCellType cellType;

@end

@implementation CountriesDataSource

-(instancetype) initWithCountryDataWithCellType:(TableViewCellType) tableCellType{
    
    self = [super init];
    if(self){
        if (tableCellType == CountryCellType) {
            // Get country name and code.
            _countryListArray= [[CountriesStore sharedStore] getBasicCountryData];
        }
        _cellType = tableCellType;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _countryListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (_cellType == CountryCellType) {
        // Get country cell
        return [self configureCountryCellWithTableView:tableView forIndexPath:indexPath];
    }
    else if(_cellType == CountryDetailsCellType){
        return [self configureCountryDetailCellWithTableView:tableView forIndexPath:indexPath];
    }

    // Ideally code should not reach here
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    return cell;
}

- (CountryTableCell*) configureCountryCellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier=@"CountryCell";
    SimpleCountry *country = _countryListArray[indexPath.row];
    
    CountryTableCell *cell = (CountryTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.countryNameLabel.text = country.countryName;
    cell.flagImageView.image   = [UIImage imageNamed:country.countryCode.lowercaseString];
    return cell;
}
- (CountryDetailTableViewCell*) configureCountryDetailCellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier=@"CountryDetailCell";
    GenericCellData *cellData = _countryListArray[indexPath.row];
    
    CountryDetailTableViewCell *cell = (CountryDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.title.text  = cellData.title;
    cell.detail.text = cellData.detail;
    return cell;
}
- (NSString*) getCountryNameAtIndex:(NSInteger) index{
    
    SimpleCountry *country = _countryListArray[index];
    
    return country.countryName;
}
- (NSString*) getCountryCodeAtIndex:(NSInteger) index{
    
    SimpleCountry *country = _countryListArray[index];
    
    return [country.countryCode lowercaseString];
}
- (void) cancelOnGoingTasks{
    [[CountriesStore sharedStore] cancelOnGoingTasks];
}
- (void) fetchDetailsForCountry:(NSString*) countryName withCompletionBlock:(void (^)(BOOL isSuccess,NSString* message))completionBlock{
    
    [[CountriesStore sharedStore] fetchDetailsForCountryWithName:countryName
                                      withSuccesBlock:^(NSArray *countryData) {
                                          _countryListArray = [countryData mutableCopy];
                                          completionBlock(YES,nil);
                                      } andErrorBlock:^(NSString *errorMessage) {
                                          completionBlock(NO,errorMessage);
                                      }];
}
@end
