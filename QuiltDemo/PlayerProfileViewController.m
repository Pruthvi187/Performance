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
#import "PlayerDetailViewController.h"
#import "DataModel.h"
#import "ModelItems.h"
#import "PlayerItems.h"
#import "Utilities.h"
#import "Player.h"

#import <QuartzCore/QuartzCore.h>

#define FILTER_KEY @"Filter"
#define SORT_KEY @"Sort"

#define FILTER_TAG 5
#define SORT_TAG 6

@interface PlayerProfileViewController () {
    BOOL isAnimating;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray* models;
@property (nonatomic) NSMutableArray * players;
@end

int num = 0;

@implementation PlayerProfileViewController


- (void)viewDidLoad {
    
    [self initialiseOptions];
    
    UIImage *backGroundImage = [UIImage imageNamed:@"background.png"];
    UIImageView * backImageView = [[UIImageView alloc] initWithImage:backGroundImage];
    backImageView.frame = self.view.frame;
    [self.view addSubview:backImageView];
    [self.view sendSubviewToBack:backImageView];
 
    
    UINib *industryNib = [UINib nibWithNibName:@"PlayerProfileCollectionCell" bundle:nil];
    [self.collectionView registerNib:industryNib forCellWithReuseIdentifier:@"PlayerProfileCollectionCell"];
    
    dataModel = [DataModel sharedClient];
    
    //ModelItems * modelItems = [dataModel getModelItems];
    
    PlayerItems * playerItems = nil;
    playerItems = [dataModel getPlayerItems:nil forMainPosition:nil];
    
    
    //self.models = [@[] mutableCopy];
    //[self.models setArray:modelItems.models];
    
    self.players = [@[] mutableCopy];
    [self.players setArray:playerItems.players];
    
   // [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    RFQuiltLayout* layout = (id)[self.collectionView collectionViewLayout];
    layout.direction = UICollectionViewScrollDirectionVertical;
    layout.blockPixels = CGSizeMake(155, 215);
    
    [self.collectionView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
   // [self.collectionView reloadData];
}

-(void) initialiseOptions
{
    utilities = [Utilities sharedClient];
    
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
    return self.players.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayerProfileCollectionCell * cell= (PlayerProfileCollectionCell *)[cv dequeueReusableCellWithReuseIdentifier:@"PlayerProfileCollectionCell" forIndexPath:indexPath];
    
    Player * player = [self.players objectAtIndex:indexPath.row];
    
    cell.playerImage.image = [UIImage imageNamed:player.Image];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*TeamStatsViewController *teamStatsViewController = [[TeamStatsViewController alloc] initWithNibName:@"TeamStatsViewController" bundle:nil];
    teamStatsViewController.view.backgroundColor = [UIColor blueColor];
    //teamStatsViewController.view.alpha = 0.5f;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:teamStatsViewController animated:NO completion:nil];
    
    teamStatsViewController.view.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0.4 options:UIModalTransitionStyleFlipHorizontal animations:^{
         teamStatsViewController.view.alpha = 0.5;
    } completion:nil];*/

    PlayerDetailViewController * playerDetailViewController = [[PlayerDetailViewController alloc] initWithNibName:@"PlayerDetailViewController" bundle:nil];
    playerDetailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    playerDetailViewController.player = [self.players objectAtIndex:indexPath.row];
    [self presentViewController:playerDetailViewController animated:YES completion:nil];
    
    
    
   
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
    
    if(indexPath.row >= self.players.count)
        NSLog(@"Asking for index paths of non-existant cells!! %d from %d cells", indexPath.row, self.players.count);
    
    if (indexPath.row % 13 == 0)
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([menuTableView tag] == FILTER_TAG)
    {
        if(indexPath.row == 0)
        {
            [self updatePlayers:nil forMainPosition:nil];
        }
        else if(indexPath.row == 1)
        {
            [self updatePlayers:nil forMainPosition:@"Forwards"];
        }
        else if(indexPath.row == 2)
        {
            [self updatePlayers:nil forMainPosition:@"Backs"];
        }
        else
        {
        NSLog(@"Player is %@", [filterOptions objectAtIndex:indexPath.row]);
            [self updatePlayers:[filterOptions objectAtIndex:indexPath.row] forMainPosition:nil];
        }
        [filterController dismissPopoverAnimated:YES];
    }
}

-(void) updatePlayers:(NSString *) position forMainPosition:(NSString*)mainPosition
{
    self.players = nil;
    self.players = [@[] mutableCopy];
    PlayerItems * playerItems = nil;
    playerItems = [dataModel getPlayerItems:position forMainPosition:mainPosition];
    [self.players setArray:playerItems.players];
    
    [self.collectionView reloadData];
    
}

@end
