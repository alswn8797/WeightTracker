//
//  HeightViewController.h
//  BodyTracker
//
//  Created by MInju on 13/9/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HeightViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *pickerCmArr;
@property (strong, nonatomic) NSMutableArray *pickerInchesArr;
@property (strong, nonatomic) NSString *heightString;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segHeightUnit;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCm;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerInches;

- (IBAction)changeUnit:(id)sender;

- (IBAction)inputHeight:(id)sender;

@end
