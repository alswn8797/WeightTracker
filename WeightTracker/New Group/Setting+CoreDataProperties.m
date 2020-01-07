//
//  Setting+CoreDataProperties.m
//  BodyTracker
//
//  Created by MInju on 9/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//
//

#import "Setting+CoreDataProperties.h"

@implementation Setting (CoreDataProperties)

+ (NSFetchRequest<Setting *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Setting"];
}

@dynamic unitHeight;
@dynamic unitWeight;

@end
