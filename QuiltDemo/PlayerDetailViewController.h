//
//  PlayerDetailViewController.h
//  Waratahs
//
//  Created by Pruthvi on 17/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot/CorePlot-CocoaTouch.h>

@class Player;

@interface PlayerDetailViewController : UIViewController<CPTPlotDataSource, CPTPlotDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    CPTXYGraph * graph;
    NSMutableArray *dataForPlot;
}

@property(nonatomic, retain) IBOutlet CPTGraphHostingView* hostView;

@property(nonatomic, retain) IBOutlet UITableView * playerTableView;

@property(nonatomic, retain) IBOutlet UISearchBar * playerSearchBar;

@property (nonatomic, readwrite, strong) NSMutableArray *dataForPlot;

@property (nonatomic, retain) IBOutlet UIView * playerSearchView;

@property (nonatomic, retain) IBOutlet UIImageView * backButton;

@property (nonatomic, retain) IBOutlet UIImageView * profileImage;

@property(strong, nonatomic) Player * player;


@end
