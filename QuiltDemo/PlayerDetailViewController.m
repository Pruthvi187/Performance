//
//  PlayerDetailViewController.m
//  Waratahs
//
//  Created by Pruthvi on 17/02/14.
 
//

#import "PlayerDetailViewController.h"
#import "PlayerSearchCell.h"
#import "PlayerItems.h"
#import "DataModel.h"
#import "Player.h"
#import "TabBarView.h"
#import "FitnessView.h"
#import "RiskView.h"
#import "ModelItems.h"
#import "Model.h"
#import "WellnessPlayers.h"
#import "Wellness.h"
#import "WellnessView.h"
#import "Utilities.h"
#import "Colours.h"
#import "RiskEditViewController.h"
#import "CustomPresentationController.h"
#import "CustomDismissController.h"
#import "DimmingPresentationController.h"

static NSString *const MAIN_PLOT      = @"Scatter Plot";
static NSString *const SELECTION_PLOT = @"Selection Plot";
static CGFloat UNSELECTED_ALPHA = 0.6;

typedef enum {
    FITNESS   = 1,
    RISK      = 2,
    WELLBEING = 3,
} IconValues;

@interface PlayerDetailViewController ()
{
    DataModel * dataModel;
    ModelItems * modelItems;
    Model * model;
    Model * playerModel;
    
    Utilities * utilities;
    
    BOOL isInjured;
    
    NSString * playerStatus;
    NSString * playerInjuryArea;
    NSString * playerInjuryDurationWeeks;
    NSString * playerInjuryDurarionGames;
    NSString * travelDuration;
    NSString * travelWeeks;
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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_Bar_Clear"] forBarMetrics:UIBarMetricsDefault];
 
    UIFont * navBarFont = [UIFont fontWithName:@"ZurichCondensedBT" size:24];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: navBarFont}];
    
    UIBarButtonItem * leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backButton"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = leftBar;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    utilities = [Utilities sharedClient];
    
    dataModel = [DataModel sharedClient];
    
    self.players = [@[] mutableCopy];
    PlayerItems * playerItems = [dataModel getSoldierItems:nil forMainPosition:nil];
    self.players = playerItems.players;
    
    self.filteredPlayersArray = nil;
    self.filteredPlayersArray = [@[] mutableCopy];
    [self.filteredPlayersArray setArray:self.players];
 
    [self initiateViewSetUp];
}

-(void) initiateViewSetUp
{
    isInjured = FALSE;
    
    [self setupView];
    
    [self setUpTapGestures];
    
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

- (void) setUpTapGestures {
    
    UITapGestureRecognizer * injuryViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(injuryViewTapped:)];
    injuryViewTap.numberOfTouchesRequired = 1;
    injuryViewTap.numberOfTapsRequired = 1;
    [_injuryView setUserInteractionEnabled:YES];
    [_injuryView addGestureRecognizer:injuryViewTap];
    
    UITapGestureRecognizer * fitnessViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fitnessViewTapped:)];
    fitnessViewTap.numberOfTouchesRequired = 1;
    fitnessViewTap.numberOfTapsRequired = 1;
    [_fitnessView setUserInteractionEnabled:YES];
    [_fitnessView addGestureRecognizer:fitnessViewTap];
    
    UITapGestureRecognizer * wellBeingViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wellBeingViewTapped:)];
    wellBeingViewTap.numberOfTouchesRequired = 1;
    wellBeingViewTap.numberOfTapsRequired = 1;
    [_wellBeingView setUserInteractionEnabled:YES];
    [_wellBeingView addGestureRecognizer:wellBeingViewTap];

}

-(void) setupView
{

    DataModel * dataModelClient = [DataModel sharedClient];
    
    modelItems = [dataModelClient getModelItems:self.player];
    
    for(Model *item in modelItems.models)
    {
        if([item.Player_Status isEqualToString:@"INJURED"])
        {
            playerModel = item;
            isInjured = TRUE;
        }
    }
    
    model = [modelItems.models lastObject];
    
    WellnessPlayers * wellnessItems = [dataModelClient getPlayersWellness:self.player];
    
    Wellness * wellness = [wellnessItems.wellness lastObject];
    
    avg_sleep_quality = (int)floor([utilities getAverageSleepQuality:wellnessItems]);
    
    sleep_quality = wellness.Sleep_Quality;
    
    avg_leg_heaviness = (int)floor([utilities getAverageLegHeaviness:wellnessItems]);
    
    leg_heaviness = wellness.Leg_Heaviness;
    
    avg_back_pain = (int)floor([utilities getAverageBackPain:wellnessItems]);
    
    back_pain  = wellness.BackPain;
    
    avg_calves = (int)floor([utilities getAverageCalves:wellnessItems]);
    
    calves = wellness.Calves;
    
    avg_recovery_index = (int)floor([utilities getAverageRecoveryIndex:wellnessItems]);
    
    recovery_index = wellness.Recovery_Index;
    
    avg_muscle_soreness = (int)floor([utilities getAverageMuscleSoreness:wellnessItems]);
    
    muscle_soreness = wellness.Muscle_Soreness;
    
    avg_training_state = (int)floor([utilities getAverageTrainingState:wellnessItems]);

    training_state = wellness.Traning_State;
    
    avg_rom_tightness = (int)floor([utilities getAverageROMTightness:wellnessItems]);
    
    rom_tightness = wellness.ROM_Tightness;
    
    avg_hipflexor_quads = (int)floor([utilities getAverageHipFlexorQuad:wellnessItems]);
    
    hipflexor_quads = wellness.HipFlexor_Quads;
    
    avg_groins = (int)floor([utilities getAverageGroin:wellnessItems]);
    
    groins = wellness.Groin;
    
    avg_hamstring = (int)floor([utilities getAverageHamstrings:wellnessItems]);
    
    hamstrings = wellness.Hamstring;
    
    avg_sitreach = (int)floor([utilities getAverageSitAndReach:modelItems]);
    
    sitReach = model.SitReach;
    
    avg_hiprotationr = (int)floor([utilities getAverageHipRotationR:modelItems]);
    
    hipRotationL = model.HipRotation_L;
    
    avg_hiprotationl = (int)floor([utilities getAverageHipRotationR:modelItems]);
    
    hipRotationR = model.HipRotation_R;
    
    avg_groinSqueeze0 = (int)floor([utilities getAverageGroinSqueezeZero:modelItems]);
    
    groinSqueeze0 = model.GroinSqueeze_0;
    
    avg_groinSqueeze60 = (int)floor([utilities getAverageGroinSqueeze60:modelItems]);
    
    groinSqueeze60 = model.GroinSqueeze_60;
    
    avg_sumofvol = (int)floor([utilities getAverageSumofVolume:modelItems]);
    
    SumofVol = model.Sum_ofV2;
    
    avg_AcclEvents = (int)floor([utilities getAverageAcceleration:modelItems]);
    
    AcclEvents = model.Sumof_AccTotal;
    
    avg_TotalDist = (int)floor([utilities getAverageTotalDistance:modelItems]);
    
    TotalDistance = model.SumofVol;
    
    avg_forceLoadPM = (int)floor(([utilities getAverageForceLoadPM:modelItems]));
    
    forceLoadPM  = model.AverageoffLmin;
    
    avg_percievedExertion = (int)floor([utilities getAveragePercievedExertionRate:wellnessItems]);
    
    percievedExertion = wellness.Perceived_Performance;
    
    avg_velChangeLoad = (int)floor([utilities getAverageVelocityChangeLoad:modelItems]);
    
    velChangeLoad = model.SumofVCLoadTotal;
    
    avg_velLoadPM = (int)floor(([utilities getAverageVelocityLoadPM:modelItems]));
    
    velLoadPM = model.AverageofvLmin;
    
    avg_TotalSprintDist = (int)floor([utilities getAverageTotalSprintDistance:modelItems]);
    
    totalSprintDistance = model.SumofSpr;
    
    [self.riskChangeLabel setText:[NSString stringWithFormat:@"%@%@",self.player.RiskRatingChange,@"%"]];
    
    if([self.player.RiskRatingChange intValue] < 0)
    {
        [self.riskchangeImage setImage:[UIImage imageNamed:@"icon-triangle-down-green"]];
        [self.riskChangeLabel setTextColor:UIColorFromHex(0x53B61D)];
    }
    else
    {
        [self.riskchangeImage setImage:[UIImage imageNamed:@"icon-triangle-up-red"]];
        [self.riskChangeLabel setTextColor:[UIColor redColor]];
    }
    
    self.dobLabel.text = self.player.DOB;
    
    self.ageLabel.text = self.player.Age;
    
    self.debutLabel.text = self.player.Enlisted;
    
    self.heightLabel.text = self.player.Height;
    
    self.weightLabel.text = self.player.Weight;
    
    self.positionLabel.text = self.player.Position;
    
    self.capsLabel.text = self.player.Caps;
    
    //self.yearsPlayingLabel.text = [NSString stringWithFormat:@"%@",model.Yrs_Playing];
    
    [self.profileImage setImage:[UIImage imageNamed:self.player.Image]];
    
    [self.playerName setText:self.player.Name];
    
    [self.riskRatingLabel setText:[NSString stringWithFormat:@"%@%@",self.player.RiskRating,@"%"]];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonPressed)];
    singleTap.numberOfTapsRequired = 1;
    self.backButton.userInteractionEnabled = YES;
    [self.backButton addGestureRecognizer:singleTap];
    
    UITextField *searchField = [self.playerSearchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor blackColor];
    [searchField setBorderStyle:UITextBorderStyleNone];
    // Change the search bar placeholder text color
    [searchField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.playerSearchBar setImage:[UIImage imageNamed:@"Search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    UIImage *backGroundGradientImage = [UIImage imageNamed:@"player-bg-top.png"];
    UIImageView * backGradientImageView = [[UIImageView alloc] initWithImage:backGroundGradientImage];
    backGradientImageView.frame = CGRectMake(215, 0, 820, 520);
    [self.view addSubview:backGradientImageView];
    [self.view sendSubviewToBack:backGradientImageView];
    
    UINib *playerCellNib = [UINib nibWithNibName:@"PlayerSearchCell" bundle:nil];
    [self.playerTableView registerNib:playerCellNib forCellReuseIdentifier:@"PlayerCell"];
    
    self.tabScrollView.delegate = self;
    
    self.tabScrollView.scrollEnabled = YES;
    
    self.mainScrollView.delegate = self;
    
    self.mainScrollView.scrollEnabled = YES;
    
    [self setIcon:self.fitnessIndicatorImage withPercentage:[self.player.FitnessRating doubleValue] withValue:FITNESS];
    [self setIcon:self.injuryRiskImage withPercentage:[self.player.RiskRatingValue doubleValue] withValue:RISK];
    [self setIcon:self.wellBeingIndicatorImage withPercentage:[self.player.Wellbeing doubleValue] withValue:WELLBEING];
    
    [self setUpRiskView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tabScrollView.contentSize =CGSizeMake(320.0f, 650.0f);
    self.mainScrollView.contentSize = CGSizeMake(1024.0f,2000.0f);
}

-(void) setupGraph
{
    // Create graph and apply a dark theme
    graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame : self.hostView.bounds];
    graph.plotAreaFrame.backgroundColor = [[UIColor clearColor] CGColor];
    graph.plotAreaFrame.plotArea.backgroundColor = [[UIColor clearColor] CGColor];
    
    self.hostView.hostedGraph = graph;
    
    graph.paddingBottom = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingRight  = 0.0f;
    graph.paddingLeft = 0.0f;
    
}

-(void) setupAxes
{
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.8;
    majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:1.0];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.dashPattern = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:3],nil];
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:1.0];
    
    // Label y with an automatic label policy.
    // Axes
    // Label x axis with a fixed interval policy
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy              = CPTAxisLabelingPolicyEqualDivisions;
    
    
    y.minorTicksPerInterval       = 0;
    y.preferredNumberOfMajorTicks = 0;
    y.majorGridLineStyle          = majorGridLineStyle;
    y.minorGridLineStyle          = minorGridLineStyle;
   
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy              = CPTAxisLabelingPolicyEqualDivisions;
  
    x.minorTicksPerInterval       = 0;
    x.preferredNumberOfMajorTicks = 0;
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
    [yRange expandRangeByFactor:CPTDecimalFromDouble(10.0)];
    plotSpace.yRange = yRange;
    
    CPTPlotRange *globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(10.0)];
    plotSpace.globalXRange = globalXRange;
    CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(100.0)];
    plotSpace.globalYRange = globalYRange;
}

-(void)initializeData
{
    
    self.players = [@[] mutableCopy];
    PlayerItems * playerItems = [dataModel getSoldierItems:nil forMainPosition:nil];
    self.players = playerItems.players;
    
    [self.navigationController.navigationBar.topItem setTitle:self.player.Name];

    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:15];
    
    for ( NSUInteger i = 0; i < 15; i++ ) {
        id x = [NSNumber numberWithDouble:i * 0.5];
        id y;
        if(i <14)
        {
            float low_bound = [self.player.RiskRating intValue]  - 20;
            low_bound = low_bound > 0 ? low_bound : 0;
            float high_bound = [self.player.RiskRating intValue] + 20 ;
            high_bound = high_bound > 100 ? 90 : high_bound;
            float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
            y = [NSNumber numberWithFloat:rndValue];
        }
        else
        {
            y = [NSNumber numberWithDouble:[self.player.RiskRating intValue]];
        }
        [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
    self.dataForPlot = contentArray;
    
    [self.injuryLabel setText:[NSString stringWithFormat:@"%@%@",self.player.RiskRating, @"% Risk of injury"]];
    [self.fitnessText setText:[NSString stringWithFormat:@"%@%@",self.player.FitnessRating, @"% Fitness"]];
    [self.wellBeingText setText:[NSString stringWithFormat:@"%@%@",self.player.Wellbeing, @"% Wellbeing"]];
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
    return self.filteredPlayersArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"PlayerCell";
    PlayerSearchCell *cell = [self.playerTableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                        forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [UIView new];
    cell.selectedBackgroundView = [UIView new];

    
    Player * player = [self.filteredPlayersArray objectAtIndex:indexPath.row];
    cell.playerImage.image = [UIImage imageNamed:player.Image];
    [cell.playerName setText:player.Name];
    [cell.playerRiskLabel setAttributedText:[utilities getAttributedString:[NSString stringWithFormat:@"%@%@", player.RiskRating, @"%"] mainTextFontSize:12 subTextFontSize:10]];
    [cell.playerWellBeingLabel setAttributedText:[utilities getAttributedString:[NSString stringWithFormat:@"%@%@", player.Wellbeing, @"%"] mainTextFontSize:12 subTextFontSize:10]];
    [cell.playerFitnessLabel setAttributedText:[utilities getAttributedString:[NSString stringWithFormat:@"%@%@", player.FitnessRating, @"%"] mainTextFontSize:12 subTextFontSize:10]];
    //self.player = player;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.playerSearchBar resignFirstResponder];
    self.player = [self.filteredPlayersArray objectAtIndex:indexPath.row];
    [self.navigationController.navigationBar.topItem setTitle:[self.player.Name uppercaseString]];
    [self initiateViewSetUp];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 215;
}


#pragma Predicate Delegates

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if(searchText.length  > 0) {
        
         NSArray *filteredarray = [self.filteredPlayersArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Name CONTAINS[cd] %@)", searchText]];
        self.filteredPlayersArray = nil;
        self.filteredPlayersArray = [@[] mutableCopy];
        [self.filteredPlayersArray setArray:filteredarray];
        [self.playerTableView reloadData];
        
    } else {
        
        self.filteredPlayersArray = nil;
        dataModel = [DataModel sharedClient];
        PlayerItems * playerItems = [dataModel getSoldierItems:nil forMainPosition:nil];
        self.filteredPlayersArray = playerItems.players;

        [self.playerTableView reloadData];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.placeholder = nil;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.placeholder = @"Search";
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [self filterContentForSearchText:searchText
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
}


-(void)backButtonPressed: (id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma Tab button click action events

-(void) fitnessViewTapped:(id)sender
{
    [self setupFitnessView];
    
}

-(void) setupFitnessView {
    
    [_graphView setHidden:YES];
    
    
    if (riskView) {
        [riskView removeFromSuperview];
    }
    
    if (wellnessView) {
        [wellnessView removeFromSuperview];
    }
    
    if (fitnessView) {
        [fitnessView removeFromSuperview];
    }
    
    int overallFitnessCount = 0;
    
    [self.fitnessButton setImage:[UIImage imageNamed:@"tab-selected"] forState:UIControlStateNormal];
    [self.riskButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
    [self.wellBeingButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
    
    [self.fitnessLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
    [self.riskLabel setTextColor:[UIColor colorWithRed:0/255.0 green:27.0/255.0 blue:72.0/255.0 alpha:1]];
    [self.wellbeingLabel setTextColor:[UIColor colorWithRed:0/255.0 green:27.0/255.0 blue:72.0/255.0 alpha:1]];

    
    wellnessView.hidden = YES;
    //fitnessView.hidden = YES;
    riskView.hidden = YES;
    
    fitnessView = [[[NSBundle mainBundle] loadNibNamed:@"FitnessView" owner:self options:nil] objectAtIndex:0];
    fitnessView.frame = CGRectMake(30, 100, 811, 315);
    [self.tabScrollView addSubview:fitnessView];
    [self.tabScrollView bringSubviewToFront:fitnessView];
    
    [self setSelectedTab:fitnessView];
    
    fitnessView.sitReachCurrent.text = [NSString stringWithFormat:@"%@",sitReach];
    fitnessView.avgssitReach.text = [NSString stringWithFormat:@"%d",avg_sitreach];
    
    fitnessView.groinSqueeze0Current.text = [NSString stringWithFormat:@"%@",groinSqueeze0];
    fitnessView.avgGroinSqueeze0.text = [NSString stringWithFormat:@"%d",avg_groinSqueeze0];
    
    fitnessView.groinSqueeze60Current.text = [NSString stringWithFormat:@"%@",groinSqueeze60];
    fitnessView.avgGroinSqueeze60.text = [NSString stringWithFormat:@"%d",avg_groinSqueeze60];
    
    fitnessView.hipRotationLCurrent.text = [NSString stringWithFormat:@"%@",hipRotationL];
    fitnessView.avghipRotationL.text = [NSString stringWithFormat:@"%d",avg_hiprotationl];
    
    fitnessView.hipRotationRCurrent.text = [NSString stringWithFormat:@"%@",hipRotationR];
    fitnessView.avghipRotationR.text = [NSString stringWithFormat:@"%d",avg_hiprotationr];
    
    fitnessView.playerStatusLabel.text = model.Player_Status;
    
    if(isInjured)
    {
        fitnessView.injurySiteLabel.hidden = FALSE;
        fitnessView.injurySiteText.hidden = FALSE;
        fitnessView.injuryIncidentlabel.hidden = FALSE;
        fitnessView.injuryIncidentText.hidden = FALSE;
        fitnessView.playerTravelLabel.hidden = FALSE;
        fitnessView.gamesMissedLabel.hidden = FALSE;
        
        fitnessView.playerStatusLabel.text = playerModel.Player_Status;
        
        if(playerModel.Injury_Site.length == 0)
        {
            playerModel.Injury_Site = @"Left hamstring";
        }
        
        if(playerModel.Injury_ProposedMechanisms.length == 0)
        {
            playerModel.Injury_ProposedMechanisms = @"During training";
        }
        
        fitnessView.injurySiteLabel.text = playerModel.Injury_Site;
        fitnessView.injuryIncidentlabel.text = playerModel.Injury_ProposedMechanisms;
        [fitnessView.gamesMissedLabel setText:[NSString stringWithFormat:@"This player has been injured for %d weeks and has missed %d games",[playerModel.InjuryDuration_Weeks intValue] + 3, [playerModel.InjuryDuration_GamesMissed intValue]]];
        
        [fitnessView.playerTravelLabel setText:[NSString stringWithFormat:@"The player has travelled %d times this season, for a total of %d days.",0, 0]];
        //[fitnessView.playerTravelLabel setText:[NSString stringWithFormat:@"The player has travelled %d times this season, for a total of %d days.",[playerModel.Travel intValue] + 4, ([playerModel.Travel_Duration intValue] + 4) *7]];
    }
    
    
    
    CGRect sitReachFrame;
    
    double sitReachPC = ([sitReach intValue]/(double)avg_sitreach);
    
    if(sitReachPC < 1)
    {
        sitReachFrame  = fitnessView.sitReachView.frame;;
    }
    else
    {
        sitReachFrame = fitnessView.avgSitReachView.frame;
    }
    
    overallFitnessCount = [self setViewChange:fitnessView.sitReachView withPercentage:sitReachPC withCount:overallFitnessCount];
    
    if(sitReachPC < 1)
    {
        sitReachFrame.size.width = sitReachFrame.size.width * sitReachPC;
        sitReachFrame.size.height = sitReachFrame.size.height;
        [fitnessView.sitReachView setFrame:sitReachFrame];
    }
    else
    {
        sitReachFrame.size.width = sitReachFrame.size.width / sitReachPC;
        sitReachFrame.size.height = sitReachFrame.size.height;
        [fitnessView.avgSitReachView setFrame:sitReachFrame];
    }
    
    /* NSLayoutConstraint * sitReachWidthConstaint = [NSLayoutConstraint constraintWithItem:fitnessView.sitReachView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:fitnessView.sitReachView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:200];
     [fitnessView.sitReachView addConstraint:sitReachWidthConstaint];*/
    // [self.view setNeedsLayout];
    
    CGRect groinSqueeze0Frame;
    
    double groinSqueeze0PC = ([groinSqueeze0 intValue]/(double)avg_groinSqueeze0);
    
    if(groinSqueeze0PC < 1)
    {
        groinSqueeze0Frame = fitnessView.groinSquuze0View.frame;
    }
    else
    {
       groinSqueeze0Frame = fitnessView.avggroinSquuze0View.frame;
    }
    
    overallFitnessCount = [self setViewChange:fitnessView.groinSquuze0View withPercentage:groinSqueeze0PC withCount:overallFitnessCount];
    
    if(groinSqueeze0PC < 1)
    {
        groinSqueeze0Frame.size.width = groinSqueeze0Frame.size.width * groinSqueeze0PC;
        groinSqueeze0Frame.size.height = groinSqueeze0Frame.size.height;
        [fitnessView.groinSquuze0View setFrame:groinSqueeze0Frame];
     }
    else
    {
        groinSqueeze0Frame.size.width = groinSqueeze0Frame.size.width / groinSqueeze0PC;
        groinSqueeze0Frame.size.height = groinSqueeze0Frame.size.height;
        [fitnessView.avggroinSquuze0View setFrame:groinSqueeze0Frame];
    }
    
    CGRect groinSqueeze60Frame;
    
    
    double groinSqueeze60PC = ([groinSqueeze60 intValue]/(double)avg_groinSqueeze60);
    
    if(groinSqueeze60PC < 1)
    {
        groinSqueeze60Frame = fitnessView.groinSquuze60View.frame;;
    }
    else
    {
        groinSqueeze60Frame = fitnessView.avgGroinSquuze60View.frame;;
    }
    
    overallFitnessCount = [self setViewChange:fitnessView.groinSquuze60View withPercentage:groinSqueeze60PC withCount:overallFitnessCount];
 
    if(groinSqueeze60PC < 1)
    {
        groinSqueeze60Frame.size.width = groinSqueeze60Frame.size.width * groinSqueeze60PC;
        groinSqueeze60Frame.size.height = groinSqueeze60Frame.size.height;
        [fitnessView.groinSquuze60View setFrame:groinSqueeze60Frame];
    }
    else
    {
        groinSqueeze60Frame.size.width = groinSqueeze60Frame.size.width / groinSqueeze60PC;
        groinSqueeze60Frame.size.height = groinSqueeze60Frame.size.height;
        [fitnessView.avgGroinSquuze60View setFrame:groinSqueeze60Frame];
    }
    
    CGRect hipRotationLFrame;
    
    double hipRotationLPC = ([hipRotationL intValue]/(double)avg_hiprotationl);
    
    if(hipRotationLPC < 1)
    {
        hipRotationLFrame = fitnessView.hipRotationL.frame;
    }
    else
    {
        hipRotationLFrame = fitnessView.avgHipRotationLView.frame;;
    }
    
    overallFitnessCount = [self setViewChange:fitnessView.hipRotationL withPercentage:hipRotationLPC withCount:overallFitnessCount];
    
    if(hipRotationLPC < 1)
    {
        hipRotationLFrame.size.width = hipRotationLFrame.size.width * hipRotationLPC;
        hipRotationLFrame.size.height = hipRotationLFrame.size.height;
        [fitnessView.hipRotationL setFrame:hipRotationLFrame];
    }
    else
    {
        hipRotationLFrame.size.width = hipRotationLFrame.size.width / hipRotationLPC;
        hipRotationLFrame.size.height = hipRotationLFrame.size.height;
        [fitnessView.avgHipRotationLView setFrame:hipRotationLFrame];
    }
    
    CGRect hipRotationRFrame;
    
    double hipRotationRPC = ([hipRotationR intValue]/(double)avg_hiprotationr);
    
    if(hipRotationRPC < 1)
    {
        hipRotationRFrame =  fitnessView.hipRotationR.frame;
    }
    else
    {
        hipRotationRFrame =  fitnessView.avgHipRotationRView.frame;
    }
    
    overallFitnessCount = [self setViewChange:fitnessView.hipRotationR withPercentage:hipRotationRPC withCount:overallFitnessCount];
    
    if(hipRotationRPC < 1)
    {
        hipRotationRFrame.size.width = hipRotationRFrame.size.width * hipRotationRPC;
        hipRotationRFrame.size.height = hipRotationRFrame.size.height;
        [fitnessView.hipRotationR setFrame:hipRotationRFrame];
    }
    else
    {
        hipRotationRFrame.size.width = hipRotationRFrame.size.width / hipRotationRPC;
        hipRotationRFrame.size.height = hipRotationRFrame.size.height;
        [fitnessView.avgHipRotationRView setFrame:hipRotationRFrame];
    }
    
    CGRect overallFitnessView = fitnessView.progressView.frame;
    
    double overallPC = overallFitnessCount/5.0;
    
    [self setViewChange:fitnessView.progressView withPercentage:overallPC withCount:0];
    
    overallFitnessView.size.width = overallFitnessView.size.width * overallPC;
    overallFitnessView.size.height = overallFitnessView.size.height;
    [fitnessView.progressView setFrame:overallFitnessView];
    
    [fitnessView.riskCountLabel setText:[NSString stringWithFormat:@"%d/5",overallFitnessCount]];
    
    [self setIcon:self.fitnessIndicatorImage withPercentage:[self.player.FitnessRating floatValue] withValue:FITNESS];
    
    [self.fitnessTabLabel setTextColor:[UIColor whiteColor]];
    [self.risTabkLabel setTextColor:UIColorFromHex(0x001B4A)];
    [self.wellbeingTabLabel setTextColor:UIColorFromHex(0x001B4A)];
    
    self.wellBeingButton.enabled = YES;
    self.riskButton.enabled = YES;
    self.fitnessButton.enabled = NO;
    
    self.riskButton.backgroundColor = [UIColor blackColor];
}

- (void) setUpRiskView {
    int overallRiskCount = 0;
    
    [_graphView setHidden:NO];
    
    if (riskView) {
        [riskView removeFromSuperview];
    }
    
    if (wellnessView) {
        [wellnessView removeFromSuperview];
    }
    
    if (fitnessView) {
        [fitnessView removeFromSuperview];
    }
    
    riskView = [[[NSBundle mainBundle] loadNibNamed:@"RiskView" owner:self options:nil] objectAtIndex:0];
    riskView.frame = CGRectMake(30, 100, 811, 315);
    [self.tabScrollView addSubview:riskView];
    [self.tabScrollView bringSubviewToFront:riskView];
    
    [self setSelectedTab:riskView];
    
    [self.riskLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
    [self.fitnessLabel setTextColor:[UIColor colorWithRed:0/255.0 green:27.0/255.0 blue:72.0/255.0 alpha:1]];
    [self.wellbeingLabel setTextColor:[UIColor colorWithRed:0/255.0 green:27.0/255.0 blue:72.0/255.0 alpha:1]];
    
    [riskView.manageRiskButton addTarget:self action:@selector(changeRiskButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    wellnessView.hidden = YES;
    fitnessView.hidden = YES;
   
    riskView.sumofVolLabel.text = [NSString stringWithFormat:@"%d",[SumofVol intValue]];
    riskView.avgsumofVolLabel.text = [NSString stringWithFormat:@"%d",avg_sumofvol];
    
    riskView.accEventsLabel.text = [NSString stringWithFormat:@"%d",[AcclEvents intValue]];
    riskView.avgaccEventsLabel.text = [NSString stringWithFormat:@"%d",avg_AcclEvents];
    
    riskView.totalDistLabel.text = [NSString stringWithFormat:@"%d",[TotalDistance intValue]];
    riskView.avgtotalDistLabel.text = [NSString stringWithFormat:@"%d",avg_TotalDist];
    
    riskView.forceLoadLabel.text = [NSString stringWithFormat:@"%d",[forceLoadPM intValue]];
    riskView.avgforceLoadLabel.text = [NSString stringWithFormat:@"%d", avg_forceLoadPM];
    
    riskView.rateofPercExertionLabel.text = [NSString stringWithFormat:@"%d", [percievedExertion intValue]];
    riskView.avgrateofPercExertionLabel.text = [NSString stringWithFormat:@"%d", avg_percievedExertion];
    
    riskView.velchangeLoadLabel.text = [NSString stringWithFormat:@"%d", [velChangeLoad intValue]];
    riskView.avgvelchangeLoadLabel.text = [NSString stringWithFormat:@"%d",avg_velChangeLoad];
    
    riskView.velLoadPerMinLabel.text = [NSString stringWithFormat:@"%d",[velLoadPM intValue]];
    riskView.avgvelLoadPerMinLabel.text = [NSString stringWithFormat:@"%d",avg_velLoadPM];
    
    riskView.totalSprintDistLabel.text = [NSString stringWithFormat:@"%d", [totalSprintDistance intValue]];
    riskView.avgtotalSprintDistLabel.text = [NSString stringWithFormat:@"%d", avg_TotalSprintDist];
    
    
    CGRect sumofDistFrame;
    
    double sumofVolPC = ([SumofVol intValue]/(double)avg_sumofvol);
    
    overallRiskCount = [self setViewChange:riskView.sumofVolView withPercentage:sumofVolPC withCount:overallRiskCount];
    
    if(sumofVolPC < 1)
    {
        sumofDistFrame  = riskView.sumofVolView.frame;
    }
    else
    {
        sumofDistFrame  = riskView.avgSumofVolView.frame;
    }
    
    if(sumofVolPC < 1)
    {
        sumofDistFrame.size.width = sumofDistFrame.size.width * sumofVolPC;
        sumofDistFrame.size.height = sumofDistFrame.size.height;
        [riskView.sumofVolView setFrame:sumofDistFrame];
    }
    else
    {
        sumofDistFrame.size.width = sumofDistFrame.size.width / sumofVolPC;
        sumofDistFrame.size.height = sumofDistFrame.size.height;
        [riskView.avgSumofVolView setFrame:sumofDistFrame];
    }
    
    CGRect acclEventsFrame;
    
    double acclEventsPC = ([AcclEvents intValue]/(double)avg_AcclEvents);
    
    overallRiskCount = [self setViewChange:riskView.accEventsView withPercentage:acclEventsPC withCount:overallRiskCount];
    
    if(acclEventsPC < 1)
    {
        acclEventsFrame = riskView.accEventsView.frame;
    }
    else
    {
        acclEventsFrame  = riskView.avgAccEventsView.frame;
    }
    
    if(acclEventsPC < 1)
    {
        acclEventsFrame.size.width = acclEventsFrame.size.width * acclEventsPC;
        acclEventsFrame.size.height = acclEventsFrame.size.height;
        [riskView.accEventsView setFrame:acclEventsFrame];
    }
    else
    {
        acclEventsFrame.size.width = acclEventsFrame.size.width / acclEventsPC;
        acclEventsFrame.size.height = acclEventsFrame.size.height;
        [riskView.avgAccEventsView setFrame:acclEventsFrame];
    }
    
    CGRect totalDistanceFrame;
    
    double totalDistPC = ([TotalDistance intValue]/(double)avg_TotalDist);
    
    overallRiskCount = [self setViewChange:riskView.totalDistView withPercentage:totalDistPC withCount:overallRiskCount];
    
    if(totalDistPC < 1)
    {
        totalDistanceFrame = riskView.totalDistView.frame;
        totalDistanceFrame.size.width = totalDistanceFrame.size.width * totalDistPC;
        totalDistanceFrame.size.height = totalDistanceFrame.size.height;
        [riskView.totalDistView setFrame:totalDistanceFrame];
    }
    else
    {
        totalDistanceFrame  = riskView.avgTotalDistView.frame;
        totalDistanceFrame.size.width = totalDistanceFrame.size.width / totalDistPC;
        totalDistanceFrame.size.height = totalDistanceFrame.size.height;
        [riskView.avgTotalDistView setFrame:totalDistanceFrame];
    }
    
    
    CGRect forceLoadPMFrame;
    
    double forceLoadPC = ([forceLoadPM intValue]/(double)avg_forceLoadPM);
    
    overallRiskCount = [self setViewChange:riskView.forceLoadView withPercentage:forceLoadPC withCount:overallRiskCount];
    
    if(forceLoadPC < 1)
    {
        forceLoadPMFrame = riskView.forceLoadView.frame;
        forceLoadPMFrame.size.width = forceLoadPMFrame.size.width * forceLoadPC;
        forceLoadPMFrame.size.height = forceLoadPMFrame.size.height;
        [riskView.forceLoadView setFrame:forceLoadPMFrame];
    }
    else
    {
        forceLoadPMFrame = riskView.avgForceLoadView.frame;
        forceLoadPMFrame.size.width = forceLoadPMFrame.size.width / forceLoadPC;
        forceLoadPMFrame.size.height = forceLoadPMFrame.size.height;
        [riskView.avgForceLoadView setFrame:forceLoadPMFrame];
    }
    
    CGRect rateOfExertionFrame;
    
    double rateofExertionPC = ([percievedExertion intValue]/(double)avg_percievedExertion);
    
    overallRiskCount = [self setViewChange:riskView.rateofPercExertionView withPercentage:rateofExertionPC withCount:overallRiskCount];
    
    if(rateofExertionPC < 1)
    {
        rateOfExertionFrame = riskView.rateofPercExertionView.frame;
        rateOfExertionFrame.size.width = rateOfExertionFrame.size.width * rateofExertionPC;
        rateOfExertionFrame.size.height = rateOfExertionFrame.size.height;
        [riskView.rateofPercExertionView setFrame:rateOfExertionFrame];
    }
    else
    {
        rateOfExertionFrame = riskView.avgRateofPercExertionView.frame;
        rateOfExertionFrame.size.width = rateOfExertionFrame.size.width / rateofExertionPC;
        rateOfExertionFrame.size.height = rateOfExertionFrame.size.height;
        [riskView.avgRateofPercExertionView setFrame:rateOfExertionFrame];
    }
    
    CGRect velChangeLoadFrame;
    
    float velLoadPC = ([velChangeLoad floatValue]/(float)avg_velChangeLoad);
    
    overallRiskCount = [self setViewChange:riskView.velchangeLoadView withPercentage:velLoadPC withCount:overallRiskCount];
    
    if(velLoadPC < 1)
    {
        velChangeLoadFrame = riskView.velchangeLoadView.frame;
        velChangeLoadFrame.size.width = velChangeLoadFrame.size.width * velLoadPC;
        velChangeLoadFrame.size.height = velChangeLoadFrame.size.height;
        [riskView.velchangeLoadView setFrame:velChangeLoadFrame];
    }
    else
    {
        velChangeLoadFrame = riskView.avgVelChangeLoadView.frame;
        velChangeLoadFrame.size.width = velChangeLoadFrame.size.width / velLoadPC;
        velChangeLoadFrame.size.height = velChangeLoadFrame.size.height;
        [riskView.avgVelChangeLoadView setFrame:velChangeLoadFrame];
    }
    
    CGRect velLoadPMFrame;
    
    double velLoadPMPC = ([velLoadPM intValue]/(double)avg_velLoadPM);
    
    overallRiskCount = [self setViewChange:riskView.velLoadPerMinView withPercentage:velLoadPMPC withCount:overallRiskCount];
    
    if(velLoadPMPC < 1)
    {
        velLoadPMFrame = riskView.velLoadPerMinView.frame;
        velLoadPMFrame.size.width = velLoadPMFrame.size.width * velLoadPMPC;
        velLoadPMFrame.size.height = velLoadPMFrame.size.height;
        [riskView.velLoadPerMinView setFrame:velLoadPMFrame];
    }
    else
    {
        velLoadPMFrame = riskView.avgLoadPerMinView.frame;
        velLoadPMFrame.size.width = velLoadPMFrame.size.width / velLoadPMPC;
        velLoadPMFrame.size.height = velLoadPMFrame.size.height;
        [riskView.avgLoadPerMinView setFrame:velLoadPMFrame];
    }
    
    CGRect totalSprintDistFrame;
    
    double totalSprintPC = ([totalSprintDistance intValue]/(double)avg_TotalSprintDist);
    
    overallRiskCount = [self setViewChange:riskView.totalSprintDistView withPercentage:totalSprintPC withCount:overallRiskCount];
    
    if(totalSprintPC < 1)
    {
        totalSprintDistFrame = riskView.totalSprintDistView.frame;
        totalSprintDistFrame.size.width = totalSprintDistFrame.size.width * totalSprintPC;
        totalSprintDistFrame.size.height = totalSprintDistFrame.size.height;
        [riskView.totalSprintDistView setFrame:totalSprintDistFrame];
    }
    else
    {
        totalSprintDistFrame = riskView.avgTotalSprintDistanceView.frame;
        totalSprintDistFrame.size.width = totalSprintDistFrame.size.width / totalSprintPC;
        totalSprintDistFrame.size.height = totalSprintDistFrame.size.height;
        [riskView.avgTotalSprintDistanceView setFrame:totalSprintDistFrame];
    }
    
    double overallPC = overallRiskCount/8.0;
    
    [self setViewChange:riskView.overallRiskView withPercentage:[self.player.RiskRating floatValue] withCount:0];
    
    
    [riskView.riskCountView setAttributedText:[utilities getAttributedString:[NSString stringWithFormat:@"%@%@", self.player.RiskRating, @"%"] mainTextFontSize:36 subTextFontSize:20]];
    [riskView.riskRatingChangeLabel setAttributedText:[utilities getAttributedString:[NSString stringWithFormat:@"%@%@", self.player.RiskRatingChange, @"%"] mainTextFontSize:18 subTextFontSize:12]];
    
    [self setIcon:self.riskchangeImage withPercentage:[self.player.RiskRating floatValue] withValue:RISK];
    
    self.wellBeingButton.enabled = YES;
    self.riskButton.enabled = NO;
    self.fitnessButton.enabled = YES;
    
    
    [self.fitnessTabLabel setTextColor:UIColorFromHex(0x001B4A)];
    [self.risTabkLabel setTextColor:[UIColor whiteColor]];
    [self.wellbeingTabLabel setTextColor:UIColorFromHex(0x001B4A)];
    
    [self.riskButton setImage:[UIImage imageNamed:@"tab-selected"] forState:UIControlStateNormal];
    [self.fitnessButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
    [self.wellBeingButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
    
}

-(void) injuryViewTapped:(id)sender {
    
    [self setUpRiskView];
  
}

-(void) wellBeingViewTapped:(id)sender {
    
    [_graphView setHidden:YES];
    
    if (riskView) {
        [riskView removeFromSuperview];
    }
    
    if (wellnessView) {
        [wellnessView removeFromSuperview];
    }
    
    if (fitnessView) {
        [fitnessView removeFromSuperview];
    }
    
    int overallWellnessCount = 0;
    
    [self.wellbeingLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
    [self.fitnessLabel setTextColor:[UIColor colorWithRed:0/255.0 green:27.0/255.0 blue:72.0/255.0 alpha:1]];
    [self.riskLabel setTextColor:[UIColor colorWithRed:0/255.0 green:27.0/255.0 blue:72.0/255.0 alpha:1]];

    
    wellnessView = [[[NSBundle mainBundle] loadNibNamed:@"WellnessView" owner:self options:nil] objectAtIndex:0];
    wellnessView.frame = CGRectMake(30, 100, 811, 315);
    [self.tabScrollView addSubview:wellnessView];
    [self.tabScrollView bringSubviewToFront:wellnessView];
    wellnessView.sleeplessLabel.text = [NSString stringWithFormat:@"%@",sleep_quality];
    wellnessView.avgSleepQualityLabel.text = [NSString stringWithFormat:@"%d",avg_sleep_quality];
    
    [self setSelectedTab:wellnessView];
    
    wellnessView.legHeavinessLabel.text = [NSString stringWithFormat:@"%@",leg_heaviness];
    wellnessView.avglegHeavinessLabel.text = [NSString stringWithFormat:@"%d",avg_leg_heaviness];
    
    wellnessView.backPainLabel.text = [NSString stringWithFormat:@"%@",back_pain];
    wellnessView.avgbackPainLabel.text = [NSString stringWithFormat:@"%d",avg_back_pain];
    
    wellnessView.calvesLabel.text = [NSString stringWithFormat:@"%@",calves];
    wellnessView.avgcalvesLabel.text = [NSString stringWithFormat:@"%d",avg_calves];
    
    wellnessView.recoveryIndexLabel.text = [NSString stringWithFormat:@"%@",recovery_index];
    wellnessView.avgrecoveryIndexLabel.text = [NSString stringWithFormat:@"%d",avg_recovery_index];
    
    wellnessView.muscleSorenessLabel.text = [NSString stringWithFormat:@"%@",muscle_soreness];
    wellnessView.avgmuscleSorenessLabel.text = [NSString stringWithFormat:@"%d",avg_muscle_soreness];
    
    wellnessView.trainingStateLabel.text = [NSString stringWithFormat:@"%@",training_state];
    wellnessView.avgtrainingStateLabel.text = [NSString stringWithFormat:@"%d",avg_training_state];
    
    wellnessView.romTightnessLabel.text = [NSString stringWithFormat:@"%@",rom_tightness];
    wellnessView.avgromTightnessLabel.text = [NSString stringWithFormat:@"%d",avg_rom_tightness];
    
    wellnessView.hipflexorQuadLabel.text = [NSString stringWithFormat:@"%@",hipflexor_quads];
    wellnessView.avghipflexorQuadLabel.text = [NSString stringWithFormat:@"%d",avg_hipflexor_quads];
    
    wellnessView.groinLabel.text = [NSString stringWithFormat:@"%@",groins];
    wellnessView.avgGroinLabel.text = [NSString stringWithFormat:@"%d",avg_groins];
    
    wellnessView.hamstringLabel.text = [NSString stringWithFormat:@"%@",hamstrings];
    wellnessView.avghamstringLabel.text = [NSString stringWithFormat:@"%d",avg_hamstring];
    
    CGRect sleepQualFrame;
    
    double  sleepPC = ([sleep_quality intValue]/(double)avg_sleep_quality);
    
    overallWellnessCount = [self setViewChange:wellnessView.sleeplessnessView withPercentage:sleepPC withCount:overallWellnessCount];
    
    if(sleepPC < 1)
    {
        sleepQualFrame = wellnessView.sleeplessnessView.frame;
        sleepQualFrame.size.width = sleepQualFrame.size.width * sleepPC;
        sleepQualFrame.size.height = sleepQualFrame.size.height;
        [wellnessView.sleeplessnessView setFrame:sleepQualFrame];
    }
    else
    {
        sleepQualFrame = wellnessView.avgSleeplessnessView.frame;
        sleepQualFrame.size.width = sleepQualFrame.size.width / sleepPC;
        sleepQualFrame.size.height = sleepQualFrame.size.height;
        [wellnessView.avgSleeplessnessView setFrame:sleepQualFrame];
    }
    
    CGRect legHeavinessFrame;
    
    double  legHeavinessPC = ([leg_heaviness intValue]/(double)avg_leg_heaviness);
    
    overallWellnessCount = [self setViewChange:wellnessView.legHeavinessView withPercentage:legHeavinessPC withCount:overallWellnessCount];
    
    if(legHeavinessPC < 1)
    {
        legHeavinessFrame = wellnessView.legHeavinessView.frame;
        legHeavinessFrame.size.width = legHeavinessFrame.size.width * legHeavinessPC;
        legHeavinessFrame.size.height = legHeavinessFrame.size.height;
        [wellnessView.legHeavinessView setFrame:legHeavinessFrame];
    }
    else
    {
        legHeavinessFrame = wellnessView.avglegHeavinessView.frame;
        legHeavinessFrame.size.width = legHeavinessFrame.size.width / legHeavinessPC;
        legHeavinessFrame.size.height = legHeavinessFrame.size.height;
        [wellnessView.avglegHeavinessView setFrame:legHeavinessFrame];
    }
    
    CGRect backPainView;
    
    double  backPainPC = ([back_pain intValue]/(double)avg_back_pain);
    
    overallWellnessCount = [self setViewChange:wellnessView.backPainView withPercentage:backPainPC withCount:overallWellnessCount];
    
    if(backPainPC < 1)
    {
        backPainView = wellnessView.backPainView.frame;
        backPainView.size.width = backPainView.size.width * backPainPC;
        backPainView.size.height = backPainView.size.height;
        [wellnessView.backPainView setFrame:backPainView];
    }
    else
    {
        backPainView = wellnessView.avgBackPainView.frame;
        backPainView.size.width = backPainView.size.width / backPainPC;
        backPainView.size.height = backPainView.size.height;
        [wellnessView.avgBackPainView setFrame:backPainView];
    }
    
    CGRect calvesView;
    
    double calvesPC = ([calves intValue]/(double)avg_calves);
    
    overallWellnessCount = [self setViewChange:wellnessView.calvesView withPercentage:calvesPC withCount:overallWellnessCount];
    
    if(calvesPC < 1)
    {
        calvesView = wellnessView.calvesView.frame;
        calvesView.size.width = calvesView.size.width * calvesPC;
        calvesView.size.height = calvesView.size.height;
        [wellnessView.calvesView setFrame:calvesView];
    }
    else
    {
        calvesView = wellnessView.avgCalvesView.frame;
        calvesView.size.width = calvesView.size.width / calvesPC;
        calvesView.size.height = calvesView.size.height;
        [wellnessView.avgCalvesView setFrame:calvesView];
    }
    
    CGRect recoveryIndexView;
    
    double recoveryIndexPC = ([recovery_index intValue]/(double)avg_recovery_index);
    
    overallWellnessCount = [self setViewChange:wellnessView.recoveryIndexView withPercentage:recoveryIndexPC withCount:overallWellnessCount];
    
    if(recoveryIndexPC < 1)
    {
        recoveryIndexView = wellnessView.recoveryIndexView.frame;
        recoveryIndexView.size.width = recoveryIndexView.size.width * recoveryIndexPC;
        recoveryIndexView.size.height = recoveryIndexView.size.height;
        [wellnessView.recoveryIndexView setFrame:recoveryIndexView];
    }
    else
    {
        recoveryIndexView = wellnessView.avgRecoveryIndexView.frame;
        recoveryIndexView.size.width = recoveryIndexView.size.width / recoveryIndexPC;
        recoveryIndexView.size.height = recoveryIndexView.size.height;
        [wellnessView.avgRecoveryIndexView setFrame:recoveryIndexView];
    }
    
    CGRect muscleSorenessFrame;
    
    double muscleSorenessPC = ([muscle_soreness intValue]/(double)avg_muscle_soreness);
    
    overallWellnessCount = [self setViewChange:wellnessView.muscleSorenessView withPercentage:muscleSorenessPC withCount:overallWellnessCount];
    
    if(muscleSorenessPC < 1)
    {
        muscleSorenessFrame = wellnessView.muscleSorenessView.frame;
        muscleSorenessFrame.size.width = muscleSorenessFrame.size.width * muscleSorenessPC;
        muscleSorenessFrame.size.height = muscleSorenessFrame.size.height;
        [wellnessView.muscleSorenessView setFrame:muscleSorenessFrame];
    }
    else
    {
        muscleSorenessFrame = wellnessView.avgMuscleSorenessView.frame;
        muscleSorenessFrame.size.width = muscleSorenessFrame.size.width / muscleSorenessPC;
        muscleSorenessFrame.size.height = muscleSorenessFrame.size.height;
        [wellnessView.avgMuscleSorenessView setFrame:muscleSorenessFrame];
    }
    
    CGRect trainingStateFrame;
    
    double trainingStatePC = ([training_state intValue]/(double)avg_training_state);
    
    overallWellnessCount = [self setViewChange:wellnessView.trainingStateView withPercentage:trainingStatePC withCount:overallWellnessCount];
    
    if(trainingStatePC < 1)
    {
        trainingStateFrame = wellnessView.trainingStateView.frame;
        trainingStateFrame.size.width = trainingStateFrame.size.width * trainingStatePC;
        trainingStateFrame.size.height = trainingStateFrame.size.height;
        [wellnessView.trainingStateView setFrame:trainingStateFrame];
    }
    else
    {
        trainingStateFrame = wellnessView.avgTrainingStateView.frame;
        trainingStateFrame.size.width = trainingStateFrame.size.width / trainingStatePC;
        trainingStateFrame.size.height = trainingStateFrame.size.height;
        [wellnessView.avgTrainingStateView setFrame:trainingStateFrame];
    }
    
    CGRect romTightnessFrame;
    
    double romTighnessPC = ([rom_tightness intValue]/(double)avg_rom_tightness);
    
    overallWellnessCount = [self setViewChange:wellnessView.romTightnessView withPercentage:romTighnessPC withCount:overallWellnessCount];
    
    if(romTighnessPC < 1)
    {
        romTightnessFrame = wellnessView.romTightnessView.frame;
        romTightnessFrame.size.width = romTightnessFrame.size.width * romTighnessPC;
        romTightnessFrame.size.height = romTightnessFrame.size.height;
        [wellnessView.romTightnessView setFrame:romTightnessFrame];
    }
    else
    {
        romTightnessFrame = wellnessView.avgROMTightnessView.frame;
        romTightnessFrame.size.width = romTightnessFrame.size.width / romTighnessPC;
        romTightnessFrame.size.height = romTightnessFrame.size.height;
        [wellnessView.avgROMTightnessView setFrame:romTightnessFrame];
    }
    
    CGRect hipFlexorQuadFrame = wellnessView.hipflexorQuadView.frame;
    
    double hipflexorPC = ([hipflexor_quads intValue]/(double)avg_hipflexor_quads);
    
    overallWellnessCount = [self setViewChange:wellnessView.hipflexorQuadView withPercentage:hipflexorPC withCount:overallWellnessCount];
    
    if(hipflexorPC < 1)
    {
        hipFlexorQuadFrame = wellnessView.hipflexorQuadView.frame;
        hipFlexorQuadFrame.size.width = hipFlexorQuadFrame.size.width * hipflexorPC;
        hipFlexorQuadFrame.size.height = hipFlexorQuadFrame.size.height;
        [wellnessView.hipflexorQuadView setFrame:hipFlexorQuadFrame];
    }
    else
    {
        hipFlexorQuadFrame = wellnessView.avgHipFlexorQuadView.frame;
        hipFlexorQuadFrame.size.width = hipFlexorQuadFrame.size.width / hipflexorPC;
        hipFlexorQuadFrame.size.height = hipFlexorQuadFrame.size.height;
        [wellnessView.avgHipFlexorQuadView setFrame:hipFlexorQuadFrame];
    }
    
    CGRect groinFrame;
    
    double groinPC = ([groins intValue]/(double)avg_groins);
    
    overallWellnessCount = [self setViewChange:wellnessView.groinView withPercentage:groinPC withCount:overallWellnessCount];
    
    if(groinPC < 1)
    {
        groinFrame = wellnessView.groinView.frame;
        groinFrame.size.width = groinFrame.size.width * groinPC;
        groinFrame.size.height = groinFrame.size.height;
        [wellnessView.groinView setFrame:groinFrame];
    }
    else
    {
        groinFrame = wellnessView.avgGroinView.frame;
        groinFrame.size.width = groinFrame.size.width / groinPC;
        groinFrame.size.height = groinFrame.size.height;
        [wellnessView.avgGroinView setFrame:groinFrame];
    }
    
    CGRect hamstringFrame;
    
    double hamStringPC = ([hamstrings intValue]/(double)avg_hamstring);
    
    overallWellnessCount = [self setViewChange:wellnessView.hamstringView withPercentage:hamStringPC withCount:overallWellnessCount];
    
    if(hamStringPC < 1)
    {
        hamstringFrame = wellnessView.hamstringView.frame;
        hamstringFrame.size.width = hamstringFrame.size.width * hamStringPC;
        hamstringFrame.size.height = hamstringFrame.size.height;
        [wellnessView.hamstringView setFrame:hamstringFrame];
    }
    else
    {
        hamstringFrame = wellnessView.avgHamstringView.frame;
        hamstringFrame.size.width = hamstringFrame.size.width / hamStringPC;
        hamstringFrame.size.height = hamstringFrame.size.height;
        [wellnessView.avgHamstringView setFrame:hamstringFrame];
    }
    
    CGRect overallwellnessView = wellnessView.overallWelnessView.frame;
    
    double overallPC = overallWellnessCount/11.0;
    
    [self setViewChange:wellnessView.overallWelnessView withPercentage:overallPC withCount:0];
    
    [self setIcon:self.wellBeingIndicatorImage withPercentage:[self.player.Wellbeing floatValue] withValue:WELLBEING];
    
    overallwellnessView.size.width = overallwellnessView.size.width * overallPC;
    overallwellnessView.size.height = overallwellnessView.size.height;
    [wellnessView.overallWelnessView setFrame:overallwellnessView];
    
    [wellnessView.wellnessCountView setText:[NSString stringWithFormat:@"%d/11",overallWellnessCount]];
    
    [self.wellBeingButton setImage:[UIImage imageNamed:@"tab-selected"] forState:UIControlStateNormal];
    [self.riskButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
    [self.fitnessButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
    
    [self.fitnessTabLabel setTextColor:UIColorFromHex(0x001B4A)];
    [self.risTabkLabel setTextColor:UIColorFromHex(0x001B4A)];
    [self.wellbeingTabLabel setTextColor:[UIColor whiteColor]];
    
    self.wellBeingButton.enabled = NO;
    self.riskButton.enabled = YES;
    self.fitnessButton.enabled = YES;
 
}

-(void)changeRiskButtonClicked:(id)sender
{
    RiskEditViewController * riskEditViewController = [[RiskEditViewController alloc] initWithNibName:@"RiskEditViewController" bundle:nil];
    riskEditViewController.transitioningDelegate = self;
    riskEditViewController.modalPresentationStyle = UIModalPresentationCustom;
    riskEditViewController.player = self.player;
    riskEditViewController.modelItems = modelItems;
    riskEditViewController.model = model;
    [self presentViewController:riskEditViewController animated:YES completion:nil];
}

-(NSInteger) setViewChange:(UIView*)view withPercentage:(CGFloat)percentageValue withCount:(NSInteger)count
{
//    if(percentageValue < 0.8 && percentageValue >= 0.6)
//    {
//        [view setBackgroundColor:UIColorFromHex(0xF6691B)];
//        
//    }
//    else if (percentageValue < 0.6)
//    {
//        [view setBackgroundColor:[UIColor redColor]];
//    }
//    else if (percentageValue > 1.2 && percentageValue <= 1.6)
//    {
//        [view setBackgroundColor:UIColorFromHex(0xF6691B)];
//    }
//    else if (percentageValue > 1.6)
//    {
//        [view setBackgroundColor:[UIColor redColor]];
//    }
//    else if(percentageValue >= 0.8 && percentageValue <= 1.2)
//    {
//        [view setBackgroundColor:UIColorFromHex(0x53B61D)];
//        count++;
//    }
    
    if (percentageValue <= 30) {
        
        [view setBackgroundColor:UIColorFromHex(0x1e8034)];
    } else if (percentageValue > 30 && percentageValue <= 70) {
        
        [view setBackgroundColor:UIColorFromHex(0xf86600)];
    } else {
        
        [view setBackgroundColor:UIColorFromHex(0xdc001a)];
    }
    
    return count;
}


-(void) setIcon:(UIImageView*)view withPercentage:(CGFloat)percentageValue withValue:(NSInteger)value
{
    NSString * orangeIcon;
    NSString * redIcon;
    NSString * greenIcon;
    
    switch (value) {
        case FITNESS:
        {
            orangeIcon = @"Medium_Fit_Sml";
            greenIcon = @"Bad_Fit_Sml";
            redIcon = @"Good_Fit_Sml";
            break;
        }
        case RISK:
        {
            orangeIcon = @"Medium_Risk_Sml";
            redIcon = @"High_Risk_Sml";
            greenIcon = @"Low_Risk_Sml";
            break;
        }
        case WELLBEING:
        {
            orangeIcon = @"Meh_Sml";
            greenIcon = @"Sad_Sml";
            redIcon = @"Happy_Sml";
            break;
        }
        default:
            break;
    }
    
    
    if(percentageValue > 30 && percentageValue <= 70)
    {
        [view setImage:[UIImage imageNamed:orangeIcon]];
        
    }
    else if (percentageValue > 70)
    {
        [view setImage:[UIImage imageNamed:redIcon]];
    }
    else
    {
        [view setImage:[UIImage imageNamed:greenIcon]];
    }

}


#pragma mark - Set selected/unselected tabs

- (void) setSelectedTab:(UIView*) selectedTab {
  
    if ([selectedTab isKindOfClass:[RiskView class]]) {
        [_injuryView setAlpha:1.0];
        [_fitnessView setAlpha:UNSELECTED_ALPHA];
        [_wellBeingView setAlpha:UNSELECTED_ALPHA];
        
    } else if ([selectedTab isKindOfClass:[FitnessView class]]) {
        
        [_fitnessView setAlpha:1.0];
        [_injuryView setAlpha:UNSELECTED_ALPHA];
        [_wellBeingView setAlpha:UNSELECTED_ALPHA];
    } else {
        
        [_wellBeingView setAlpha:1.0];
        [_fitnessView setAlpha:UNSELECTED_ALPHA];
        [_injuryView setAlpha:UNSELECTED_ALPHA];
    }
  
}

#pragma mark - UIViewControllerTransitioning Delegate Methods


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    CustomPresentationController * customController = [CustomPresentationController new];
    return customController;
    
}
/*
- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController:(UIViewController *)dismissed {
    CustomDismissController * dismissController = [CustomDismissController new];
    return dismissController;
}*/

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[DimmingPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}




@end
