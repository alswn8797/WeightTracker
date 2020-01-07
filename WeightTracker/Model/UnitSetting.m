//
//  UnitSetting.m
//  BodyTracker
//
//  Created by MInju on 15/9/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "UnitSetting.h"

@implementation UnitSetting

@synthesize heightString, weightString;

-(NSString*) changeHeightUnitTo:(int)unit withHeight:(NSString*)heightString{

    // Formula
    // cm  x  0.39* = in
    // in / 12 = ft
    // in  x  2.54 = cm
    
    // Ex)
    // 160 cm · 0.3937008 = 63"
    // 63" ÷ 12 = 5' remainder 3"
    // or 5' 3"
    
    if(unit == 0){ //change inches to cm
        //The value saves as foot"inches split text and foot needs to be muliply by 12 to get inches
        int inches = 0;
        double height = 0.0;
        
        NSArray *tempArray = [heightString componentsSeparatedByString:@"\""];
        //NSLog(@"%@",tempArray);
        
        for (int i = 0; i<[tempArray count]; i++){
            NSString *tempString = [tempArray objectAtIndex:i];
            if (i == 0){
                inches += [tempString intValue]*12;
            } else {
                inches += [tempString intValue];
            }
        }
        
        //NSLog(@"%d", inches);
        height = inches * 2.54;
        heightString = [NSString stringWithFormat:@"%.0lf",height];
        
    } else { //change cm to inches
        double height = [heightString doubleValue];
        height = height * 0.3937008;
        int foot = height / 12;
        //when I change data type to integer then 8.9 became 8 so use fmod and ues string with format to round the value
        double inches = fmod(height, 12);
        
        //if inches is greater than 11.5, it will be rounded as 12
        if(inches > 11.5){
            inches = 0.0;
            foot += 1;
        }
        //inches can be 10 or 11 so better store value less than 10 with 0 in front of actual value to convert to Cm

        //NSLog(@"%d and %f", foot, inches);
        
        heightString = [[NSNumber numberWithInt:foot] stringValue];
        heightString = [heightString stringByAppendingString: @"\""];
        heightString = [heightString stringByAppendingString:[NSString stringWithFormat:@"%.0lf",inches]];

        //NSLog(@"%@", heightString);
    }
        
    return heightString;
}

-(double) changeWeightUnitTo:(int)unit withWeight:(double)weight{
    
    // Formula
    
    // 1 kg = 2.20462262185 lb
    // m(lb) = m(kg) / 0.45359237
    
    // 1 lb = 0.45359237 kg
    // m(kg) = m(lb) × 0.45359237
    
    if(unit == 0){ //change lbs to kg
        weight *= 0.45359237;
    } else { //change kg to lbs
        weight /= 0.45359237;
    }

    return weight;
}

@end
