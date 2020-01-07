//
//  MainNaviController.h
//  BodyTracker
//
//  Created by MInju on 14/9/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface MainNaviController : UINavigationController

@property (strong, nonatomic) NSMutableArray *userArray;
@property (strong, nonatomic) NSMutableArray *settingArray;
@property (weak,nonatomic) AppDelegate *appDelegate;

@end
