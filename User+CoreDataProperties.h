//
//  User+CoreDataProperties.h
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 12/3/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, retain) NSObject *ckRecord;
@property (nullable, nonatomic, retain) NSSet<Year *> *years;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addYearsObject:(Year *)value;
- (void)removeYearsObject:(Year *)value;
- (void)addYears:(NSSet<Year *> *)values;
- (void)removeYears:(NSSet<Year *> *)values;

@end

NS_ASSUME_NONNULL_END
