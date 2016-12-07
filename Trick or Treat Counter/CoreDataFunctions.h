//
//  CoreDataFunctions.h
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 12/7/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Cloudkit/Cloudkit.h>
#import "Year+CoreDataClass.h"
#import "Year+CoreDataProperties.h"
#import "User+CoreDataClass.h"
#import "User+CoreDataProperties.h"
#import "AppDelegate.h"


@interface CoreDataFunctions : NSObject

@property (nonatomic) AppDelegate *appDelegate;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSFetchRequest *fetchRequest;

-(instancetype)init;

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;

-(Year*)newYear:(NSMutableArray*)yearsArray forUser:(User*)currentUser;
-(void)createnewUser:(CKRecord*)userRecord userName:(NSString*)userName;
-(User*)performFetch;
-(void)save;

@end
