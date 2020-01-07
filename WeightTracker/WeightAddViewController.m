//
//  WeightAddViewController.m
//  BodyTracker
//
//  Created by MInju on 12/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "WeightAddViewController.h"
#import "Weight+CoreDataClass.h"
#import "User+CoreDataClass.h"

@interface WeightAddViewController ()

@end

@implementation WeightAddViewController

@synthesize pickerDate, pickerKg, pickerLbs, pickerKgArr, pickerLbsArr, weightString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pickerKg.tag = 1;
    pickerLbs.tag = 2;
    
    pickerKgArr = [[NSMutableArray alloc] init];
    [pickerKgArr addObject:[self makeArr:0 to:9]];
    [pickerKgArr addObject:[self makeArr:0 to:9]];
    [pickerKgArr addObject:[self makeArr:0 to:9]];
    [pickerKgArr addObject:@[@"."]];
    [pickerKgArr addObject:[self makeArr:0 to:9]];
    [pickerKgArr addObject:@[@"kg"]];
    
    pickerLbsArr = [[NSMutableArray alloc] init];
    [pickerLbsArr addObject:[self makeArr:0 to:9]];
    [pickerLbsArr addObject:[self makeArr:0 to:9]];
    [pickerLbsArr addObject:[self makeArr:0 to:9]];
    [pickerLbsArr addObject:@[@"lbs"]];
    
    pickerKg.dataSource = self;
    pickerKg.delegate = self;
    pickerLbs.dataSource = self;
    pickerLbs.delegate = self;
    
    if ((int)self.app.unitSetting.unitWeight == 0) { //cm
        pickerKg.hidden = NO;
        pickerLbs.hidden = YES;
    } else {
        pickerKg.hidden = YES;
        pickerLbs.hidden = NO;
    }

    pickerDate.maximumDate = [NSDate date];
    pickerDate.datePickerMode = UIDatePickerModeDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addWeight:(id)sender {
    if (self.app.unitSetting.unitWeight == 0) { //kg
        
        for(int i=0; i<5; i++){
            if(i==0){
                weightString = [[pickerKgArr objectAtIndex:i] objectAtIndex:[pickerKg selectedRowInComponent:i]];
            } else {
                weightString = [weightString stringByAppendingString: [[pickerKgArr objectAtIndex:i] objectAtIndex:[pickerKg selectedRowInComponent:i]]];
            }
        }
        
    } else {
        for(int i=0; i<3; i++){
            if(i==0){
                weightString = [[pickerLbsArr objectAtIndex:i] objectAtIndex:[pickerLbs selectedRowInComponent:i]];
            } else {
                weightString = [weightString stringByAppendingString: [[pickerLbsArr objectAtIndex:i] objectAtIndex:[pickerLbs selectedRowInComponent:i]]];
            }
        }
    }
    
    double inputWeight = [weightString doubleValue];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //check if coredata has an input with same date
    if([self checkExist:context withDate:[pickerDate date]]){
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Data Exist"
                                     message:@"A weight exists on chosen date, please try choose another date"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //nothing
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
      
        [self saveWeightwithContext:context andWeight:inputWeight];
    }
}

- (void) saveWeightwithContext:(NSManagedObjectContext*)context andWeight:(double)inputWeight{
    Weight* weight = [NSEntityDescription insertNewObjectForEntityForName:@"Weight" inManagedObjectContext:context];
    weight.weight = inputWeight;
    weight.datetime = [self dateWithOutTime:[pickerDate date]];
    
    //add weight in coredata
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save Weight! %@ %@", error, [error localizedDescription]);
    }
    
    //check recent weight and update user and appdelegate userinformation
    User *user = [self getUser:context];
    Weight *recentWeight = [self getRecentWeight:context];
    
    user.weight = recentWeight.weight;
    self.app.userInfomation.weight = recentWeight.weight;
    
    if (![context save:&error]) {
        NSLog(@"Can't Update User! %@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) checkExist:(NSManagedObjectContext*)context withDate:(NSDate*)date {
    NSEntityDescription *weight = [NSEntityDescription entityForName:@"Weight" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:weight];
    [request setFetchLimit:1];
    [request setPredicate:[NSPredicate predicateWithFormat:@"datetime == %@", [self dateWithOutTime:date]]];
    
    NSError *error = nil;
    NSUInteger count = [context countForFetchRequest:request error:&error];
    
    if (count)
        return YES;
    else
        return NO;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(pickerView.tag == 1){
        return [pickerKgArr count];
    } else {
        return [pickerLbsArr count];
    }
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView.tag == 1){
        return [[pickerKgArr objectAtIndex:component] count];
    } else {
        return [[pickerLbsArr objectAtIndex:component] count];
    }
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView.tag == 1){
        return [[pickerKgArr objectAtIndex:component] objectAtIndex:row];
    } else {
        return [[pickerLbsArr objectAtIndex:component] objectAtIndex:row];
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

- (NSDate*) dateWithOutTime:(NSDate*)datDate{
    if( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:datDate];
    [comps setHour:00];
    [comps setMinute:00];
    [comps setSecond:00];
    [comps setNanosecond:00];
    [comps setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
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


- (NSMutableArray*) makeArr:(int)si to:(int)ei{
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (int i=si; i<=ei; i++){
        [tmpArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return tmpArr;
}
@end
