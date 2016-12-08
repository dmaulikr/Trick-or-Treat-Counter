//
//  LineGraphView.h
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 12/8/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataFunctions.h"
#import "Year+CoreDataClass.h"
#import "Year+CoreDataProperties.h"
#import "User+CoreDataClass.h"
#import "User+CoreDataProperties.h"

@interface LineGraphView : UIView

@property (nonatomic) NSMutableArray *graphPoints;
@property (nonatomic) NSMutableArray *years;

@end
