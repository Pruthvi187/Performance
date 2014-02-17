//
//  TeamStatsViewController.m
//  Waratahs
//
//  Created by Pruthvi on 14/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "TeamStatsViewController.h"

@interface TeamStatsViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dismissView:(id)sender
{
    NSLog(@"Clicked");
    [self dismissViewControllerAnimated:YES completion:nil];
   
}
@end
