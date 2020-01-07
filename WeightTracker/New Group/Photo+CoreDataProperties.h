//
//  Photo+CoreDataProperties.h
//  BodyTracker
//
//  Created by MInju on 9/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//
//

#import "Photo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *datetime;
@property (nullable, nonatomic, copy) NSString *photo;

@end

NS_ASSUME_NONNULL_END
