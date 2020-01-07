//
//  Weight+CoreDataProperties.m
//  BodyTracker
//
//  Created by MInju on 9/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//
//

#import "Weight+CoreDataProperties.h"

@implementation Weight (CoreDataProperties)

+ (NSFetchRequest<Weight *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Weight"];
}

@dynamic datetime;
@dynamic weight;

@end
