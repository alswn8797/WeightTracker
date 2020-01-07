//
//  UserInfoViewController.m
//  BodyTracker
//
//  Created by MInju on 6/9/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "UserInfoViewController.h"


@interface UserInfoViewController ()
@end

@implementation UserInfoViewController

@synthesize segGender, pickerAge, pickerAgeArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pickerAgeArr = [[NSMutableArray alloc] init];
    for (int i=1; i<=100; i++){
        [pickerAgeArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    pickerAge.dataSource = self;
    pickerAge.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerAgeArr count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerAgeArr objectAtIndex:row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)inputGenderAge:(id)sender {
    //get selected result
    NSInteger selectedRow = [pickerAge selectedRowInComponent:0];
    NSString *selectedResult = [pickerAgeArr objectAtIndex:selectedRow];
    
    [self.app.userInfomation setAge: [selectedResult intValue]];
    [self.app.userInfomation setGender:(int)segGender.selectedSegmentIndex];
}

-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}
@end
