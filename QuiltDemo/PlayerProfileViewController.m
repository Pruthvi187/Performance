//
//  PlayerProfileViewController.m
//  Waratahs
//
//  Created by Pruthvi on 6/02/14.
//  Copyright (c) 2014 Pruthvi. All rights reserved.
//

#import "PlayerProfileViewController.h"
#import "PlayerProfileCollectionCell.h"
#import "TeamStatsViewController.h"

#import <QuartzCore/QuartzCore.h>

#define FILTER_KEY @"Filter"
#define SORT_KEY @"Sort"

#define FILTER_TAG 5
#define SORT_TAG 6

@interface PlayerProfileViewController () {
    BOOL isAnimating;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray* numbers;
@end

int num = 0;

@implementation PlayerProfileViewController


- (void)viewDidLoad {
    
    [self initialiseOptions];
    
    UINib *industryNib = [UINib nibWithNibName:@"PlayerProfileCollectionCell" bundle:nil];
    [self.collectionView registerNib:industryNib forCellWithReuseIdentifier:@"PlayerProfileCollectionCell"];
    
    self.numbers = [@[] mutableCopy];
    for(; num<20; num++) { [self.numbers addObject:@(num)]; }
    
   // [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    RFQuiltLayout* layout = (id)[self.collectionView collectionViewLayout];
    layout.direction = UICollectionViewScrollDirectionVertical;
    layout.blockPixels = CGSizeMake(117, 167);
    
    [self.collectionView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.collectionView reloadData];
}

-(void) initialiseOptions
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Options" ofType:@"plist"];
    NSDictionary *  dictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    filterOptions = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:FILTER_KEY]];
    sortOptions = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:SORT_KEY]];
}

-(IBAction)showFilterOptions:(id)sender
{
     UIButton *button = (UIButton *)sender;
    [sender setTag:FILTER_TAG];
    [self showDropDown:button.currentTitle withId:sender];
}

-(IBAction)showSortOptions:(id)sender
{
     UIButton *button = (UIButton *)sender;
    [sender setTag:SORT_TAG];
    [self showDropDown:button.currentTitle withId:sender];
}

-(void) showDropDown:(NSString *)title withId:(id)sender
{
    
    UIViewController * popOverController = [[UIViewController alloc] init];
    popOverController.title = title;
    menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(325, 30, 250, 300) style:UITableViewStylePlain];
    menuTableView.dataSource = self;
    menuTableView.delegate = self;
    [menuTableView setRowHeight:50];
    menuTableView.tag = [sender tag];
    NSLog(@"Tag is %d and %d", menuTableView.tag, [sender tag]);
    menuTableView.backgroundColor = [UIColor clearColor];
    popOverController.view = menuTableView;
    popOverController.contentSizeForViewInPopover = CGSizeMake(450, 350);
    filterController = [[UIPopoverController alloc] initWithContentViewController:popOverController];
    filterController.delegate =self;
    [filterController presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}



#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.numbers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
      PlayerProfileCollectionCell * cell= (PlayerProfileCollectionCell *)[cv dequeueReusableCellWithReuseIdentifier:@"PlayerProfileCollectionCell" forIndexPath:indexPath];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TeamStatsViewController *teamStatsViewController = [[TeamStatsViewController alloc] initWithNibName:@"TeamStatsViewController" bundle:nil];
    teamStatsViewController.view.backgroundColor = [UIColor blueColor];
    //teamStatsViewController.view.alpha = 0.5f;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:teamStatsViewController animated:NO completion:nil];
    
    teamStatsViewController.view.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        teamStatsViewController.view.alpha = 0.5;
    }];
    
    
    
    
   
    /*[self addChildViewController:teamStatsViewController];
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.4f];
    teamStatsViewController.view.alpha = 0.5f;
    teamStatsViewController.view.frame = CGRectMake(0, 40, 1024, 730);
    [UIView commitAnimations];
    [teamStatsViewController.view setTag:100];
    [self.view addSubview:teamStatsViewController.view];
    [teamStatsViewController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:teamStatsViewController.view];*/

}



#pragma mark – RFQuiltLayoutDelegate

- (CGSize) blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row >= self.numbers.count)
        NSLog(@"Asking for index paths of non-existant cells!! %d from %d cells", indexPath.row, self.numbers.count);
    
    if (indexPath.row % 11 == 0)
        return CGSizeMake(2, 2);
    
    
    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(2, 2, 5, 5);
}

#pragma TableView Delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(menuTableView.tag == FILTER_TAG)
        return [filterOptions count];
    else
        return [sortOptions count];
}


-(UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"Cell";
    UITableViewCell *cell = [menuTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = ([menuTableView tag] == FILTER_TAG ? [filterOptions objectAtIndex:indexPath.row] : [sortOptions objectAtIndex:indexPath.row]);
    
    
    return cell;
}


@end
