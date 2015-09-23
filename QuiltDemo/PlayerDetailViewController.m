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
#import "Constants.h"

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
    
    NSInteger selectedView;
    
    NSString * playerStatus;
    NSString * playerInjuryArea;
    NSString * playerInjuryDurationWeeks;
    NSString * playerInjuryDurarionGames;
    NSString * travelDuration;
    NSString * travelWeeks;
}
@property (weak, nonatomic) IBOutlet UILabel *firstMonth;
@property (weak, nonatomic) IBOutlet UILabel *secondMonth;
@property (weak, nonatomic) IBOutlet UILabel *thirdMonth;
@property (weak, nonatomic) IBOutlet UILabel *fourthMonth;
@property (weak, nonatomic) IBOutlet UILabel *fifthMonth;
@property (weak, nonatomic) IBOutlet UILabel *lastMonth;


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
    
    [self.navigationController.navigationBar.topItem setTitle:[self.player.Name uppercaseString]];
    
    [self.tabScrollView setContentSize:CGSizeMake(320.0f, 650.0f)];

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
    
    [self setUpRiskView];
}

-(void) initiateViewSetUp
{
    isInjured = FALSE;
    
    [self setupView];
    
    [self setUpTapGestures];
    
    [self graphItemSetupWithPoint:self.player.RiskRating];
    
    [self updateSelectedView];
}

- (void) graphItemSetupWithPoint: (NSInteger) point {
    
    [self initializeDataWithPoint:point];
    
    [self setupGraph];
    
    [self setupAxes];
    
    [self setupScatterPlots];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateSelectedView {
    
    switch (selectedView) {
        case RISK:
            [self setUpRiskView];
            break;
        case FITNESS:
            [self setupFitnessView];
            break;
        case WELLBEING:
            [self setUpWellBeingView];
            break;
            
        default:
            break;
    }
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
    
    avg_LoadedMarch = (NSInteger)floor([utilities getAverageLoadedMarch:modelItems]);
    
    loadedMarch = model.Loaded_March;
    
    avg_FireAndMove = (NSInteger)floor([utilities getAverageFireAndMove:modelItems]);
    
    fireAndMove = model.Fire_And_Move;
    
    avg_JerryCanWalk = (NSInteger)floor([utilities getAverageJerryCanWalk:modelItems]);
    
    jerryCanWalk = model.Jerry_Can_Walk;
    
    avg_BoxLift = (NSInteger)floor([utilities getAverageBoxLift:modelItems]);
    
    box_Lift = model.Box_Lift;
    
    avg_PushUps = (NSInteger)floor([utilities getAveragePushUps:modelItems]);
    
    pushUps = model.Push_Ups;
    
    avg_sitUps = (NSInteger)floor([utilities getAverageSitUps:modelItems]);
    
    sitUps = model.Sit_Ups;
    
    avg_Run = (NSInteger)floor([utilities getAverageRunFiveKM:modelItems]);
    
    run = model.Run;
    
    avg_Walk = (NSInteger)floor([utilities getAverageWalk:modelItems]);
    
    walk = model.Walk;
    
    avg_runDodgeJump = (NSInteger)floor([utilities getAverageRunDodgeJump:modelItems]);
    
    runDodgeJump = model.Run_Dodge_Jump;
    
    avg_EnduranceJump = (NSInteger)floor([utilities getAverageEnduranceMarch:modelItems]);
    
    enduranceJump = model.Endurance_March;
    
    avg_SwimTest = (NSInteger)floor([utilities getAverageSwimTest:modelItems]);
    
    swimTest = model.Swim_Test;
    
    avg_TreadWater = (NSInteger)floor([utilities getAverageTreadWater:modelItems]);
    
    treadWater = model.Tread_Water;
    
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
    
    self.enlistedLabel.text = self.player.Enlisted;
    
    [self.heightLabel setText:[NSString stringWithFormat:@"%@",self.player.Height]];
    
    [self.weightLabel setText:[NSString stringWithFormat:@"%@",self.player.Weight]];
    
    self.positionLabel.text = self.player.Position;
    
    [self.PMKeySLabel setText:[NSString stringWithFormat:@"%@",self.player.PMKeyS]];
    
    self.HomeUnitLabel.text = self.player.HomeUnit;
    
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
    
    [utilities setIcon:self.fitnessIndicatorImage withPercentage:[self.player.FitnessRating doubleValue] withValue:FITNESS];
    [utilities setIcon:self.injuryRiskImage withPercentage:[self.player.RiskRatingValue doubleValue] withValue:RISK];
    [utilities setIcon:self.wellBeingIndicatorImage withPercentage:[self.player.Wellbeing doubleValue] withValue:WELLBEING];
    
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
    
    NSMutableArray * array = [utilities getMonthsForGraphCoordinates];
    NSArray *graphArray = [[array reverseObjectEnumerator] allObjects];
    
    [_firstMonth setText:[graphArray objectAtIndex:0]];
    [_secondMonth setText:[graphArray objectAtIndex:1]];
    [_thirdMonth setText:[graphArray objectAtIndex:2]];
    [_fourthMonth setText:[graphArray objectAtIndex:3]];
    [_fifthMonth setText:[graphArray objectAtIndex:4]];
    [_lastMonth setText:[graphArray objectAtIndex:5]];
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

-(void)initializeDataWithPoint: (NSInteger) point
{
    
    self.players = [@[] mutableCopy];
    PlayerItems * playerItems = [dataModel getSoldierItems:nil forMainPosition:nil];
    self.players = playerItems.players;
    
    [self.navigationController.navigationBar.topItem setTitle:[self.player.Name uppercaseString]];

    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:6];
    
    for ( NSUInteger i = 0; i < 6; i++ ) {
        
        id x = [NSNumber numberWithDouble:i * 0.5];
        id y;
        if(i <5) {
            
            float low_bound = point  - 20;
            low_bound = low_bound > 0 ? low_bound : 0;
            float high_bound = point + 20 ;
            high_bound = high_bound > 100 ? 90 : high_bound;
            float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
            y = [NSNumber numberWithFloat:rndValue];
        } else {
            y = [NSNumber numberWithDouble:point];
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
    return 6;
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
    
    [utilities setIcon:cell.playerRiskIcon withPercentage:[player.RiskRating floatValue] withValue:RISK];
    [utilities setIcon:cell.playerWellBeingIcon withPercentage:[player.Wellbeing floatValue] withValue:WELLBEING];
    [utilities setIcon:cell.playerFitnessIcon withPercentage:[player.FitnessRating floatValue] withValue:FITNESS];
    
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

-(void) fitnessViewTapped:(id)sender {
    
    [self.tabScrollView setContentSize:CGSizeMake(320.0f, 1100.0f)];
    [self.tabScrollView setNeedsDisplay];
    [self setupFitnessView];
    
}

-(void) setupFitnessView {
    
    
    
    selectedView = FITNESS;
    
    [self graphItemSetupWithPoint:[self.player.FitnessRating integerValue]];
    
    if (riskView) {
        [riskView removeFromSuperview];
    }
    
    if (wellnessView) {
        [wellnessView removeFromSuperview];
    }
    
    if (fitnessView) {
        [fitnessView removeFromSuperview];
    }
    
    NSInteger overallFitnessCount = 0;
    
    [self.fitnessButton setImage:[UIImage imageNamed:@"tab-selected"] forState:UIControlStateNormal];
    [self.riskButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
    [self.wellBeingButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
    
    [self.fitnessLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
    [self.riskLabel setTextColor:[UIColor colorWithRed:0/255.0 green:27.0/255.0 blue:72.0/255.0 alpha:1]];
    [self.wellbeingLabel setTextColor:[UIColor colorWithRed:0/255.0 green:27.0/255.0 blue:72.0/255.0 alpha:1]];

    
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
    
    [fitnessView.fiveKmReqlabel setText:[NSString stringWithFormat:@"%ld", avg_LoadedMarch]];
    [fitnessView.fiveKmCurrentMarchLabel setText:[NSString stringWithFormat:@"%@", loadedMarch]];
    
    [fitnessView.fireAndMoveReqLabel setText:[NSString stringWithFormat:@"%ld", avg_FireAndMove]];
    [fitnessView.fireAndMoveCurrentLabel setText:[NSString stringWithFormat:@"%@", fireAndMove]];
    
    [fitnessView.jerryCanWalkReqLabel setText:[NSString stringWithFormat:@"%ld", avg_JerryCanWalk]];
    [fitnessView.jerryCanWalkCurrentLabel setText:[NSString stringWithFormat:@"%@", jerryCanWalk]];
    
    [fitnessView.boxLiftReqLabel setText:[NSString stringWithFormat:@"%ld", avg_BoxLift]];
    [fitnessView.boxLiftCurrentLabel setText:[NSString stringWithFormat:@"%@", box_Lift]];
    
    [fitnessView.pushUpReqLabel setText:[NSString stringWithFormat:@"%ld", avg_PushUps]];
    [fitnessView.pushUpCurrentLabel setText:[NSString stringWithFormat:@"%@", pushUps]];
    
    [fitnessView.sitUpReqLabel setText:[NSString stringWithFormat:@"%ld", avg_sitUps]];
    [fitnessView.sitUpCurrentLabel setText:[NSString stringWithFormat:@"%@", sitUps]];
    
    [fitnessView.twoAndHalfKMReqLabel setText:RUN_REQ];
    [fitnessView.twoAndHalfKMCurrentLabel setText:[NSString stringWithFormat:@"%@", run]];
    
    [fitnessView.fiveKMWalkReqLabel setText:WALK_REQ];
    [fitnessView.fiveKMWalkCurrentLabel setText:[NSString stringWithFormat:@"%@", walk]];
    
    [fitnessView.runDodgeAndJumReqlabel setText:RUN_DODGE_JUMP_REQ];
    [fitnessView.runDodgeAndJumCurrentLabel setText:[NSString stringWithFormat:@"%@", runDodgeJump]];
    
    [fitnessView.enduranceMarchReqLabel setText:ENDURANCE_MARCH_REQ];
    [fitnessView.enduranceMarchCurrentLabel setText:[NSString stringWithFormat:@"%@", enduranceJump]];
    
    [fitnessView.swimCamoflageReqLabel setText:[NSString stringWithFormat:@"%ld", avg_SwimTest]];
    [fitnessView.swimCamoflageCurrentLabel setText:[NSString stringWithFormat:@"%@", swimTest]];
    
    [fitnessView.treadWaterReqLabel setText:TREAD_WATER_REQ];
    [fitnessView.treadWaterCurrentLabel setText:[NSString stringWithFormat:@"%@", treadWater]];
    
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
    
    
    overallFitnessCount =[self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.sitReachView, fitnessView.avgSitReachView, nil] withCurrentValue:sitReach withAverageValue:avg_sitreach withFitnessCount:overallFitnessCount];
    
    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.groinSquuze0View, fitnessView.avggroinSquuze0View, nil] withCurrentValue:groinSqueeze0 withAverageValue:avg_groinSqueeze0 withFitnessCount:overallFitnessCount];

    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.groinSquuze60View, fitnessView.avgGroinSquuze60View, nil] withCurrentValue:groinSqueeze60 withAverageValue:avg_groinSqueeze60 withFitnessCount:overallFitnessCount];

    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.hipRotationL, fitnessView.avgHipRotationLView, nil] withCurrentValue:hipRotationL withAverageValue:avg_hiprotationl withFitnessCount:overallFitnessCount];
    
    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.hipRotationR, fitnessView.avgHipRotationRView, nil] withCurrentValue:hipRotationR withAverageValue:avg_hiprotationr withFitnessCount:overallFitnessCount];
    
    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.fiveKMLoadedMarchCurrent, fitnessView.fiveKMLoadedMarchReq, nil] withCurrentValue:loadedMarch withAverageValue:avg_LoadedMarch withFitnessCount:overallFitnessCount];
    
    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.fireandMoveCurrent, fitnessView.fireAndMoveRequirement, nil] withCurrentValue:fireAndMove withAverageValue:avg_FireAndMove withFitnessCount:overallFitnessCount];
    
    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.jerryCanWalkCurrent, fitnessView.jerryCanWalkReq, nil] withCurrentValue:jerryCanWalk withAverageValue:avg_JerryCanWalk withFitnessCount:overallFitnessCount];
    
    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.boxLiftCurrent, fitnessView.boxLiftReq, nil] withCurrentValue:box_Lift withAverageValue:avg_BoxLift withFitnessCount:overallFitnessCount];
    
    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.pushupCurrentView, fitnessView.pushUpReqView, nil] withCurrentValue:pushUps withAverageValue:avg_PushUps withFitnessCount:overallFitnessCount];
    
    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.sitUpCurrentView, fitnessView.sitUpReqView, nil] withCurrentValue:sitUps withAverageValue:avg_sitUps withFitnessCount:overallFitnessCount];
    
    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.twoAndHalfKMCurrentRun, fitnessView.twoAndHalfKMRunReq, nil] withCurrentValue:[NSString stringWithFormat:@"%ld",[utilities getSecondsFromTimeFormat:run]] withAverageValue:[utilities getSecondsFromTimeFormat:RUN_REQ] withFitnessCount:overallFitnessCount];
    
    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.fiveKMWalkCurrentView, fitnessView.fiveKMWalkReqView, nil] withCurrentValue:[NSString stringWithFormat:@"%ld",[utilities getSecondsFromTimeFormat:walk]] withAverageValue:[utilities getSecondsFromTimeFormat:WALK_REQ] withFitnessCount:overallFitnessCount];
    
    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.runDodgeAndJumpCurrentView, fitnessView.runDodgeAndJumReqView, nil] withCurrentValue:[NSString stringWithFormat:@"%ld",[utilities getSecondsFromTimeFormat:runDodgeJump]] withAverageValue:[utilities getSecondsFromTimeFormat:RUN_DODGE_JUMP_REQ] withFitnessCount:overallFitnessCount];
    
    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.enduranceMarchCurrentView, fitnessView.enduranceMarchReqView, nil] withCurrentValue:[NSString stringWithFormat:@"%ld",[utilities getSecondsFromTimeFormat:enduranceJump]] withAverageValue:[utilities getSecondsFromTimeFormat:ENDURANCE_MARCH_REQ] withFitnessCount:overallFitnessCount];
    
    overallFitnessCount = [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.swimCamoflageCurrentView, fitnessView.swimCamoflageReqView, nil] withCurrentValue:swimTest withAverageValue:avg_SwimTest withFitnessCount:overallFitnessCount];
    
   overallFitnessCount =  [self changeFrameForIndicatorView:[NSArray arrayWithObjects:fitnessView.treadWaterCurrentView, fitnessView.treadWaterReqView, nil] withCurrentValue:[NSString stringWithFormat:@"%ld",[utilities getSecondsFromTimeFormat:treadWater]] withAverageValue:[utilities getSecondsFromTimeFormat:TREAD_WATER_REQ] withFitnessCount:overallFitnessCount];
    
    CGRect overallFitnessView = fitnessView.progressView.frame;
    
    CGFloat overallPC = overallFitnessCount/17.0;

    
    [utilities setFitnessViewChange:fitnessView.overallFitnessView withPercentage:overallPC withCount:0];
    
    overallPC = overallPC * 100;
    
    NSInteger fitnessPC = (int)overallPC;
    
     NSMutableAttributedString * fitnessText = [utilities getAttributedString:[NSString stringWithFormat:@"%ld%@", fitnessPC, @"%"] mainTextFontSize:36 subTextFontSize:20];
    
    [fitnessView.overallFitnessPCLabel setAttributedText:fitnessText];
    
    overallFitnessView.size.width = overallFitnessView.size.width * overallPC;
    overallFitnessView.size.height = overallFitnessView.size.height;
    [fitnessView.progressView setFrame:overallFitnessView];
    
    [utilities setIcon:self.fitnessIndicatorImage withPercentage:[self.player.FitnessRating floatValue] withValue:FITNESS];
    
    [self.fitnessTabLabel setTextColor:[UIColor whiteColor]];
    [self.risTabkLabel setTextColor:UIColorFromHex(0x001B4A)];
    [self.wellbeingTabLabel setTextColor:UIColorFromHex(0x001B4A)];
    
    self.wellBeingButton.enabled = YES;
    self.riskButton.enabled = YES;
    self.fitnessButton.enabled = NO;
    
    self.riskButton.backgroundColor = [UIColor blackColor];
}

- (void) setUpRiskView {
    
    self.tabScrollView.contentSize =CGSizeMake(320.0f, 650.0f);
    
    selectedView = RISK;
    
    [self graphItemSetupWithPoint:[self.player.RiskRating integerValue]];
    
    NSInteger overallRiskCount = 0;
    
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
    
    overallRiskCount = [utilities setFitnessViewChange:riskView.sumofVolView withPercentage:sumofVolPC withCount:overallRiskCount];
    
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
    
    overallRiskCount = [utilities setFitnessViewChange:riskView.accEventsView withPercentage:acclEventsPC withCount:overallRiskCount];
    
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
    
    overallRiskCount = [utilities setFitnessViewChange:riskView.totalDistView withPercentage:totalDistPC withCount:overallRiskCount];
    
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
    
    overallRiskCount = [utilities setFitnessViewChange:riskView.forceLoadView withPercentage:forceLoadPC withCount:overallRiskCount];
    
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
    
    overallRiskCount = [utilities setViewChange:riskView.rateofPercExertionView withPercentage:rateofExertionPC withCount:overallRiskCount];
    
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
    
    overallRiskCount = [utilities setFitnessViewChange:riskView.velchangeLoadView withPercentage:velLoadPC withCount:overallRiskCount];
    
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
    
    overallRiskCount = [utilities setFitnessViewChange:riskView.velLoadPerMinView withPercentage:velLoadPMPC withCount:overallRiskCount];
    
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
    
    overallRiskCount = [utilities setFitnessViewChange:riskView.totalSprintDistView withPercentage:totalSprintPC withCount:overallRiskCount];
    
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
    
    [utilities setMainViewChange:riskView.overallRiskView withPercentage:[self.player.RiskRating floatValue] withCount:0];
    
    [riskView.riskCountView setAttributedText:[utilities getAttributedString:[NSString stringWithFormat:@"%@%@", self.player.RiskRating, @"%"] mainTextFontSize:36 subTextFontSize:20]];
    [riskView.riskRatingChangeLabel setAttributedText:[utilities getAttributedString:[NSString stringWithFormat:@"%@%@", self.player.RiskRatingChange, @"%"] mainTextFontSize:18 subTextFontSize:12]];
    
    [utilities setIcon:self.riskchangeImage withPercentage:[self.player.RiskRating floatValue] withValue:RISK];
    
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

- (void) setUpWellBeingView {
    
    selectedView = WELLBEING;
    
    [self graphItemSetupWithPoint:[self.player.Wellbeing integerValue]];
    
    if (riskView) {
        [riskView removeFromSuperview];
    }
    
    if (wellnessView) {
        [wellnessView removeFromSuperview];
    }
    
    if (fitnessView) {
        [fitnessView removeFromSuperview];
    }
    
    NSInteger overallWellnessCount = 0;
    
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
    
    
    overallWellnessCount =[self changeFrameForIndicatorView:[NSArray arrayWithObjects:wellnessView.sleeplessnessView, wellnessView.avgSleeplessnessView, nil] withCurrentValue:sleep_quality withAverageValue:avg_sleep_quality withFitnessCount:overallWellnessCount];
    
    overallWellnessCount =[self changeFrameForIndicatorView:[NSArray arrayWithObjects:wellnessView.legHeavinessView, wellnessView.avglegHeavinessView, nil] withCurrentValue:leg_heaviness withAverageValue:avg_leg_heaviness withFitnessCount:overallWellnessCount];
    
    overallWellnessCount =[self changeFrameForIndicatorView:[NSArray arrayWithObjects:wellnessView.backPainView, wellnessView.avgBackPainView, nil] withCurrentValue:back_pain withAverageValue:avg_back_pain withFitnessCount:overallWellnessCount];
    
   overallWellnessCount =[self changeFrameForIndicatorView:[NSArray arrayWithObjects:wellnessView.calvesView, wellnessView.avgCalvesView, nil] withCurrentValue:calves withAverageValue:avg_calves withFitnessCount:overallWellnessCount];
    
    overallWellnessCount =[self changeFrameForIndicatorView:[NSArray arrayWithObjects:wellnessView.recoveryIndexView, wellnessView.avgRecoveryIndexView, nil] withCurrentValue:recovery_index withAverageValue:avg_recovery_index withFitnessCount:overallWellnessCount];
    
    overallWellnessCount =[self changeFrameForIndicatorView:[NSArray arrayWithObjects:wellnessView.muscleSorenessView, wellnessView.avgMuscleSorenessView, nil] withCurrentValue:muscle_soreness withAverageValue:avg_muscle_soreness withFitnessCount:overallWellnessCount];
    
   overallWellnessCount =[self changeFrameForIndicatorView:[NSArray arrayWithObjects:wellnessView.trainingStateView, wellnessView.avgTrainingStateView, nil] withCurrentValue:training_state withAverageValue:avg_training_state withFitnessCount:overallWellnessCount];
    
   overallWellnessCount =[self changeFrameForIndicatorView:[NSArray arrayWithObjects:wellnessView.romTightnessView, wellnessView.avgROMTightnessView, nil] withCurrentValue:rom_tightness withAverageValue:avg_rom_tightness withFitnessCount:overallWellnessCount];
    
   overallWellnessCount =[self changeFrameForIndicatorView:[NSArray arrayWithObjects:wellnessView.hipflexorQuadView, wellnessView.avgHipFlexorQuadView, nil] withCurrentValue:hipflexor_quads withAverageValue:avg_hipflexor_quads withFitnessCount:overallWellnessCount];
   
    overallWellnessCount =[self changeFrameForIndicatorView:[NSArray arrayWithObjects:wellnessView.groinView, wellnessView.avgGroinView, nil] withCurrentValue:groins withAverageValue:avg_groins withFitnessCount:overallWellnessCount];
   
    overallWellnessCount =[self changeFrameForIndicatorView:[NSArray arrayWithObjects:wellnessView.hamstringView, wellnessView.avgHamstringView, nil] withCurrentValue:hamstrings withAverageValue:avg_hamstring withFitnessCount:overallWellnessCount];
    
    
    CGRect overallwellnessView = wellnessView.overallWelnessView.frame;
    
    double overallPC = overallWellnessCount/11.0;
    
    [utilities setFitnessViewChange:wellnessView.wellnessView withPercentage:overallPC withCount:0];
    
    [utilities setIcon:self.wellBeingIndicatorImage withPercentage:[self.player.Wellbeing floatValue] withValue:WELLBEING];
    
    overallwellnessView.size.width = overallwellnessView.size.width * overallPC;
    overallwellnessView.size.height = overallwellnessView.size.height;
    [wellnessView.overallWelnessView setFrame:overallwellnessView];
    
    overallPC = overallPC * 100;
    
    NSInteger wellnessPC = (int)overallPC;
    
    NSMutableAttributedString * wellnessText = [utilities getAttributedString:[NSString stringWithFormat:@"%ld%@", wellnessPC, @"%"] mainTextFontSize:36 subTextFontSize:20];
    
    [wellnessView.wellnessRatingView setAttributedText:wellnessText];
    
    [wellnessView.wellnessCountView setText:[NSString stringWithFormat:@"%ld/11",overallWellnessCount]];
    
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

-(void) wellBeingViewTapped:(id)sender {
    
    self.tabScrollView.contentSize = CGSizeMake(320, 650);
    
    [self setUpWellBeingView];
}

- (NSInteger) changeFrameForIndicatorView: (NSArray*) views withCurrentValue:(NSString*) currentValue withAverageValue:(NSInteger) averageValue withFitnessCount:(NSInteger) overallFitnessCount {
    
    CGRect loadedMarchFrame;
    
    CGFloat loadedMarchPC = ([currentValue intValue]/(CGFloat)averageValue);
    
    if(loadedMarchPC < 1) {
        
        loadedMarchFrame =  ((UIView*)[views objectAtIndex:0]).frame;
    } else {
        
        loadedMarchFrame =  ((UIView*)[views objectAtIndex:1]).frame;
    }
    
    overallFitnessCount = [utilities setFitnessViewChange:((UIView*)[views objectAtIndex:0]) withPercentage:loadedMarchPC withCount:overallFitnessCount];
    
    if(loadedMarchPC < 1) {
        
        loadedMarchFrame.size.width = loadedMarchFrame.size.width * loadedMarchPC;
        loadedMarchFrame.size.height = loadedMarchFrame.size.height;
        [((UIView*)[views objectAtIndex:0]) setFrame:loadedMarchFrame];
    } else {
        
        loadedMarchFrame.size.width = loadedMarchFrame.size.width / loadedMarchPC;
        loadedMarchFrame.size.height = loadedMarchFrame.size.height;
        [((UIView*)[views objectAtIndex:1]) setFrame:loadedMarchFrame];
    }
    
    return overallFitnessCount;
    
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
