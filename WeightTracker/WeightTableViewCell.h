//
//  WeightTableViewCell.h
//  BodyTracker
//
//  Created by MInju on 13/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@end
