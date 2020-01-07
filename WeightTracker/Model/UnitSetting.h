//
//  UnitSetting.h
//  BodyTracker
//
//  Created by MInju on 15/9/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitSetting : NSObject

@property(nonatomic, assign) int unitHeight;
@property(nonatomic, assign) int unitWeight;

@property (strong, nonatomic) NSString *heightString;
@property (strong, nonatomic) NSString *weightString;

-(NSString*) changeHeightUnitTo:(int)unit withHeight:(NSString*)heightString;
-(double) changeWeightUnitTo:(int)unit withWeight:(double)weightString;

@end
