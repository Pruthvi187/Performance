//
//  TeamStatsViewController.m
//  Waratahs
//
//  Created by Pruthvi on 14/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "TeamStatsViewController.h"
#import "GraphCollectionCell.h"
#import "PlayerItems.h"
#import "Player.h"
#import "DataModel.h"
#import "Colours.h"

static NSString *const FRONT_ROW_PLOT      = @"Front Row";
static NSString *const BACK_ROW_PLOT = @"Back Row";

@interface TeamStatsViewController ()
{
    DataModel * dataModel;
    NSMutableArray * backsPlotArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *statsGraphArray;
@property (nonatomic) NSMutableArray * players;

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
    self.contentScrollView.contentSize = CGSizeMake(1024, 1600);
}

- (void)viewDidLoad
{
    
    self.contentScrollView.scrollEnabled = YES;
    
    UINib * graphCellNib = [UINib nibWithNibName:@"GraphCollectionCell" bundle:nil];
    [self.graphCollectionView registerNib:graphCellNib forCellWithReuseIdentifier:@"GraphCollectionCell"];
    self.statsGraphArray = [[NSMutableArray alloc] initWithObjects:@"charts_1", @"charts_2", @"charts_3", @"charts_4", @"charts_5",nil];
    
    [self initializeData];
    
    [self setupGraph];
    
    [self setupAxes];
    
    [self setupScatterPlots];
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
    return CGSizeMake(400, 200);
}

#pragma mark UIPageControl Delegate methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentIndex = self.graphCollectionView.contentOffset.x / self.graphCollectionView.frame.size.width;
    self.pageControl.currentPage = currentIndex;
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
    lineStyle.lineColor              = UIColorFromHex(0x86BDE9);
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // Set plot delegate, to know when symbols have been touched
    // We will display an annotation when a symbol is touched
    dataSourceLinePlot.delegate                        = self;
    // dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0;
    
    // Create a plot for the selection marker
    CPTScatterPlot *selectionPlot = [[CPTScatterPlot alloc] init];
    selectionPlot.identifier     = BACK_ROW_PLOT;
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
    PlayerItems * playerItems = [dataModel getPlayerItems:nil forMainPosition:nil];
    self.players = playerItems.players;
    
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

    
    for ( NSUInteger i = 0; i < 15; i++ ) {
        id x = [NSNumber numberWithDouble:i * 0.5];
        id y;
        if(i <14)
        {
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
}


#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 15;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    NSNumber *num = nil;
    
    
   
    
    if ([plot.identifier isEqual:FRONT_ROW_PLOT]) {
        NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
        num = [[dataForPlot objectAtIndex:index] valueForKey:key];
    } else if ([plot.identifier isEqual:BACK_ROW_PLOT]) {
        NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
        num = [[backsPlotArray objectAtIndex:index] valueForKey:key];
    }
    
   
    
    
    return num;
}

-(CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)index
{
    static CPTPlotSymbol *redDot = nil;
    
    static CPTPlotSymbol *blueDot = nil;
    
    CPTPlotSymbol *symbol = (id)[NSNull null];
    
    if ( [(NSString *)plot.identifier isEqualToString : BACK_ROW_PLOT] && index == 14) {
        if ( !redDot ) {
            redDot            = [[CPTPlotSymbol alloc] init];
            redDot.symbolType = CPTPlotSymbolTypeEllipse;
            redDot.size       = CGSizeMake(5.0, 5.0);
            redDot.fill       = [CPTFill fillWithColor:[CPTColor redColor]];
        }
        symbol = redDot;
    }
    else if([(NSString *)plot.identifier isEqualToString : FRONT_ROW_PLOT] && index == 14)
    {
        if ( !blueDot ) {
            blueDot            = [[CPTPlotSymbol alloc] init];
            blueDot.symbolType = CPTPlotSymbolTypeEllipse;
            blueDot.size       = CGSizeMake(5.0, 5.0);
            blueDot.fill       = [CPTFill fillWithColor:UIColorFromHex(0x86BDE9)];
        }
        symbol = blueDot;
    }
    
    
    return symbol;
}



@end
