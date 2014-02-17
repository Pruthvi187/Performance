//
//  PlayerProfileViewController.h
//  Waratahs
//
//  Created by Pruthvi on 6/02/14.
//  Copyright (c) 2014 Pruthvi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFQuiltLayout.h"

@interface PlayerProfileViewController : UIViewController <RFQuiltLayoutDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIPopoverController * filterController;
    
    UIPopoverController * sortController;
    
    UITableView * menuTableView;
    
    NSMutableArray * filterOptions;
    
    NSMutableArray * sortOptions;
}

@property(nonatomic, retain) IBOutlet UIButton * filterButton;

@property(nonatomic, retain) IBOutlet UIButton * sortButton;

-(IBAction)showFilterOptions:(id)sender;

-(IBAction)showSortOptions:(id)sender;

@end
