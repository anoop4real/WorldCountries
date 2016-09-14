//
//  CountryDetailsViewController.h
//  Countries
//
//  Created by anoopm on 11/09/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryDetailsViewController : UIViewController<UITableViewDelegate>{
    
    IBOutlet UIImageView *flagView;
    IBOutlet UILabel *name;
    IBOutlet UITableView *countryDetailTableView;
    IBOutlet UIView* loaderView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic, strong)NSString *selectedCountryName;
@property(nonatomic, strong)NSString *selectedCountryCode;
@end
