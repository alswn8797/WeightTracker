//
//  EditHeightViewController.h
//  BodyTracker
//
//  Created by MInju on 28/09/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface EditHeightViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *pickerCmArr;
@property (strong, nonatomic) NSMutableArray *pickerInchesArr;
@property (strong, nonatomic) NSString *heightString;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerCm;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerInches;

- (IBAction)updateHeight:(id)sender;

@end
