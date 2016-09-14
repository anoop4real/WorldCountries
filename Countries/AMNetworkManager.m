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

- (void) cancelOnGoingTasks{
    
    if(self.currentSession){
        // Cancel all the on going sessions
        [self.currentSession invalidateAndCancel];
    }
}
-(void) fetchDataUsingURRRequest:(NSURLRequest*)request withResponseBlock:(void (^)(NSData* data))responseBlock andErrorBlock:(void(^)(NSString* errorMessage))errorBlock
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
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
