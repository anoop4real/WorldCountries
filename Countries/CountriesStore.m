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
#define COUNTRY_DETAILS_REQUEST_URL @"https://restcountries.eu/rest/v1/name/%@?fullText=true"
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
- (NSMutableArray *)getBasicCountryData
{
    
    NSMutableArray<SimpleCountry*> *countryListArray = [NSMutableArray array];
    for (NSString *countryCode in [NSLocale ISOCountryCodes])
    {
        NSString *countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:countryCode];
        
        //workaround for simulator bug
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
/*!
 Method used to get the details of a country.
 @param success block expected to return a Country Object
 @param error block which will bring user understandable error.
 @result nil
 */
-(void) fetchDetailsForCountryWithName:(NSString*) countryName withSuccesBlock:(void (^)(NSArray* countryData))responseBlock andErrorBlock:(void(^)(NSString* errorMessage))errorBlock{
    
    
    NSString* url = [NSString stringWithFormat:COUNTRY_DETAILS_REQUEST_URL,countryName];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.networkManager fetchDataUsingURRRequest:urlRequest
                                withResponseBlock:^(NSData *data) {
                                    NSLog(@"Data fetched");
                                    NSError *error;
                                    NSArray *countryArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                    if (!countryArray) {
                                        errorBlock(@"Unknown error occured, please retry");
                                    }else{
                                        responseBlock([self countryDataWithDict:countryArray[0]]);
                                    }
                                    NSLog(@"%@",countryArray);
                                } andErrorBlock:^(NSString *errorMessage) {
                                    errorBlock(errorMessage);
                                }];
}

-(NSArray*) countryDataWithDict:(NSDictionary*)countryDict{
    
    NSMutableArray *countryDetailsArray = [NSMutableArray array];
    for (NSString* key in countryDict.allKeys) {
        if ([countryDict[key] isKindOfClass:[NSString class]]) {
            
            GenericCellData *cellData = [[GenericCellData alloc] init];
            cellData.title  = [key uppercaseString];
            cellData.detail = countryDict[key];
            [countryDetailsArray addObject:cellData];
        }
    }
    [countryDetailsArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    return countryDetailsArray;
}

@end
