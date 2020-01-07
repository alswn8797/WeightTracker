//
//  UserInfoViewController.h
//  BodyTracker
//
//  Created by MInju on 6/9/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserInfoViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *pickerAgeArr;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segGender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerAge;

- (IBAction)inputGenderAge:(id)sender;

@end
