//
//  WeightAddViewController.h
//  BodyTracker
//
//  Created by MInju on 12/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface WeightAddViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *pickerDate;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerKg;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerLbs;

@property (strong, nonatomic) NSMutableArray *pickerKgArr;
@property (strong, nonatomic) NSMutableArray *pickerLbsArr;
@property (strong, nonatomic) NSString *weightString;

- (IBAction)addWeight:(id)sender;

@end
