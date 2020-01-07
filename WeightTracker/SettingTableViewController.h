//
//  SettingTableViewController.h
//  BodyTracker
//
//  Created by MInju on 25/09/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface SettingTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *SegHeightUnit;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegWeightUnit;

- (IBAction)ChangeHeightUnit:(id)sender;
- (IBAction)ChangeWeightUnit:(id)sender;

@end
