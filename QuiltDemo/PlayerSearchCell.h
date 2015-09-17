//
//  PlayerSearchCell.h
//  Waratahs
//
//  Created by Pruthvi on 18/02/14.
 
//

#import <UIKit/UIKit.h>

@interface PlayerSearchCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UIImageView * playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UIImageView *playerRiskIcon;
@property (weak, nonatomic) IBOutlet UILabel *playerRiskLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerFitnessIcon;
@property (weak, nonatomic) IBOutlet UILabel *playerFitnessLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerWellBeingIcon;
@property (weak, nonatomic) IBOutlet UILabel *playerWellBeingLabel;

@end
