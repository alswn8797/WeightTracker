//
//  EditUserInfoViewController.m
//  BodyTracker
//
//  Created by MInju on 27/09/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "User+CoreDataClass.h"

@interface EditUserInfoViewController ()

@end

@implementation EditUserInfoViewController

@synthesize segGender, pickerAge, pickerAgeArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    pickerAgeArr = [[NSMutableArray alloc] init];
    for (int i=1; i<=100; i++){
        [pickerAgeArr addObject:[NSString stringWithFormat:@"%d",i]];
        if(self.app.userInfomation.age == i){
            [pickerAge selectRow:i inComponent:0 animated:YES];
        }
    }
    pickerAge.dataSource = self;
    pickerAge.delegate = self;
    
    //set selected segment based on user gender
    [segGender setSelectedSegmentIndex:self.app.userInfomation.gender];
    
    //set selectected row in pickerview based on user age
    [pickerAge selectRow:self.app.userInfomation.age-1 inComponent:0 animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerAgeArr count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerAgeArr objectAtIndex:row];
}


- (IBAction)updateUserInfo:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    User *user = [self getUser:context];
    
    NSInteger selectedRow = [pickerAge selectedRowInComponent:0];
    NSString *selectedResult = [pickerAgeArr objectAtIndex:selectedRow];
    
    //update appdelegate
    [self.app.userInfomation setAge: [selectedResult intValue]];
    [self.app.userInfomation setGender:(int)segGender.selectedSegmentIndex];
    
    //update coredata
    user.age = [selectedResult intValue];
    user.gender = (int)segGender.selectedSegmentIndex;
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
