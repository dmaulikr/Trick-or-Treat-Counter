//
//  Year+CoreDataProperties.h
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 11/29/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "Year+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Year (CoreDataProperties)

+ (NSFetchRequest<Year *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nonatomic) int16_t candy;
@property (nonatomic) int16_t money;
@property (nonatomic) int16_t visitors;
@property (nullable, nonatomic, copy) NSString *year;

@end

NS_ASSUME_NONNULL_END
