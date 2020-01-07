//
//  WeightViewController.h
//  BodyTracker
//
//  Created by MInju on 13/9/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface WeightViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property(weak,nonatomic)AppDelegate *appDelegate;

@property (strong, nonatomic) NSMutableArray *pickerKgArr;
@property (strong, nonatomic) NSMutableArray *pickerLbsArr;
@property (strong, nonatomic) NSString *weightString;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segWeightUnit;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerKg;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerLbs;

- (IBAction)changeUnit:(id)sender;

- (IBAction)saveData:(id)sender;

@end
