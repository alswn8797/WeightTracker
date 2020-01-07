//
//  WeightTotalViewController.h
//  BodyTracker
//
//  Created by MInju on 03/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "WeightTableViewCell.h"
#import "WeightGraphView.h"

@interface WeightTotalViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{

    IBOutlet UITableView *weightTableView;
    NSMutableArray *weightArr;
    NSManagedObjectContext *context;
}

@property (strong, nonatomic) NSString *unitString;
@property (strong, nonatomic) NSNumber *max;
@property (strong, nonatomic) NSNumber *min;
@property (strong, nonatomic) NSNumber *avg;

@property (weak, nonatomic) IBOutlet UILabel *avgLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;

@property (weak, nonatomic) IBOutlet WeightGraphView *weightGraphView;

@end
