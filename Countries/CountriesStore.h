//
//  CountriesStore.h
//  Countries
//
//  Created by anoopm on 10/09/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CountriesStore : NSObject

+(instancetype) sharedStore;
- (NSMutableArray *)basicCountryData;
-(void) fetchDetailsForCountryWithCode:(NSString*) countryCode withSuccesBlock:(void (^)(NSArray* countryData))responseBlock andErrorBlock:(void(^)(NSString* errorMessage))errorBlock;
- (void) cancelOnGoingTasks;
@end
