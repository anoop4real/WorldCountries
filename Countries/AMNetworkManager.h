//
//  AMNetworkManager.h
//  Countries
//
//  Created by anoopm on 11/09/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMNetworkManager : NSObject<NSURLSessionTaskDelegate>

+(instancetype) sharedManager;
-(void) fetchDataUsingURLRequest:(NSURLRequest*)request withResponseBlock:(void (^)(NSData* data))responseBlock andErrorBlock:(void(^)(NSString* errorMessage))errorBlock;
- (void) cancelOnGoingTasks;
@end
