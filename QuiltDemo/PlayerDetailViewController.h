//
//  PlayerDetailViewController.h
//  Waratahs
//
//  Created by Pruthvi on 17/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot/CorePlot-CocoaTouch.h>

@interface PlayerDetailViewController : UIViewController<CPTPlotDataSource, CPTPlotDelegate>
{
    CPTXYGraph * graph;
    NSMutableArray *dataForPlot;
}

@property(nonatomic, retain) IBOutlet CPTGraphHostingView* hostView;

@property (nonatomic, readwrite, strong) NSMutableArray *dataForPlot;

@end
