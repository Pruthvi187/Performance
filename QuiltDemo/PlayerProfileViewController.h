//
//  PlayerProfileViewController.h
//  Waratahs
//
//  Created by Pruthvi on 6/02/14.
//  Copyright (c) 2014 Pruthvi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFQuiltLayout.h"

typedef enum PlayerPositions {
    Forwards = 1,
    Backs = 2,
    Back_row = 3,
    Front_row  = 4,
    Half_backs = 5,
    Three_quarters = 6,
    Fullback = 7
} PlayerPositions;

@class Utilities, DataModel;

@interface PlayerProfileViewController : UIViewController <RFQuiltLayoutDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIPopoverController * filterController;
    
    UIPopoverController * sortController;
    
    UITableView * menuTableView;
    
    NSMutableArray * filterOptions;
    
    NSMutableArray * sortOptions;
    
    Utilities * utilities;
    
    DataModel * dataModel;
}

@property(nonatomic, retain) IBOutlet UIButton * filterButton;

@property(nonatomic, retain) IBOutlet UILabel * filterLabel;

@property(nonatomic, retain) IBOutlet UIButton * sortButton;

@property(nonatomic, retain) IBOutlet UILabel * sortLabel;

@property(nonatomic, retain) IBOutlet UIImageView * teamStatsOpenButton;

@property(nonatomic, retain) IBOutlet UIView * optionsPlaceHolderView;

-(IBAction)showFilterOptions:(id)sender;

-(IBAction)showSortOptions:(id)sender;

-(IBAction)showTeamStats:(id)sender;

@end
