//
//  PlayerProfileCollectionCell.h
//  Waratahs
//
//  Created by Pruthvi on 13/02/14.
 
//

#import <UIKit/UIKit.h>

@interface PlayerProfileCollectionCell : UICollectionViewCell

@property(nonatomic, retain) IBOutlet UIImageView * playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerName;

@property (weak, nonatomic) IBOutlet UIImageView *riskImage;
@property (weak, nonatomic) IBOutlet UILabel *riskText;
@property (weak, nonatomic) IBOutlet UIImageView *fitnessImage;
@property (weak, nonatomic) IBOutlet UILabel *fitnessText;
@property (weak, nonatomic) IBOutlet UIImageView *wellBeingImage;
@property (weak, nonatomic) IBOutlet UILabel *wellBeingText;

@end
