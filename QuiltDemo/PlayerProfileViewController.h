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

@interface PlayerProfileViewController : UIViewController <RFQuiltLayoutDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>
{
    UIPopoverController * filterController;
    
    UIPopoverController * sortController;
    
    UITableView * menuTableView;
    
    NSMutableArray * filterOptions;
    
    NSMutableArray * sortOptions;
    
    Utilities * utilities;
    
    DataModel * dataModel;
}

@property(nonatomic, weak) IBOutlet UIButton * filterButton;

@property(nonatomic, weak) IBOutlet UILabel * filterLabel;

@property(nonatomic, weak) IBOutlet UIButton * sortButton;

@property(nonatomic, weak) IBOutlet UILabel * sortLabel;

@property(nonatomic, weak) IBOutlet UIImageView * teamStatsOpenButton;

@property(nonatomic, weak) IBOutlet UIView * optionsPlaceHolderView;
@property (weak, nonatomic) IBOutlet UIView *statsView;
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet UIView *filtersView;

-(IBAction)showFilterOptions:(id)sender;

-(IBAction)showSortOptions:(id)sender;

-(IBAction)showTeamStats:(id)sender;

@end
