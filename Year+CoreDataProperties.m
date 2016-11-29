//
//  Year+CoreDataProperties.m
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 11/29/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "Year+CoreDataProperties.h"

@implementation Year (CoreDataProperties)

+ (NSFetchRequest<Year *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Year"];
}

@dynamic address;
@dynamic candy;
@dynamic money;
@dynamic visitors;
@dynamic year;

@end
