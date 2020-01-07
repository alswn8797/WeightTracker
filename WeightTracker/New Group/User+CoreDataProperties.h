//
//  User+CoreDataProperties.h
//  BodyTracker
//
//  Created by MInju on 9/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nonatomic) int16_t gender;
@property (nonatomic) NSString *height;
@property (nonatomic) double weight;

@end

NS_ASSUME_NONNULL_END
