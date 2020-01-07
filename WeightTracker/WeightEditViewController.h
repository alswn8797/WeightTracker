//
//  WeightEditViewController.h
//  BodyTracker
//
//  Created by MInju on 13/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Weight+CoreDataClass.h"

@interface WeightEditViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>{
    NSMutableArray *weightArr;
}

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Weight *weight;

@property (weak, nonatomic) IBOutlet UIDatePicker *pickerDate;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerKg;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerLbs;

@property (strong, nonatomic) NSMutableArray *pickerKgArr;
@property (strong, nonatomic) NSMutableArray *pickerLbsArr;
@property (strong, nonatomic) NSString *weightString;

- (IBAction)updateWeight:(id)sender;

@end
