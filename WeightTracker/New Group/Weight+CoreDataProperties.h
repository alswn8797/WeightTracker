//
//  Weight+CoreDataProperties.h
//  BodyTracker
//
//  Created by MInju on 9/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//
//

#import "Weight+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Weight (CoreDataProperties)

+ (NSFetchRequest<Weight *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *datetime;
@property (nonatomic) double weight;

@end

NS_ASSUME_NONNULL_END
