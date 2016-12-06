//
//  User+CoreDataProperties.m
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 12/6/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic ckRecord;
@dynamic username;
@dynamic streetAddress;
@dynamic city;
@dynamic state;
@dynamic zipcode;
@dynamic years;

@end
