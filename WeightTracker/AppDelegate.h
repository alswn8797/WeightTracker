//
//  AppDelegate.h
//  BodyTracker
//
//  Created by MInju on 3/9/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Model/UserInformation.h"
#import "Model/UnitSetting.h"
#import "Model/UnitWeight.h"
/*
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL IsUserInfoStored;
    UserInformation* userInfomation;
    UnitSetting* unitSetting;
    UnitWeight* unitWeight;
}
*/
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (nonatomic) BOOL IsUserInfoStored;
@property (retain, nonatomic) UserInformation *userInfomation;
@property (retain, nonatomic) UnitSetting *unitSetting;
@property (retain, nonatomic) UnitWeight *unitWeight;

//@property (nonatomic, assign) int previousTabIndex;
//@property (strong,          ) UITabBarController *tabBarController;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
