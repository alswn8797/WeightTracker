//
//  SettingTableViewController.m
//  BodyTracker
//
//  Created by MInju on 25/09/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Setting+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Weight+CoreDataClass.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

@synthesize SegHeightUnit, SegWeightUnit;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{

    for (int i = 0; i < 2; i++)
    {
        if (i == self.app.unitSetting.unitHeight)
        {
            [SegHeightUnit setSelectedSegmentIndex:i];
        }
        if (i == self.app.unitSetting.unitWeight)
        {
            [SegWeightUnit setSelectedSegmentIndex:i];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (User*) getUser:(NSManagedObjectContext*) context {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    tempArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    User *user = [tempArray objectAtIndex:0];
    
    return user;
}

- (Setting*) getSetting:(NSManagedObjectContext*) context {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Setting"];
    tempArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    Setting *setting = [tempArray objectAtIndex:0];
    
    return setting;
}

- (NSMutableArray*) getWeightArray:(NSManagedObjectContext*) context{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Weight"];
    tempArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return tempArray;
}

- (IBAction)ChangeHeightUnit:(id)sender {
    //get Setting and User data
    NSManagedObjectContext *context = [self managedObjectContext];
    Setting *setting = [self getSetting:context];
    User *user = [self getUser:context];

    //get converted height
    NSString *heightString = [self.app.unitSetting changeHeightUnitTo:(int)SegHeightUnit.selectedSegmentIndex withHeight:self.app.userInfomation.height];
    
    //Change Appdelegate Userinformation Height value and setting
    self.app.unitSetting.unitHeight = (int)SegHeightUnit.selectedSegmentIndex;
    self.app.userInfomation.height = heightString;
    
    //update core data
    setting.unitHeight = (int)SegHeightUnit.selectedSegmentIndex;
    user.height = heightString;
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

}

- (IBAction)ChangeWeightUnit:(id)sender {
    //get Setting and User data
    NSManagedObjectContext *context = [self managedObjectContext];
    Setting *setting = [self getSetting:context];
    User *user = [self getUser:context];
    
    //get converted weight
    double weight = [self.app.unitSetting changeWeightUnitTo:(int)SegWeightUnit.selectedSegmentIndex withWeight:self.app.userInfomation.weight];
    
    //Change Appdelegate Userinformation Height value and setting
    self.app.unitSetting.unitWeight = (int)SegWeightUnit.selectedSegmentIndex;
    self.app.userInfomation.weight = weight;
    
    //update core data
    setting.unitWeight = (int)SegWeightUnit.selectedSegmentIndex;
    user.weight = weight;
    
    NSMutableArray *weightArr = [self getWeightArray:context];
    
    for(int i = 0; i<[weightArr count]; i++){
        Weight *weight = [weightArr objectAtIndex:i];
        weight.weight = [self.app.unitSetting changeWeightUnitTo:(int)SegWeightUnit.selectedSegmentIndex withWeight: weight.weight];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    //Change Appdelegate Userinformation Weight value
    //All weight in the core data must be updated
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

@end
