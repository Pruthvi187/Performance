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
 
    [self setupView];
    
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

-(void) setupView
{
    
  
    
    
    DataModel * dataModel = [DataModel sharedClient];
    
    WellnessPlayers * wellnessItems = [dataModel getPlayersWellness:self.player];
    
    Wellness * wellness = [wellnessItems.wellness lastObject];
    
    ModelItems * modelItems = [dataModel getModelItems:self.player];
    
    Model * model = [modelItems.models firstObject];
    
    Utilities * utilities = [Utilities sharedClient];
    
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
    
    self.dobLabel.text = self.player.DOB;
    
    self.ageLabel.text = self.player.Age;
    
    self.debutLabel.text = self.player.Debut;
    
    self.heightLabel.text = self.player.Height;
    
    self.weightLabel.text = self.player.Weight;
    
    self.positionLabel.text = self.player.Position;
    
    self.capsLabel.text = self.player.Caps;
    
    //self.yearsPlayingLabel.text = [NSString stringWithFormat:@"%@",model.Yrs_Playing];
    
    [self.profileImage setImage:[UIImage imageNamed:self.player.ProfileImage]];
    
    [self.playerName setText:self.player.Name];
    
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
    
    UIImage *backGroundGradientImage = [UIImage imageNamed:@"player-bg-top.png"];
    UIImageView * backGradientImageView = [[UIImageView alloc] initWithImage:backGroundGradientImage];
    backGradientImageView.frame = CGRectMake(215, 0, 820, 520);
    [self.view addSubview:backGradientImageView];
    [self.view sendSubviewToBack:backGradientImageView];
    
    
    
    UINib *playerCellNib = [UINib nibWithNibName:@"PlayerSearchCell" bundle:nil];
    [self.playerTableView registerNib:playerCellNib forCellReuseIdentifier:@"PlayerCell"];
    
    self.tabScrollView.delegate = self;
    
    self.tabScrollView.scrollEnabled = YES;
    
    fitnessView = [[[NSBundle mainBundle] loadNibNamed:@"FitnessView" owner:self options:nil] objectAtIndex:0];
    fitnessView.frame = CGRectMake(30, 100, 811, 315);
    [self.tabScrollView addSubview:fitnessView];
    [self.tabScrollView bringSubviewToFront:fitnessView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tabScrollView.contentSize =CGSizeMake(851.0f, 650.0f);
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
    
    self.players = [@[] mutableCopy];
    dataModel = [DataModel sharedClient];
    PlayerItems * playerItems = [dataModel getPlayerItems:nil forMainPosition:nil];
    self.players = playerItems.players;
    
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

#pragma Tab button click action events

-(IBAction)fitnessButtonClicked:(id)sender
{
    [self.fitnessButton setImage:[UIImage imageNamed:@"tab-selected"] forState:UIControlStateNormal];
    [self.riskButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
    [self.wellBeingButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
    
    wellnessView.hidden = YES;
    fitnessView.hidden = YES;
    riskView.hidden = YES;
    
    fitnessView = [[[NSBundle mainBundle] loadNibNamed:@"FitnessView" owner:self options:nil] objectAtIndex:0];
    fitnessView.frame = CGRectMake(30, 100, 811, 315);
    [self.tabScrollView addSubview:fitnessView];
    [self.tabScrollView bringSubviewToFront:fitnessView];
}

-(IBAction)riskButtonClicked:(id)sender
{
    wellnessView.hidden = YES;
    fitnessView.hidden = YES;
    
    riskView = [[[NSBundle mainBundle] loadNibNamed:@"RiskView" owner:self options:nil] objectAtIndex:0];
    riskView.frame = CGRectMake(30, 100, 811, 315);
    [self.tabScrollView addSubview:riskView];
    [self.tabScrollView bringSubviewToFront:riskView];
 
    
     [self.riskButton setImage:[UIImage imageNamed:@"tab-selected"] forState:UIControlStateNormal];
     [self.fitnessButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
     [self.wellBeingButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
}

-(IBAction)wellBeingButtonClicked:(id)sender
{
    fitnessView.hidden = YES;
    riskView.hidden = YES;
    
    int overallWellnessCount = 0;
    
    wellnessView = [[[NSBundle mainBundle] loadNibNamed:@"WellnessView" owner:self options:nil] objectAtIndex:0];
    wellnessView.frame = CGRectMake(30, 100, 811, 315);
    [self.tabScrollView addSubview:wellnessView];
    [self.tabScrollView bringSubviewToFront:wellnessView];
    wellnessView.sleeplessLabel.text = [NSString stringWithFormat:@"%@",sleep_quality];
    wellnessView.avgSleepQualityLabel.text = [NSString stringWithFormat:@"%d",avg_sleep_quality];
    
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
    
    CGRect sleepQualFrame = wellnessView.sleeplessnessView.frame;
    
    double  sleepPC = ([sleep_quality intValue]/(double)avg_sleep_quality);
    
    if(sleepPC < 1.0)
    {
        [wellnessView.sleeplessnessView setBackgroundColor:UIColorFromHex(0xF6691B)];
    }
    else
    {
        overallWellnessCount++;
    }
    
    sleepQualFrame.size.width = sleepQualFrame.size.width * sleepPC;
    sleepQualFrame.size.height = sleepQualFrame.size.height;
    [wellnessView.sleeplessnessView setFrame:sleepQualFrame];
    
    CGRect legHeavinessFrame = wellnessView.legHeavinessView.frame;
    
    double  legHeavinessPC = ([leg_heaviness intValue]/(double)avg_leg_heaviness);
    
    if(legHeavinessPC > 1.0)
    {
        [wellnessView.legHeavinessView setBackgroundColor:UIColorFromHex(0xF6691B)];
    }
    else
    {
        overallWellnessCount++;
    }
    
    legHeavinessFrame.size.width = legHeavinessFrame.size.width * legHeavinessPC;
    legHeavinessFrame.size.height = legHeavinessFrame.size.height;
    [wellnessView.legHeavinessView setFrame:legHeavinessFrame];
    
    CGRect backPainView = wellnessView.backPainView.frame;
    
    double  backPainPC = ([back_pain intValue]/(double)avg_back_pain);
    
    if(backPainPC > 1.0)
    {
        [wellnessView.backPainView setBackgroundColor:UIColorFromHex(0xF6691B)];
    }
    else
    {
        overallWellnessCount++;
    }
    
    backPainView.size.width = backPainView.size.width * backPainPC;
    backPainView.size.height = backPainView.size.height;
    [wellnessView.backPainView setFrame:backPainView];
    
    CGRect calvesView = wellnessView.calvesView.frame;
    
    double calvesPC = ([calves intValue]/(double)avg_calves);
    
    if(calvesPC > 1.0)
    {
        [wellnessView.calvesView setBackgroundColor:UIColorFromHex(0xF6691B)];
    }
    else
    {
        overallWellnessCount++;
    }
    
    calvesView.size.width = calvesView.size.width * calvesPC;
    calvesView.size.height = calvesView.size.height;
    [wellnessView.calvesView setFrame:calvesView];
    
    CGRect recoveryIndexView = wellnessView.recoveryIndexView.frame;
    
    double recoveryIndexPC = ([recovery_index intValue]/(double)avg_recovery_index);
    
    if(recoveryIndexPC < 1.0)
    {
        [wellnessView.recoveryIndexView setBackgroundColor:UIColorFromHex(0xF6691B)];
    }
    else
    {
        overallWellnessCount++;
    }
    
    recoveryIndexView.size.width = recoveryIndexView.size.width * recoveryIndexPC;
    recoveryIndexView.size.height = recoveryIndexView.size.height;
    [wellnessView.recoveryIndexView setFrame:recoveryIndexView];
    
    CGRect muscleSorenessFrame = wellnessView.muscleSorenessView.frame;
    
    double muscleSorenessPC = ([muscle_soreness intValue]/(double)avg_muscle_soreness);
    
    if(muscleSorenessPC > 1.0)
    {
        [wellnessView.recoveryIndexView setBackgroundColor:UIColorFromHex(0xF6691B)];
    }
    else
    {
        overallWellnessCount++;
    }
    
    muscleSorenessFrame.size.width = muscleSorenessFrame.size.width * muscleSorenessPC;
    muscleSorenessFrame.size.height = muscleSorenessFrame.size.height;
    [wellnessView.muscleSorenessView setFrame:muscleSorenessFrame];
    
    CGRect trainingStateFrame = wellnessView.trainingStateView.frame;
    
    double trainingStatePC = ([training_state intValue]/(double)avg_training_state);
    
    if(trainingStatePC > 1.0)
    {
        [wellnessView.trainingStateView setBackgroundColor:UIColorFromHex(0xF6691B)];
    }
    else
    {
        overallWellnessCount++;
    }
    
    trainingStateFrame.size.width = trainingStateFrame.size.width * trainingStatePC;
    trainingStateFrame.size.height = trainingStateFrame.size.height;
    [wellnessView.trainingStateView setFrame:trainingStateFrame];
    
    CGRect romTightnessFrame = wellnessView.romTightnessView.frame;
    
    double romTighnessPC = ([rom_tightness intValue]/(double)avg_rom_tightness);
    
    if(romTighnessPC > 1.0)
    {
        [wellnessView.romTightnessView setBackgroundColor:UIColorFromHex(0xF6691B)];
    }
    else
    {
        overallWellnessCount++;
    }
    
    romTightnessFrame.size.width = romTightnessFrame.size.width * romTighnessPC;
    romTightnessFrame.size.height = romTightnessFrame.size.height;
    [wellnessView.romTightnessView setFrame:romTightnessFrame];
    
    CGRect hipFlexorQuadFrame = wellnessView.hipflexorQuadView.frame;
    
    double hipflexorPC = ([hipflexor_quads intValue]/(double)avg_hipflexor_quads);
    
    if(hipflexorPC > 1.0)
    {
        [wellnessView.hipflexorQuadView setBackgroundColor:UIColorFromHex(0xF6691B)];
    }
    else
    {
        overallWellnessCount++;
    }
    
    hipFlexorQuadFrame.size.width = hipFlexorQuadFrame.size.width * hipflexorPC;
    hipFlexorQuadFrame.size.height = hipFlexorQuadFrame.size.height;
    [wellnessView.hipflexorQuadView setFrame:hipFlexorQuadFrame];
    
    CGRect groinFrame = wellnessView.groinView.frame;
    
    double groinPC = ([groins intValue]/(double)avg_groins);
    
    if(groinPC > 1.0)
    {
        [wellnessView.groinView setBackgroundColor:UIColorFromHex(0xF6691B)];
    }
    else
    {
        overallWellnessCount++;
    }
    
    groinFrame.size.width = groinFrame.size.width * groinPC;
    groinFrame.size.height = groinFrame.size.height;
    [wellnessView.groinView setFrame:groinFrame];
    
    CGRect hamstringFrame = wellnessView.hamstringView.frame;
    
    double hamStringPC = ([hamstrings intValue]/(double)avg_hamstring);
    
    if(hamStringPC > 1.0)
    {
        [wellnessView.hamstringView setBackgroundColor:UIColorFromHex(0xF6691B)];
    }
    else
    {
        overallWellnessCount++;
    }
    
    hamstringFrame.size.width = hamstringFrame.size.width * hamStringPC;
    hamstringFrame.size.height = hamstringFrame.size.height;
    [wellnessView.hamstringView setFrame:hamstringFrame];
    
    CGRect overallwellnessView = wellnessView.overallWelnessView.frame;
    
    double overallPC = overallWellnessCount/11.0;
    
    if(overallPC > 0.5)
    {
        [wellnessView.overallWelnessView setBackgroundColor:UIColorFromHex(0x53B61E)];
    }
    
    overallwellnessView.size.width = overallwellnessView.size.width * overallPC;
    overallwellnessView.size.height = overallwellnessView.size.height;
    [wellnessView.overallWelnessView setFrame:overallwellnessView];
    
    [wellnessView.wellnessCountView setText:[NSString stringWithFormat:@"%d/11",overallWellnessCount]];
    
    [self.wellBeingButton setImage:[UIImage imageNamed:@"tab-selected"] forState:UIControlStateNormal];
    [self.riskButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
    [self.fitnessButton setImage:[UIImage imageNamed:@"tab-unselected"] forState:UIControlStateNormal];
}




@end
