//
//  WeightTotalViewController.m
//  BodyTracker
//
//  Created by MInju on 03/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "WeightTotalViewController.h"
#import "WeightEditViewController.h"
#import "Weight+CoreDataClass.h"
#import "User+CoreDataClass.h"

@interface WeightTotalViewController ()

@end

@implementation WeightTotalViewController

@synthesize avgLabel, maxLabel, minLabel, avg, max, min, unitString, weightGraphView;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    
    context = [self managedObjectContext];
    weightArr = [self getWeightArray:context];
    [weightTableView reloadData];
    
    weightGraphView.layer.sublayers = nil;
    [weightGraphView setSubWeightArr:weightArr];
    
    NSString *avgString;
    NSString *maxString;
    NSString *minString;
    
    if(self.app.unitSetting.unitWeight == 0){ //kg
        unitString = @"kg";
        avgString = [NSString stringWithFormat:@"%.1lf", [avg doubleValue]];
        maxString = [NSString stringWithFormat:@"%.1lf", [max doubleValue]];
        minString = [NSString stringWithFormat:@"%.1lf", [min doubleValue]];
    } else { //lbs
        unitString = @"lbs";
        avgString = [NSString stringWithFormat:@"%.0lf", [avg doubleValue]];
        maxString = [NSString stringWithFormat:@"%.0lf", [max doubleValue]];
        minString = [NSString stringWithFormat:@"%.0lf", [min doubleValue]];
    }
    
    [avgLabel setText: [NSString stringWithFormat:@"%@ %@", avgString, unitString]];
    [maxLabel setText: [NSString stringWithFormat:@"%@ %@", maxString, unitString]];
    [minLabel setText: [NSString stringWithFormat:@"%@ %@", minString, unitString]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [weightArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellId = @"WeightCell";
    WeightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 cellId];

    Weight *weight = [weightArr objectAtIndex:indexPath.row];
    NSString *weightString;
    
    if(self.app.unitSetting.unitWeight == 0) { //kg
        weightString = [NSString stringWithFormat:@"%0.1lf", weight.weight];
    } else { //lbs
        weightString = [NSString stringWithFormat:@"%0.0lf", weight.weight];
    }
    
    /*
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:weight.datetime];
    */
    
    NSString *dateString = [self getFormattedDateString:weight.datetime];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:250.0f/255.0f blue:154.0f/255.0f alpha:1.0f];
    [cell setSelectedBackgroundView:bgColorView];
    [cell.weightLabel setText: [NSString stringWithFormat:@"%@ %@", weightString, unitString]];
    [cell.dateLabel setText: dateString];
    return cell;
}

- (NSString*) getFormattedDateString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Weight *weight = [weightArr objectAtIndex:indexPath.row];
        //delete object from core data
        [context deleteObject: weight];
        
        //delete from coredata
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        }
        
        //check recent weight and update user and appdelegate userinformation
        User *user = [self getUser:context];
        Weight *recentWeight = [self getRecentWeight:context];
        
        user.weight = recentWeight.weight;
        self.app.userInfomation.weight = recentWeight.weight;
        
        if (![context save:&error]) {
            NSLog(@"Can't Update User! %@ %@", error, [error localizedDescription]);
        }
        
        [weightArr removeObjectAtIndex:indexPath.row];
        weightGraphView.layer.sublayers = nil;
        [weightGraphView setSubWeightArr:weightArr];
        [weightTableView reloadData];
    } else {
        NSLog(@"Unhandled editing style! %ld", (long)editingStyle);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"updateWeight"]) {
        NSIndexPath *indexPath = [weightTableView indexPathForSelectedRow];
        Weight *weight = weightArr[indexPath.row];
        [[segue destinationViewController] setContext:context];
        [[segue destinationViewController] setWeight:weight];
    }
}

- (Weight*) getRecentWeight:(NSManagedObjectContext*) context{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Weight" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"datetime" ascending:NO];
    NSArray *sortDescription = [[NSArray alloc] initWithObjects:sort, nil];
    [fetchRequest setSortDescriptors:sortDescription];
    
    NSError *error = nil;
    tempArray = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    Weight *recentWeight = [tempArray objectAtIndex:0];
    
    return recentWeight;
}

- (User*) getUser:(NSManagedObjectContext*) context {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    tempArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    User *user = [tempArray objectAtIndex:0];
    
    return user;
}

- (NSMutableArray*) getWeightArray:(NSManagedObjectContext*) context{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    /*
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Weight"];
    tempArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    */
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Weight" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"datetime" ascending:NO];
    NSArray *sortDescription = [[NSArray alloc] initWithObjects:sort, nil];
    [fetchRequest setSortDescriptors:sortDescription];
    
    NSError *error = nil;
    tempArray = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    max = [tempArray valueForKeyPath:@"@max.weight"];
    min = [tempArray valueForKeyPath:@"@min.weight"];
    avg = [tempArray valueForKeyPath:@"@avg.weight"];
    
    return tempArray;
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
