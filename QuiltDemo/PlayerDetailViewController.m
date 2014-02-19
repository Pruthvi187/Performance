//
//  PlayerDetailViewController.m
//  Waratahs
//
//  Created by Pruthvi on 17/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "PlayerSearchCell.h"
#import "PlayerItems.h"
#import "DataModel.h"
#import "Player.h"

static NSString *const MAIN_PLOT      = @"Scatter Plot";
static NSString *const SELECTION_PLOT = @"Selection Plot";

@interface PlayerDetailViewController ()
{
    DataModel * dataModel;
}
@property (nonatomic) NSMutableArray * players;
@property (strong,nonatomic) NSMutableArray *filteredPlayersArray;

@end

@implementation PlayerDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.profileImage setImage:[UIImage imageNamed:self.player.ProfileImage]];
    
    //self.playerTableView.tableHeaderView = self.playerSearchBar;
    
    for (UIView *subView in self.playerSearchBar.subviews)
    {
        for (UIView *secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]])
            {
                UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                
                //set font color here
                searchBarTextField.textColor = [UIColor whiteColor];
                
                break;
            }
        }
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonPressed)];
    singleTap.numberOfTapsRequired = 1;
    self.backButton.userInteractionEnabled = YES;
    [self.backButton addGestureRecognizer:singleTap];
    
    
    
    UITextField *searchField = [self.playerSearchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    
    self.playerSearchBar.layer.borderWidth = 1;
    self.playerSearchBar.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.playerSearchBar.layer.cornerRadius = 15.0f;
    
    UIImage *backGroundImage = [UIImage imageNamed:@"background.png"];
    UIImageView * backImageView = [[UIImageView alloc] initWithImage:backGroundImage];
    backImageView.frame = self.playerSearchView.frame;
    [self.playerSearchView addSubview:backImageView];
    [self.playerSearchView sendSubviewToBack:backImageView];
    
   
    
    UINib *playerCellNib = [UINib nibWithNibName:@"PlayerSearchCell" bundle:nil];
    [self.playerTableView registerNib:playerCellNib forCellReuseIdentifier:@"PlayerCell"];
    
    self.players = [@[] mutableCopy];
    dataModel = [DataModel sharedClient];
    PlayerItems * playerItems = [dataModel getPlayerItems:nil forMainPosition:nil];
    self.players = playerItems.players;
    
    [self initializeData];
   
    [self setupGraph];
    
    [self setupAxes];
    
    [self setupScatterPlots];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupGraph
{
    // Create graph and apply a dark theme
    graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame : self.hostView.bounds];
    graph.backgroundColor = [[UIColor clearColor] CGColor];
    graph.plotAreaFrame.backgroundColor = [[UIColor clearColor] CGColor];
    graph.plotAreaFrame.plotArea.backgroundColor = [[UIColor clearColor] CGColor];
    
    self.hostView.hostedGraph = graph;
 
    
}

-(void) setupAxes
{
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:1.0];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.dashPattern = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1],nil];
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:1.0];
    
    // Label y with an automatic label policy.
    // Axes
    // Label x axis with a fixed interval policy
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy              = CPTAxisLabelingPolicyEqualDivisions;
    y.minorTicksPerInterval       = 2;
    y.preferredNumberOfMajorTicks = 1;
    y.majorGridLineStyle          = majorGridLineStyle;
    y.minorGridLineStyle          = minorGridLineStyle;
   
    
  
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy              = CPTAxisLabelingPolicyNone;
    NSMutableSet *tickLocations = [NSMutableSet set];
    for ( NSUInteger loc = 2; loc <= 10; loc=loc+2 ) {
        [tickLocations addObject:[NSDecimalNumber numberWithUnsignedInteger:loc]];
    }
    x.majorTickLocations = tickLocations;
    x.minorTicksPerInterval       = 0;
    x.preferredNumberOfMajorTicks = 5;
    x.majorGridLineStyle          = majorGridLineStyle;
    x.minorGridLineStyle          = minorGridLineStyle;
    

}

-(void) setupScatterPlots
{
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    
    dataSourceLinePlot.identifier     = MAIN_PLOT;
    dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 2.0;
    lineStyle.lineColor              = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // Set plot delegate, to know when symbols have been touched
    // We will display an annotation when a symbol is touched
    dataSourceLinePlot.delegate                        = self;
   // dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0;
    
    // Create a plot for the selection marker
    CPTScatterPlot *selectionPlot = [[CPTScatterPlot alloc] init];
    selectionPlot.identifier     = SELECTION_PLOT;
    selectionPlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    lineStyle                   = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth         = 2.0;
    lineStyle.lineColor         = [CPTColor redColor];
    selectionPlot.dataLineStyle = lineStyle;
    
    selectionPlot.dataSource = self;
    [graph addPlot:selectionPlot];
    
    // Auto scale the plot space to fit the plot data
    // Compress ranges so we can scroll
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    [plotSpace scaleToFitPlots:[NSArray arrayWithObject:dataSourceLinePlot]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromDouble(1.0)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromDouble(1.0)];
    plotSpace.yRange = yRange;
    
    CPTPlotRange *globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(10.0)];
    plotSpace.globalXRange = globalXRange;
    CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(10.0)];
    plotSpace.globalYRange = globalYRange;
}

-(void)initializeData
{
    
    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:15];
    
    for ( NSUInteger i = 0; i < 15; i++ ) {
        id x = [NSNumber numberWithDouble:i * 0.5];
        id y = [NSNumber numberWithDouble:2.0 * rand() / (double)RAND_MAX];
        [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
    self.dataForPlot = contentArray;
}


#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 15;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSNumber *num = nil;
    
    
    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    num = [[self.dataForPlot objectAtIndex:index] valueForKey:key];
    
    
    return num;
}

-(CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)index
{
    static CPTPlotSymbol *redDot = nil;
    
    CPTPlotSymbol *symbol = (id)[NSNull null];
    
    if ( [(NSString *)plot.identifier isEqualToString : SELECTION_PLOT] && index == 14) {
        if ( !redDot ) {
            redDot            = [[CPTPlotSymbol alloc] init];
            redDot.symbolType = CPTPlotSymbolTypeEllipse;
            redDot.size       = CGSizeMake(5.0, 5.0);
            redDot.fill       = [CPTFill fillWithColor:[CPTColor redColor]];
        }
        symbol = redDot;
    }
    
    return symbol;
}

#pragma TableView Delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.players.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"PlayerCell";
    PlayerSearchCell *cell = [self.playerTableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                        forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [UIView new];
    cell.selectedBackgroundView = [UIView new];
    
    Player * player = [self.players objectAtIndex:indexPath.row];
    cell.playerImage.image = [UIImage imageNamed:player.Image];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.playerSearchBar resignFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma Predicate Delegates

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if(searchText.length  > 0)
    {
     NSArray *filteredarray = [self.players filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Name CONTAINS[cd] %@)", searchText]];
    self.players = nil;
    self.players = [@[] mutableCopy];
    [self.players setArray:filteredarray];
    [self.playerTableView reloadData];
    }
    else
    {
        self.players = nil;
        dataModel = [DataModel sharedClient];
        PlayerItems * playerItems = [dataModel getPlayerItems:nil forMainPosition:nil];
        self.players = playerItems.players;

        [self.playerTableView reloadData];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [self filterContentForSearchText:searchText
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
}


-(void)backButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
