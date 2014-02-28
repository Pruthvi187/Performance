//
//  TeamStatsViewController.h
//  Waratahs
//
//  Created by Pruthvi on 14/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot-CocoaTouch.h>
#import "PlayerProfileViewController.h"

@class Player;

@interface TeamStatsViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,
            UICollectionViewDelegateFlowLayout, UIPageViewControllerDelegate, UIPageViewControllerDataSource, CPTPlotDataSource, CPTPlotDelegate>
{
    CPTXYGraph * graph;
    NSMutableArray *dataForPlot;
}

@property(nonatomic, retain) IBOutlet CPTGraphHostingView* hostView;

@property(nonatomic, retain) PlayerProfileViewController * playerProfileViewController;

@property(nonatomic, retain) IBOutlet UIButton * backButton;

@property(nonatomic, retain) IBOutlet UIScrollView * contentScrollView;

@property(nonatomic, retain) IBOutlet UICollectionView * graphCollectionView;

@property(strong, nonatomic) Player * player;

-(IBAction)dismissView:(id)sender;

@end
