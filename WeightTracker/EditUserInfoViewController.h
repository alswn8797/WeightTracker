//
//  EditUserInfoViewController.h
//  BodyTracker
//
//  Created by MInju on 27/09/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface EditUserInfoViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *pickerAgeArr;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segGender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerAge;

- (IBAction)updateUserInfo:(id)sender;

@end
