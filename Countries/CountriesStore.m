 //
//  CountriesStore.m
//  Countries
//
//  Created by anoopm on 10/09/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

#import "CountriesStore.h"
#import "SimpleCountry.h"
#import "AMNetworkManager.h"
#import "GenericCellData.h"
#define COUNTRY_DETAILS_REQUEST_URL @"https://restcountries.eu/rest/v1/alpha/%@"

@interface CountriesStore()

@property(nonatomic, strong) AMNetworkManager *networkManager;

@end
@implementation CountriesStore



/*!
 Shared store for country names and codes
 @param nil
 @result sharedStore
 */
+(instancetype) sharedStore{
    
    static CountriesStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedStore = [[CountriesStore alloc] init];
    });
    return sharedStore;
}

-(AMNetworkManager*) networkManager{
    
    return [AMNetworkManager sharedManager];
}
- (void) cancelOnGoingTasks{
    [self.networkManager cancelOnGoingTasks];
}

// Method to fetch the ISO Country list with the help of NSLocale
- (NSMutableArray *)getBasicCountryData
{
    
    NSMutableArray<SimpleCountry*> *countryListArray = [NSMutableArray array];
    for (NSString *countryCode in [NSLocale ISOCountryCodes])
    {
        NSString *countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:countryCode];
        
        //Fix for an issue in simulator
        if (!countryName)
        {
            countryName = [[NSLocale localeWithLocaleIdentifier:@"en_US"] displayNameForKey:NSLocaleCountryCode value:countryCode];
        }
        
        SimpleCountry *country = [[SimpleCountry alloc] init];
        country.countryName = countryName;
        country.countryCode = countryCode;
        [countryListArray addObject:country];
    }
    [countryListArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"countryName" ascending:YES]]];
    return countryListArray;
}
#pragma mark Data Operation
/*!
 Method used to get the details of a country.
 @param success block expected to return parsed array
 @param error block which will bring user understandable error.
 @result nil
 */
-(void) fetchDetailsForCountryWithCode:(NSString*) countryCode withSuccesBlock:(void (^)(NSArray* countryData))responseBlock andErrorBlock:(void(^)(NSString* errorMessage))errorBlock{
    
    
    NSString* urlString = [NSString stringWithFormat:COUNTRY_DETAILS_REQUEST_URL,countryCode];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:2.0];
    
    [self.networkManager fetchDataUsingURLRequest:urlRequest
                                withResponseBlock:^(NSData *data) {
                                    NSError *error;
                                    NSDictionary *countryDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                    if (!countryDict) {
                                        errorBlock(@"Unknown error occured, please retry");
                                    }else{
                                        if ([countryDict isKindOfClass:[NSDictionary class]]) {
                                            responseBlock([self countryDataWithDict:countryDict]);
                                        }else{
                                            errorBlock(@"Unknown error occured, please retry");
                                        }
                                        
                                    }
                                    //NSLog(@"%@",countryArray);
                                } andErrorBlock:^(NSString *errorMessage) {
                                    errorBlock(errorMessage);
                                }];
}
#pragma mark Parsers
// It is the objective of CountryStore object to parse the response and sent to the data source in the required format. This method parses the response and at this point of time fetches all the string type and NSNumber type.
-(NSArray*) countryDataWithDict:(NSDictionary*)countryDict{
    
    NSMutableArray *countryDetailsArray = [NSMutableArray array];
    for (NSString* key in countryDict.allKeys) {
        if ([countryDict[key] isKindOfClass:[NSString class]]) {
            [countryDetailsArray addObject:[self createCellDataWith:[key uppercaseString] andDetail:countryDict[key]]];
            
        }else if ([countryDict[key] isKindOfClass:[NSNumber class]]){
            
            NSNumber* data = countryDict[key];
            [countryDetailsArray addObject:[self createCellDataWith:[key uppercaseString] andDetail:[data stringValue]]];
        }
    }
    [countryDetailsArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    return countryDetailsArray;
}

// Fill up the GenericCellData object which is used to display in the details screen
- (GenericCellData*) createCellDataWith:(NSString*) title andDetail:(NSString*)detail{
    
    GenericCellData *cellData = [[GenericCellData alloc] init];
    cellData.title  = title;
    cellData.detail = detail;
    return cellData;
}
@end
