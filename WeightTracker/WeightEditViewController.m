//
//  WeightEditViewController.m
//  BodyTracker
//
//  Created by MInju on 13/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "WeightEditViewController.h"
#import "User+CoreDataClass.h"

@interface WeightEditViewController ()

@end

@implementation WeightEditViewController

@synthesize pickerDate, pickerKg, pickerLbs, pickerKgArr, pickerLbsArr, weightString;

- (void)setContext:(NSManagedObjectContext *)context{
    if (_context == nil) {
        _context = context;
    }
}

- (void)setWeight:(Weight *)weight{
    if(_weight != weight){
        _weight = weight;
    }
    [self configureView];
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.weight) {
        [pickerDate setDate:self.weight.datetime];
        
        NSString *weightString;

        if ((int)self.app.unitSetting.unitHeight == 0) { //kg
            pickerKg.hidden = NO;
            pickerLbs.hidden = YES;
            
            if(self.weight.weight < 100){
                weightString = [NSString stringWithFormat:@"0%.1lf", self.weight.weight];
                if(self.weight.weight < 10)
                    weightString = [NSString stringWithFormat:@"0%@", weightString];
            } else {
                weightString = [NSString stringWithFormat:@"%.1lf", self.weight.weight];
            }
            
            NSArray *tempArray = [weightString componentsSeparatedByString:@"."];
            
            for (int i = 0; i < [tempArray[0] length]; i++) {
                NSString *ch = [tempArray[0] substringWithRange:NSMakeRange(i, 1)];
                [pickerKg selectRow:[ch intValue] inComponent:i animated:YES];
            }
            
            [pickerKg selectRow:[tempArray[1] intValue] inComponent:4 animated:YES];
            
        } else { //lbs
            pickerKg.hidden = YES;
            pickerLbs.hidden = NO;
            
            if(self.weight.weight < 100){
                weightString = [NSString stringWithFormat:@"0%.0lf", self.weight.weight];
                if(self.weight.weight < 10)
                    weightString = [NSString stringWithFormat:@"0%@", weightString];
            } else {
                weightString = [NSString stringWithFormat:@"%.0lf", self.weight.weight];
            }
            
            for (int i = 0; i < [weightString length]; i++) {
                NSString *ch = [weightString substringWithRange:NSMakeRange(i, 1)];
                [pickerLbs selectRow:[ch intValue] inComponent:i animated:YES];
            }
        }
    }
}

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
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateWeight:(id)sender {
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
    
    if ([pickerDate date] != self.weight.datetime){
    
        //check if coredata has an input with same date
        if([self checkExist:_context withDate:[pickerDate date]]){
            
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
            [self saveWeight:inputWeight];
        }
    } else {
        [self saveWeight:inputWeight];
    }
}

- (void) saveWeight:(double)inputWeight {
    self.weight.weight = inputWeight;
    self.weight.datetime = [self dateWithOutTime:[pickerDate date]];
    
    //update weight in coredata
    NSError *error = nil;
    if (![_context save:&error]) {
        NSLog(@"Can't Update Weight! %@ %@", error, [error localizedDescription]);
    }
    
    //check recent weight and update user and appdelegate userinformation
    User *user = [self getUser:_context];
    Weight *recentWeight = [self getRecentWeight:_context];
    
    user.weight = recentWeight.weight;
    self.app.userInfomation.weight = recentWeight.weight;
    
    if (![_context save:&error]) {
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

- (NSString*) getFormattedDateString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

@end
