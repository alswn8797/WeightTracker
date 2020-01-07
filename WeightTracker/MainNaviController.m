//
//  MainNaviController.m
//  BodyTracker
//
//  Created by MInju on 14/9/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "MainNaviController.h"
#import "User+CoreDataClass.h"
#import "Setting+CoreDataClass.h"

@interface MainNaviController ()

@end

@implementation MainNaviController

@synthesize userArray, settingArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    userArray = [[NSMutableArray alloc] init];
    
    // Fetch the user from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    userArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    //NSLog(@"count=%ld", (unsigned long)[userArray count]);

    if([userArray count] > 0){
        self.app.IsUserInfoStored = YES;
        //if user information is stored then set appDelegate userInformation and also setting as user from coreData
        User *tempUser = [self.userArray objectAtIndex:0];
        [self.app.userInfomation setAge: tempUser.age];
        [self.app.userInfomation setGender: tempUser.gender];
        [self.app.userInfomation setHeight: tempUser.height];
        [self.app.userInfomation setWeight: tempUser.weight];
        
        //get setting from core data
        settingArray = [[NSMutableArray alloc] init];
        
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Setting"];
        settingArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        Setting *tempSetting = [self.settingArray objectAtIndex:0];
        [self.app.unitSetting setUnitHeight: tempSetting.unitHeight];
        [self.app.unitSetting setUnitWeight: tempSetting.unitWeight];
        
    } else {
        self.app.IsUserInfoStored = NO;
    }
    
    //NSLog(@"Bool value: %d",self.app.IsUserInfoStored);
    
    //UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
    //userInfoViewController.theData = theData;
    
    UIStoryboard *storyboard = [self storyboard];
    NSString *identifier = (self.app.IsUserInfoStored? @"mainTabBarController" : @"welcomeUserInformation");
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:identifier];
    self.viewControllers = @[ vc ];
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
