//
//  TeamStatsViewController.h
//  Waratahs
//
//  Created by Pruthvi on 14/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerProfileViewController.h"

@interface TeamStatsViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property(nonatomic, retain) PlayerProfileViewController * playerProfileViewController;

@property(nonatomic, retain) IBOutlet UIButton * backButton;

@property(nonatomic, retain) IBOutlet UIScrollView * contentScrollView;

@property(nonatomic, retain) IBOutlet UICollectionView * graphCollectionView;





-(IBAction)dismissView:(id)sender;

@end
