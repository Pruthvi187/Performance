//
//  StatsVC.h
//  Waratahs
//
//  Created by Pruthvi on 14/11/2014.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CorePlot-CocoaTouch.h>

@class Player;

@interface StatsVC : UIViewController<CPTPlotDataSource, CPTPlotDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
CPTXYGraph * graph;
NSMutableArray *dataForPlot;
}
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property(nonatomic, retain) IBOutlet CPTGraphHostingView* hostView;

@property(strong, nonatomic) Player * player;

@property(nonatomic, retain) IBOutlet UICollectionView * graphCollectionView;

- (IBAction)backButtonClicked:(id)sender;

@end
