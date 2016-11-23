//
//  Year+CoreDataProperties.m
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 11/23/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "Year+CoreDataProperties.h"

@implementation Year (CoreDataProperties)

+ (NSFetchRequest<Year *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Year"];
}

@dynamic year;
@dynamic visitors;
@dynamic address;
@dynamic candy;
@dynamic money;

@end
