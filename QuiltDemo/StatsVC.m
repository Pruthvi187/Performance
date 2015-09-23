//
//  StatsVC.m
//  Waratahs
//
//  Created by Pruthvi on 14/11/2014.
 
//

#import "StatsVC.h"

#import "GraphCollectionCell.h"
#import "PlayerItems.h"
#import "Player.h"
#import "DataModel.h"
#import "Colours.h"
#import "Utilities.h"

#define FRONT_ROW_PLOT    @"Front Row"
#define BACK_ROW_PLOT  @"Back Row"



@interface StatsVC () {
    
    DataModel * dataModel;
    NSMutableArray * backsPlotArray;
    Utilities * utilities;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *statsGraphArray;
@property (nonatomic) NSMutableArray * players;

@end

@implementation StatsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINib * graphCellNib = [UINib nibWithNibName:@"GraphCollectionCell" bundle:nil];
    [self.graphCollectionView registerNib:graphCellNib forCellWithReuseIdentifier:@"GraphCollectionCell"];
    self.statsGraphArray = [[NSMutableArray alloc] initWithObjects:@"Running", @"AccelerationsPerHour", @"sitAndReach", @"AverageForceLoad", @"SumofSprint",nil];
    
   utilities = [Utilities sharedClient];
    
    NSInteger riskRating = [utilities getAverageRiskOfInjury];
    
    NSMutableAttributedString * riskText = [utilities getAttributedString:[NSString stringWithFormat:@"%ld%@", (long)riskRating, @"%"] mainTextFontSize:36 subTextFontSize:20];
    
    [_riskRatingLabel setAttributedText:riskText];
    
    [utilities setMainViewChange:_riskRatingView withPercentage:riskRating withCount:0];
    
    [self initializeData];
    
    [self setupGraph];
    
    [self setupAxes];
    
    [self setupScatterPlots];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //self.contentScrollView.contentSize = CGSizeMake(320, 1000);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil  ];
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
    return CGSizeMake(400, 200);
}

-(void) setupGraph
{
    // Create graph and apply a dark theme
    graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame : self.hostView.bounds];
    graph.backgroundColor = [[UIColor clearColor] CGColor];
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
    
    y.minorTicksPerInterval       = 2;
    y.preferredNumberOfMajorTicks = 1;
    y.majorGridLineStyle          = majorGridLineStyle;
    y.minorGridLineStyle          = minorGridLineStyle;
    
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy              = CPTAxisLabelingPolicyEqualDivisions;
    
    x.minorTicksPerInterval       = 0;
    x.preferredNumberOfMajorTicks = 5;
    x.majorGridLineStyle          = majorGridLineStyle;
    x.minorGridLineStyle          = minorGridLineStyle;
    
    
}

-(void) setupScatterPlots
{
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    
    dataSourceLinePlot.identifier     = FRONT_ROW_PLOT;
    dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 2.0;
    lineStyle.lineColor              = [UIColor blackColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // Set plot delegate, to know when symbols have been touched
    // We will display an annotation when a symbol is touched
    dataSourceLinePlot.delegate                        = self;
    // dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0;
    
    // Create a plot for the selection marker
    /*CPTScatterPlot *selectionPlot = [[CPTScatterPlot alloc] init];
    selectionPlot.identifier     = BACK_ROW_PLOT;
    selectionPlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    lineStyle                   = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth         = 2.0;
    lineStyle.lineColor         = [CPTColor redColor];
    selectionPlot.dataLineStyle = lineStyle;
    
    selectionPlot.dataSource = self;
    [graph addPlot:selectionPlot];*/
    
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
    
    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:6];
    
    for ( NSUInteger i = 0; i < 6; i++ ) {
        id x = [NSNumber numberWithDouble:i * 0.5];
        id y;
        if(i <5)
        {
            float low_bound = [self.player.RiskRating intValue]  - 20;
            low_bound = low_bound > 0 ? low_bound : 0;
            float high_bound = [self.player.RiskRating intValue] + 20 ;
            high_bound = high_bound > 100 ? 90 : high_bound;
            float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
            // y = [NSNumber numberWithDouble:2.0 * rand() / (double)RAND_MAX];
            y = [NSNumber numberWithFloat:rndValue];
            //y = [NSNumber numberWithDouble:i*0.5];;
        }
        else
        {
            y = [NSNumber numberWithDouble:9.57];
        }
        [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
    NSMutableArray *contentArray2 = [NSMutableArray arrayWithCapacity:15];
    
    
    for ( NSUInteger i = 0; i < 6; i++ ) {
        id x = [NSNumber numberWithDouble:i * 0.5];
        id y;
        if(i <11) {
            float low_bound = 20;
            low_bound = low_bound > 0 ? low_bound : 0;
            float high_bound = 55 ;
            high_bound = high_bound > 100 ? 90 : high_bound;
            float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
            // y = [NSNumber numberWithDouble:2.0 * rand() / (double)RAND_MAX];
            y = [NSNumber numberWithFloat:rndValue];
            //y = [NSNumber numberWithDouble:i*0.5];;
        }
        else
        {
            y = [NSNumber numberWithDouble:35.12];
        }
        [contentArray2 addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
    
    backsPlotArray = contentArray2;
    dataForPlot = contentArray;
    
   
    
    NSMutableArray * array = [utilities getMonthsForGraphCoordinates];
    NSArray *graphArray = [[array reverseObjectEnumerator] allObjects];
    
    [_firstMonth setText:[graphArray objectAtIndex:0]];
    [_secondMonth setText:[graphArray objectAtIndex:1]];
    [_thirdMonth setText:[graphArray objectAtIndex:2]];
    [_fourthMonth setText:[graphArray objectAtIndex:3]];
    [_fifthMonth setText:[graphArray objectAtIndex:4]];
    [_lastMonth setText:[graphArray objectAtIndex:5]];
}


#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 6;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    NSNumber *num = nil;
    
    //if ([plot.identifier isEqual:FRONT_ROW_PLOT]) {
        NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
        num = [[dataForPlot objectAtIndex:index] valueForKey:key];
    /*} else if ([plot.identifier isEqual:BACK_ROW_PLOT]) {
        NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
        num = [[backsPlotArray objectAtIndex:index] valueForKey:key];
    }*/
    
    return num;
}

-(CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)index
{
    static CPTPlotSymbol *redDot = nil;
    
    static CPTPlotSymbol *blueDot = nil;
    
    CPTPlotSymbol *symbol = (id)[NSNull null];
    
    /*if ( [(NSString *)plot.identifier isEqualToString : BACK_ROW_PLOT] && index == 14) {
        if ( !redDot ) {
            redDot            = [[CPTPlotSymbol alloc] init];
            redDot.symbolType = CPTPlotSymbolTypeEllipse;
            redDot.size       = CGSizeMake(5.0, 5.0);
            redDot.fill       = [CPTFill fillWithColor:[CPTColor redColor]];
        }
        symbol = redDot;
    }
    else if([(NSString *)plot.identifier isEqualToString : FRONT_ROW_PLOT] && index == 14)
    {*/
        if ( !blueDot ) {
            blueDot            = [[CPTPlotSymbol alloc] init];
            blueDot.symbolType = CPTPlotSymbolTypeEllipse;
            blueDot.size       = CGSizeMake(5.0, 5.0);
            blueDot.fill       = [CPTFill fillWithColor:UIColorFromHex(0x86BDE9)];
        }
        symbol = blueDot;
    //}
    
    return symbol;
}
#pragma mark UIPageControl Delegate methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.graphCollectionView.frame.size.width;
    NSInteger pageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = pageNumber;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
