//
//  CountryViewController.h
//  Countries
//
//  Created by anoopm on 10/09/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountriesViewController : UIViewController<UITableViewDelegate,UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>{
    
    IBOutlet UITableView *countryTableView;
}
@property (nonatomic, strong) UISearchController *searchController;
@end
