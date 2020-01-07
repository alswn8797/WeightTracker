//
//  HeightViewController.m
//  BodyTracker
//
//  Created by MInju on 13/9/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "HeightViewController.h"

@interface HeightViewController ()

@end

@implementation HeightViewController
@synthesize segHeightUnit, pickerCm, pickerInches, pickerCmArr, pickerInchesArr, heightString;

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
    
    //hide inches because first segment will be chosen its first object //cm
    pickerCm.hidden = NO;
    pickerInches.hidden = YES;
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

//get sharedApplication to shorten code
-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

- (IBAction)changeUnit:(id)sender {
    if (segHeightUnit.selectedSegmentIndex == 0) { //cm
        pickerCm.hidden = NO;
        pickerInches.hidden = YES;
    } else { //inches
        pickerCm.hidden = YES;
        pickerInches.hidden = NO;
    }
}

- (IBAction)inputHeight:(id)sender {
    if (segHeightUnit.selectedSegmentIndex == 0) { //cm
        
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
    
    [[self app].userInfomation setHeight:heightString];
    
    int heightUnit = (int)segHeightUnit.selectedSegmentIndex;
    [self.app.unitSetting setUnitHeight:heightUnit];
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

- (NSMutableArray*) makeArr:(int)si to:(int)ei{
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (int i=si; i<=ei; i++){
        [tmpArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return tmpArr;
}

@end
