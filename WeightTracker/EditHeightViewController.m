//
//  EditHeightViewController.m
//  BodyTracker
//
//  Created by MInju on 28/09/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "EditHeightViewController.h"
#import "User+CoreDataClass.h"

@interface EditHeightViewController ()

@end

@implementation EditHeightViewController
@synthesize pickerCm, pickerInches, pickerCmArr, pickerInchesArr, heightString;

- (void)viewDidLoad {
    [super viewDidLoad];

    pickerCm.tag = 1;
    pickerInches.tag = 2;
    
    pickerCmArr = [[NSMutableArray alloc] init];
    [pickerCmArr addObject:[self makeArr:1 to:2]];
    [pickerCmArr addObject:[self makeArr:0 to:9]];
    [pickerCmArr addObject:[self makeArr:0 to:9]];
    [pickerCmArr addObject:@[@"cm"]];
    
    pickerInchesArr = [[NSMutableArray alloc] init];
    [pickerInchesArr addObject:[self makeArr:1 to:9]];
    [pickerInchesArr addObject:@[@"foot"]];
    [pickerInchesArr addObject:[self makeArr:0 to:11]];
    [pickerInchesArr addObject:@[@"inches"]];
    
    pickerCm.dataSource = self;
    pickerCm.delegate = self;
    pickerInches.dataSource = self;
    pickerInches.delegate = self;
    
    heightString = self.app.userInfomation.height;
    
    if ((int)self.app.unitSetting.unitHeight == 0) { //cm
        pickerCm.hidden = NO;
        pickerInches.hidden = YES;
        
        for (int i = 0; i < [heightString length]; i++) {
            NSString *ch = [heightString substringWithRange:NSMakeRange(i, 1)];
            if(i==0) //firstrow starts from 1 it nees to be minus 1 to match with valude
                [pickerCm selectRow:[ch intValue]-1 inComponent:i animated:YES];
            else
                [pickerCm selectRow:[ch intValue] inComponent:i animated:YES];
        }
    } else { //inches
        pickerCm.hidden = YES;
        pickerInches.hidden = NO;
        NSArray *tempArray = [heightString componentsSeparatedByString:@"\""];

        for (int i = 0; i<[tempArray count]; i++){
            NSString *tempString = [tempArray objectAtIndex:i];
            if (i == 0){
                [pickerInches selectRow:[tempString intValue]-1 inComponent:i animated:YES];
            } else {
                [pickerInches selectRow:[tempString intValue] inComponent:2 animated:YES];
            }
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

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(pickerView.tag == 1){
        return [pickerCmArr count];
    } else {
        return [pickerInchesArr count];
    }
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView.tag == 1){
        return [[pickerCmArr objectAtIndex:component] count];
    } else {
        return [[pickerInchesArr objectAtIndex:component] count];
    }
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView.tag == 1){
        return [[pickerCmArr objectAtIndex:component] objectAtIndex:row];
    } else {
        return [[pickerInchesArr objectAtIndex:component] objectAtIndex:row];
    }
}

- (IBAction)updateHeight:(id)sender {
    
    if ((int)self.app.unitSetting.unitHeight == 0) { //cm
        
        for(int i=0; i<3; i++){
            if(i==0){
                heightString = [[pickerCmArr objectAtIndex:i] objectAtIndex:[pickerCm selectedRowInComponent:i]];
            } else {
                heightString = [heightString stringByAppendingString: [[pickerCmArr objectAtIndex:i] objectAtIndex:[pickerCm selectedRowInComponent:i]]];
            }
        }
    } else {
        heightString = [[pickerInchesArr objectAtIndex:0] objectAtIndex:[pickerInches selectedRowInComponent:0]];
        heightString = [heightString stringByAppendingString:@"\""];
        heightString = [heightString stringByAppendingString: [[pickerInchesArr objectAtIndex:2] objectAtIndex:[pickerInches selectedRowInComponent:2]]];
    }
    
    //update appdelegate
    [[self app].userInfomation setHeight:heightString];
    
    //update coredata
    NSManagedObjectContext *context = [self managedObjectContext];
    User *user = [self getUser:context];
    user.height = heightString;
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray*) makeArr:(int)si to:(int)ei{
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (int i=si; i<=ei; i++){
        [tmpArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return tmpArr;
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
