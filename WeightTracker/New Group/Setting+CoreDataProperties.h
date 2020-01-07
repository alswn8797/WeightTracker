//
//  Setting+CoreDataProperties.h
//  BodyTracker
//
//  Created by MInju on 9/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//
//

#import "Setting+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Setting (CoreDataProperties)

+ (NSFetchRequest<Setting *> *)fetchRequest;

@property (nonatomic) int16_t unitHeight;
@property (nonatomic) int16_t unitWeight;

@end

NS_ASSUME_NONNULL_END
