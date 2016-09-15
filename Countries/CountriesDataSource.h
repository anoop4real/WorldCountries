//
//  CountriesDataSource.h
//  Countries
//
//  Created by anoopm on 10/09/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef NS_ENUM(NSInteger,TableViewCellType){
    
    CountryCellType = 1,
    CountryDetailsCellType
    
};
@interface CountriesDataSource : NSObject<UITableViewDataSource>

-(instancetype) initWithCountryDataWithCellType:(TableViewCellType) tableCellType;
- (void) fetchDetailsForCountry:(NSString*) countryCode withCompletionBlock:(void (^)(BOOL isSuccess,NSString* message))completionBlock;
- (NSString*) getCountryNameAtIndex:(NSInteger) index;
- (NSString*) getCountryCodeAtIndex:(NSInteger) index;
- (void) cancelOnGoingTasks;
- (void) filterUsingSearchText:(NSString*) searchString;

@property(nonatomic) BOOL isSearchActive;
@end
