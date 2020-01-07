//
//  BMIViewController.m
//  BodyTracker
//
//  Created by MInju on 10/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "BMIViewController.h"

@interface BMIViewController ()

@end

@implementation BMIViewController

@synthesize  bmiCounterView, bmiLabel, bmiStateLabel, idealWeightLabel, bmiString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    //NSLog(@"%@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    //set background image for counterView
    UIGraphicsBeginImageContext(self.bmiCounterView.frame.size);
    [[UIImage imageNamed:@"bmi-background.png"] drawInRect:self.bmiCounterView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.bmiCounterView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    bmiString = [self calculateBMI];
    [self calculateIdealWeight];
    
    double bmi = [bmiString doubleValue];
    
    if(bmi < 18.5){
        self.bmiCounterView.part = 1;
        [bmiStateLabel setText: @"UnderWeight"];
    } else if (bmi >= 18.5 &&  bmi < 25) {
        self.bmiCounterView.part = 2;
        [bmiStateLabel setText: @"Healthy Weight"];
    } else if (bmi >= 25 && bmi < 30) {
        self.bmiCounterView.part = 4;
        [bmiStateLabel setText: @"OverWeight"];
    } else if (bmi >= 30 && bmi < 35) {
        self.bmiCounterView.part = 5;
        [bmiStateLabel setText: @"Obese"];
    } else if (bmi >= 35 && bmi < 40) {
        self.bmiCounterView.part = 6;
        [bmiStateLabel setText: @"Severely Obese"];
    } else if (bmi >= 40) {
        self.bmiCounterView.part = 7;
        [bmiStateLabel setText: @"Morbidly Obese"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//get sharedApplication to shorten code
- (AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

- (double) getHeightInMeter {
    double height = 0.0;
    if(self.app.unitSetting.unitHeight == 1){ // unitHeight is Feet and inches
        //convert height and divide by 100 to make cm to m
        height = [[self.app.unitSetting changeHeightUnitTo:0 withHeight:self.app.userInfomation.height] doubleValue] / 100;
    } else { // unitHeight is cm
        height = [self.app.userInfomation.height doubleValue] / 100;
    }
    return height;
}

- (double) getWeightInKg {
    double weight = 0.0;
    
    if(self.app.unitSetting.unitWeight == 1){ // unitWeight is lbs then convert weight
        weight = [self.app.unitSetting changeWeightUnitTo:0 withWeight:self.app.userInfomation.weight];
    } else { // unitWeight is kg
        weight = self.app.userInfomation.weight;
    }
    return weight;
}

- (NSString*) calculateBMI{
    double bmi = 0.0;
    
    //TODO handle LBS
    
    //bmi = devide weight in kg by height in m to the power of 2
    bmi = self.getWeightInKg / ( self.getHeightInMeter * self.getHeightInMeter );
    NSString *bmiString = [NSString stringWithFormat:@"%.1lf", bmi];
    [bmiLabel setText: bmiString];
    
    return bmiString;
}

- (void)calculateIdealWeight{
    double sWeight = 0.0;
    double eWeight = 0.0;
    //ideal weight could be bmi 18.5 to 24.9
    sWeight = 18.5 * ( self.getHeightInMeter * self.getHeightInMeter );
    eWeight = 24.9 * ( self.getHeightInMeter * self.getHeightInMeter );
    
    NSString *idealWeightString;
    
    if(self.app.unitSetting.unitWeight == 1){ // unitWeight is lbs
        //convert kg to lbs to show
        
        idealWeightString = [NSString stringWithFormat:@"%.0lf ~ %.0lf lbs", [self.app.unitSetting changeWeightUnitTo:1 withWeight:sWeight], [self.app.unitSetting changeWeightUnitTo:1 withWeight:eWeight]];
    } else {
        idealWeightString = [NSString stringWithFormat:@"%.1lf ~ %.1lf kg", sWeight, eWeight];
    }
    //TODO handle LBS
    [idealWeightLabel setText: idealWeightString];
}

@end
