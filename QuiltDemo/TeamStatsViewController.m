//
//  TeamStatsViewController.m
//  Waratahs
//
//  Created by Pruthvi on 14/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "TeamStatsViewController.h"
#import "GraphCollectionCell.h"

@interface TeamStatsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *statsGraphArray;

@end

@implementation TeamStatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom se
       
    }
    return self;
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
     self.contentScrollView.contentSize = CGSizeMake(1024, 1500);
}

- (void)viewDidLoad
{
    
    self.contentScrollView.scrollEnabled = YES;
    
    UINib * graphCellNib = [UINib nibWithNibName:@"GraphCollectionCell" bundle:nil];
    [self.graphCollectionView registerNib:graphCellNib forCellWithReuseIdentifier:@"GraphCollectionCell"];
    self.statsGraphArray = [[NSMutableArray alloc] initWithObjects:@"stats-graph1", @"stats-graph2", @"stats-graph3", @"stats-graph4", @"stats-graph5",nil];

    
}

-(IBAction)dismissView:(id)sender
{
    NSLog(@"Clicked");
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

#pragma mark CollectionView Delegate methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.statsGraphArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GraphCollectionCell * graphCollectionCell = (GraphCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"GraphCollectionCell" forIndexPath:indexPath];
    
    [graphCollectionCell.graphImageView setImage:[UIImage imageNamed:[self.statsGraphArray objectAtIndex:indexPath.row]]];
    
    return graphCollectionCell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(1024, 200);
}

#pragma mark UIPageControl Delegate methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentIndex = self.graphCollectionView.contentOffset.x / self.graphCollectionView.frame.size.width;
    self.pageControl.currentPage = currentIndex;
}



@end
