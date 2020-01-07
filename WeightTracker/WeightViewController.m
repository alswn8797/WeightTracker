//
//  WeightViewController.m
//  BodyTracker
//
//  Created by MInju on 13/9/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "WeightViewController.h"
#import "User+CoreDataProperties.h"
#import "Setting+CoreDataProperties.h"
#import "Weight+CoreDataProperties.h"

@interface WeightViewController ()

@end

@implementation WeightViewController

@synthesize pickerKg, pickerLbs, pickerKgArr, pickerLbsArr, segWeightUnit, weightString;

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
    
    //hide inches because first segment will be chosen its first object //kg
    pickerKg.hidden = NO;
    pickerLbs.hidden = YES;
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

-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

- (IBAction)changeUnit:(id)sender {
    if (segWeightUnit.selectedSegmentIndex == 0) { //kg
        pickerKg.hidden = NO;
        pickerLbs.hidden = YES;
    } else { //lbs
        pickerKg.hidden = YES;
        pickerLbs.hidden = NO;
    }
}

- (IBAction)saveData:(id)sender {

    //this part to get selected value and set appdelegate userInformation and weight, setting
    if (segWeightUnit.selectedSegmentIndex == 0) { //kg
        
        for(int i=0; i<5; i++){
            if(i==0){
                weightString = [[pickerKgArr objectAtIndex:i] objectAtIndex:[pickerKg selectedRowInComponent:i]];
            } else {
                weightString = [weightString stringByAppendingString: [[pickerKgArr objectAtIndex:i] objectAtIndex:[pickerKg selectedRowInComponent:i]]];
            }
        }

    } else { //lbs
        for(int i=0; i<3; i++){
            if(i==0){
                weightString = [[pickerLbsArr objectAtIndex:i] objectAtIndex:[pickerLbs selectedRowInComponent:i]];
            } else {
                weightString = [weightString stringByAppendingString: [[pickerLbsArr objectAtIndex:i] objectAtIndex:[pickerLbs selectedRowInComponent:i]]];
            }
        }
    }
    
    [self.app.userInfomation setWeight:[weightString doubleValue]];
    
    int weightUnit = (int)segWeightUnit.selectedSegmentIndex;
    [self.app.unitSetting setUnitWeight:weightUnit];
    
    /*
    NSLog(@"Age:%d", self.app.userInfomation.age);
    NSLog(@"Gender:%d", self.app.userInfomation.gender);
    NSLog(@"Height:%@", self.app.userInfomation.height);
    NSLog(@"Weight:%@", self.app.userInfomation.weight);
    
    NSLog(@"HeightUnit:%d", self.app.unitSetting.unitHeight);
    NSLog(@"WeightUnit:%d", self.app.unitSetting.unitWeight);
    
    NSLog(@"%@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    */
    
    NSManagedObjectContext *context = [self managedObjectContext];
    [self saveUser:context];
    [self saveSetting:context];
    [self saveWeight:context];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save User! %@ %@", error, [error localizedDescription]);
    }
}

- (void) saveUser:(NSManagedObjectContext*)context{
    
    //User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:_appDelegate.managedObjectContext];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    user.age = self.app.userInfomation.age;
    user.gender = self.app.userInfomation.gender;
    user.height = self.app.userInfomation.height;
    user.weight = self.app.userInfomation.weight;
    //[_appDelegate saveContext];
    
}

- (void) saveSetting:(NSManagedObjectContext*)context{

    Setting* setting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
    setting.unitHeight = self.app.unitSetting.unitHeight;
    setting.unitWeight = self.app.unitSetting.unitWeight;
    //[_appDelegate saveContext];

}

- (void) saveWeight:(NSManagedObjectContext*)context{
    //save user input weight as a first element in weight as well with current date
    
    Weight* weight = [NSEntityDescription insertNewObjectForEntityForName:@"Weight" inManagedObjectContext:context];
    weight.weight = self.app.userInfomation.weight;

    /*
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate *now = [[NSDate alloc] init];
    NSString *nowString = [dateFormat stringFromDate:now];
    NSDate *date = [dateFormat dateFromString:nowString];
    */
    
    //to save only dates
    NSDate *date = [self dateWithOutTime:[NSDate date]];
    //NSLog(@"%@", date);
    
    weight.datetime = date;
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

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
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

- (NSMutableArray*) makeArr:(int)si to:(int)ei{
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (int i=si; i<=ei; i++){
        [tmpArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return tmpArr;
}
@end
