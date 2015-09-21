//
//  TeamStatsViewController.h
//  Waratahs
//
//  Created by Pruthvi on 14/02/14.
 
//

#import <UIKit/UIKit.h>
#import <CorePlot-CocoaTouch.h>
#import "PlayerProfileViewController.h"

@class Player;

@interface TeamStatsViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,
            UICollectionViewDelegateFlowLayout, CPTPlotDataSource, CPTPlotDelegate>
{
    CPTXYGraph * graph;
    NSMutableArray *dataForPlot;
}

@property(nonatomic, weak) IBOutlet CPTGraphHostingView* hostView;

@property(nonatomic, weak) PlayerProfileViewController * playerProfileViewController;

@property(nonatomic, weak) IBOutlet UIButton * backButton;

@property(nonatomic, weak) IBOutlet UIScrollView * contentScrollView;

@property(nonatomic, weak) IBOutlet UICollectionView * graphCollectionView;

@property(strong, nonatomic) Player * player;

-(IBAction)dismissView:(id)sender;

@end
