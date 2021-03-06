//
//  AMNetworkManager.m
//  Countries
//
//  Created by anoopm on 11/09/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

#import "AMNetworkManager.h"

@interface AMNetworkManager()

@property(nonatomic, strong) NSURLSession *currentSession;

@end
@implementation AMNetworkManager

/*!
 Shared network manager
 @param nil
 @result sharedStore
 */
+(instancetype) sharedManager{
    
    static AMNetworkManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[AMNetworkManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedManager;
}
/*!
 Cancel All ongoing network operation in the session.
 @param nil
 @result nil
 */
- (void) cancelOnGoingTasks{
    
    if(self.currentSession){
        // Cancel all the on going sessions
        [self.currentSession invalidateAndCancel];
    }
}
/*!
 Method used to fire network API requests.
 @param success block expected to return data
 @param error block which will bring user understandable error.
 @result nil
 */
-(void) fetchDataUsingURLRequest:(NSURLRequest*)request withResponseBlock:(void (^)(NSData* data))responseBlock andErrorBlock:(void(^)(NSString* errorMessage))errorBlock
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    config.URLCache = nil;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    // Set as current session.
    self.currentSession = session;
    [[session dataTaskWithURL:[request URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            
            errorBlock([self getUserErrorMessageForError:error]);
        }
        else{
            responseBlock(data);
        }
    }] resume];
}
/*!
 Prepare user understandable error
 @param (NSError*) error
 @result nil
 */
-(NSString*) getUserErrorMessageForError:(NSError*) error{
    
    NSString *errorMessage = NSLocalizedString(@"Unknown Error, please retry", @"Default Error message");
    switch (error.code) {
        case 302:
            errorMessage = NSLocalizedString(@"Bad Connection, please retry", @"Bad Connection");
            break;
        case 305:
            errorMessage = NSLocalizedString(@"Bad Request, please retry", @"Bad Request");
            break;
        case NSURLErrorCannotConnectToHost:
            errorMessage = NSLocalizedString(@"Cannot connect, please retry", @"Cannot connect");
            break;
        case NSURLErrorNetworkConnectionLost:
            errorMessage = NSLocalizedString(@"The connection failed because the network connection was lost, please retry", @"Cannot connect");
            break;
        case NSURLErrorTimedOut:
            errorMessage = NSLocalizedString(@"The connection timed out, please retry", @"The connection timed out.");
            break;
        case NSURLErrorNotConnectedToInternet:
            errorMessage = NSLocalizedString(@"The connection failed because the device is not connected to the internet, please retry", @"The connection timed out.");
            break;
        default:
            break;
    }
    return errorMessage;
}
@end
