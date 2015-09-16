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
#import "Colours.h"
#import "StatsVC.h"

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
    [super viewDidLoad];
    [self initialiseOptions];
    
    UIImage *backGroundImage = [UIImage imageNamed:@"Background"];
    UIImageView * backImageView = [[UIImageView alloc] initWithImage:backGroundImage];
    backImageView.frame = self.view.frame;
    [self.view addSubview:backImageView];
    [self.view sendSubviewToBack:backImageView];
    
   // self.optionsPlaceHolderView.backgroundColor = UIColorFromHexWithAlpha(0x001B4A, 0.75);
 
    
    UINib *industryNib = [UINib nibWithNibName:@"PlayerProfileCollectionCell" bundle:nil];
    [self.collectionView registerNib:industryNib forCellWithReuseIdentifier:@"PlayerProfileCollectionCell"];
    
    dataModel = [DataModel sharedClient];
    
    PlayerItems * playerItems = nil;
    playerItems = [dataModel getSoldierItems:nil forMainPosition:nil];
    
    self.players = [@[] mutableCopy];
    [self.players setArray:playerItems.players];
    
    RFQuiltLayout* layout = (id)[self.collectionView collectionViewLayout];
    layout.direction = UICollectionViewScrollDirectionVertical;
    layout.blockPixels = CGSizeMake(221, 290);
    
    [self sortPlayers:@"RiskRating" sortKind:NO];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTeamStats:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.teamStatsOpenButton addGestureRecognizer:singleTap];
    [self.teamStatsOpenButton setUserInteractionEnabled:YES];
    
    
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
    NSLog(@"Tag is %ld and %ld", menuTableView.tag, [sender tag]);
    menuTableView.backgroundColor = [UIColor clearColor];
    popOverController.view = menuTableView;
    popOverController.preferredContentSize = CGSizeMake(450, 250);
    filterController = [[UIPopoverController alloc] initWithContentViewController:popOverController];
    filterController.delegate =self;
    [filterController presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}


-(BOOL)prefersStatusBarHidden{
    return NO;
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.players.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayerProfileCollectionCell * cell= (PlayerProfileCollectionCell *)[cv dequeueReusableCellWithReuseIdentifier:@"PlayerProfileCollectionCell" forIndexPath:indexPath];
    
    Player * player = [self.players objectAtIndex:indexPath.row];
    
    cell.playerImage.image = [UIImage imageNamed:player.Image];
    [cell.playerName setText:player.Name];
    
    
    
    NSMutableAttributedString * riskText = [utilities getAttributedString:[NSString stringWithFormat:@"%@%@", player.RiskRating, @"%"]];
    NSMutableAttributedString * fitnessText = [utilities getAttributedString:[NSString stringWithFormat:@"%@%@", player.FitnessRating, @"%"]];
    NSMutableAttributedString * wellBeingText = [utilities getAttributedString:[NSString stringWithFormat:@"%@%@", player.Wellbeing, @"%"]];

    [cell.riskText setAttributedText:riskText];
    [cell.fitnessText setAttributedText:fitnessText];
    [cell.wellBeingText setAttributedText:wellBeingText];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   

    PlayerDetailViewController * playerDetailViewController = [[PlayerDetailViewController alloc] initWithNibName:@"PlayerDetailViewController" bundle:nil];
    playerDetailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    playerDetailViewController.player = [self.players objectAtIndex:indexPath.row];
    playerDetailViewController.view.alpha = 1;
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:playerDetailViewController];
    [self presentViewController:navController animated:YES completion:nil];
    //[navController pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>]
}


#pragma mark – RFQuiltLayoutDelegate

- (CGSize) blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row >= self.players.count)
        NSLog(@"Asking for index paths of non-existant cells!! %ld from %lu cells", indexPath.row, (unsigned long)self.players.count);
    
   // if (indexPath.row % 13 == 0)
   //     return CGSizeMake(2, 2);
    
    
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
        [self.filterLabel setText:[filterOptions objectAtIndex:indexPath.row]];
        [filterController dismissPopoverAnimated:YES];
    }
    else
    {
        if(indexPath.row == 0)
        {
            [self sortPlayers:@"RiskRating" sortKind:NO];
        }
        else if (indexPath.row == 1)
        {
            [self sortPlayers:@"RiskRating" sortKind:YES];
        }
        else if (indexPath.row == 2)
        {
            [self sortPlayers:@"FitnessRating" sortKind:NO];
        }
        else if(indexPath.row == 3)
        {
            [self sortPlayers:@"Wellbeing" sortKind:NO];
        }
        [self.sortLabel setText:[sortOptions objectAtIndex:indexPath.row]];
        [filterController dismissPopoverAnimated:YES];
    }
}

-(void) updatePlayers:(NSString *) position forMainPosition:(NSString*)mainPosition
{
    self.players = nil;
    self.players = [@[] mutableCopy];
    PlayerItems * playerItems = nil;
    playerItems = [dataModel getSoldierItems:position forMainPosition:mainPosition];
    [self.players setArray:playerItems.players];
    
    [self.collectionView reloadData];
    
}

-(void) sortPlayers:(NSString*)sortType sortKind:(BOOL)ascending
{
   
    PlayerItems * playerItems = nil;
    playerItems = [utilities getSortedPlayerItems:sortType withSortKind:ascending withPlayers:self.players];
    self.players = nil;
    self.players = [@[] mutableCopy];
    [self.players setArray:playerItems.players];
    
    [self.collectionView reloadData];
}

-(void)showTeamStats:(id)sender
{
    StatsVC *teamStatsViewController = [[StatsVC alloc] initWithNibName:@"StatsVC" bundle:nil];
    teamStatsViewController.view.backgroundColor = UIColorFromHexWithAlpha(0x001A49, 0.9);
   
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    [teamStatsViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    
    teamStatsViewController.view.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.2 options:UIModalTransitionStyleFlipHorizontal animations:^{
     teamStatsViewController.view.alpha = 1.0;
    } completion:nil];
    teamStatsViewController.view.alpha = 1.0;
     [self presentViewController:teamStatsViewController animated:NO completion:nil];
    
}


@end
