//
//  BMIViewController.h
//  BodyTracker
//
//  Created by MInju on 10/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BMICounterView.h"

@interface BMIViewController : UIViewController

@property (nonatomic) NSString *bmiString;

@property (weak, nonatomic) IBOutlet BMICounterView *bmiCounterView;
@property (weak, nonatomic) IBOutlet UILabel *bmiLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmiStateLabel;


@property (weak, nonatomic) IBOutlet UILabel *idealWeightLabel;

@end
