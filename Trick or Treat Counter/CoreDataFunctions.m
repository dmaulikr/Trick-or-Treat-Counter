//
//  CoreDataFunctions.m
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 12/7/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "CoreDataFunctions.h"



@implementation CoreDataFunctions



-(instancetype)init{
    
    if(self){
        
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

-(void)save{
    
    [_appDelegate saveContext];
}

-(User*)performFetch {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@", [defaults objectForKey:@"username"]];
    _fetchRequest.predicate = predicate;
    _fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    NSArray *userArray = [[_appDelegate.persistentContainer.viewContext executeFetchRequest: self.fetchRequest error:nil] mutableCopy];
    
     return [userArray objectAtIndex:0];
}


-(void)createnewUser:(CKRecord*)userRecord userName:(NSString*)userName {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@", userName];
    
    fetchRequest.predicate = predicate;
    
    NSArray *userArray = [[_appDelegate.persistentContainer.viewContext executeFetchRequest: fetchRequest error:nil] mutableCopy];
    
    if (userArray.count == 0) {
        
        NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:_appDelegate.persistentContainer.viewContext];
        
        [newUser setValue: userName forKey:@"username"];
        [newUser setValue: userRecord forKey:@"ckRecord"];
        [newUser setValue:[userRecord objectForKey:@"streetAddress"] forKey:@"streetAddress"];
        [newUser setValue:[userRecord objectForKey:@"city"] forKey:@"city"];
        [newUser setValue:[userRecord objectForKey:@"state"] forKey:@"state"];
        [newUser setValue:[userRecord objectForKey:@"zipcode"] forKey:@"zipcode"];
        
        [_appDelegate saveContext];

    }
}

-(Year*)newYear:(NSMutableArray*)yearsArray forUser:(User*)currentUser {
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    if (yearsArray.count !=  0) {
        
        Year *lastYearObject = [yearsArray objectAtIndex: yearsArray.count - 1];
        
        NSString *lastYearString = lastYearObject.year;
        
        int nextyearInteger = [stringFromDate integerValue] + 1;
        
        stringFromDate = [NSString stringWithFormat:@"%hd", nextyearInteger];
    }
    
    Year *newYear = [NSEntityDescription insertNewObjectForEntityForName:@"Year" inManagedObjectContext:_appDelegate.persistentContainer.viewContext];
    
    [newYear setValue:stringFromDate forKey:@"year"];
    [newYear setValue: [NSString stringWithFormat:@"%@,%@,%@,%@", currentUser.streetAddress, currentUser.city, currentUser.state, currentUser.zipcode] forKey:@"address"];
    [newYear setValue:currentUser forKey:@"users"];
    
    NSMutableSet *newYearSet = [currentUser valueForKey:@"years"];
    
    [newYearSet addObject:newYear];
    
    [currentUser setValue:newYearSet forKey:@"years"];
    
    [[NSUserDefaults standardUserDefaults] setObject:stringFromDate forKey:@"manipulatedYear"];
    
    [_appDelegate saveContext];
    
    
    return newYear;
    
}

@end
