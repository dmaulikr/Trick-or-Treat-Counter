//
//  CloudkitDataFunctions.m
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 12/7/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "CloudkitDataFunctions.h"

@implementation CloudkitDataFunctions

-(instancetype)init{
    
    if(self){
        
        _publicDB = [[CKContainer defaultContainer] publicCloudDatabase];
    }
    
    return self;
}


-(void)login: (NSString*)userName password:(NSString*)password completion:(void (^)(CKRecord* record))completionBlock {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@", userName];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"password = %@", password];
    
    NSPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate, predicate2]];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"newUser" predicate:andPredicate];
    
    [_publicDB performQuery:query
              inZoneWithID:nil
         completionHandler:^(NSArray *results, NSError *error) {
             
             completionBlock([results objectAtIndex:0]);
             
         }];
    
}

-(void)savemapViewRecords:(Year*)manipulatedYear {
    
    
    [_mapYears setObject: @(manipulatedYear.visitors) forKey:@"visitors"];
    
    [_publicDB saveRecord: _mapYears completionHandler:^(CKRecord *savedPlace, NSError *error) {
        
        
    }];

}

-(void)createNewUser:(NSString*)firstName lastName:(NSString*)lastName userName:(NSString*)userName password:(NSString*)password streetAddress:(NSString*)streetAddress city:(NSString*)city zipcode:(NSString*)zipcode {
    
    
    CKRecordID *user = [[CKRecordID alloc] initWithRecordName:@"User"];
    
    CKRecord *newUser = [[CKRecord alloc] initWithRecordType:@"newUser" recordID:user];
    
    newUser[@"firstName"] = [NSString stringWithFormat:@"%@", firstName];
    newUser[@"lastName"] = [NSString stringWithFormat:@"%@", lastName];
    
    newUser[@"userName"] = [NSString stringWithFormat:@"%@", userName];
    
    newUser[@"password"] = [NSString stringWithFormat:@"%@", password];
    
    newUser[@"streetAddress"] = [NSString stringWithFormat:@"%@", streetAddress];
    
    newUser[@"city"] = [NSString stringWithFormat:@"%@", city];
    
    newUser[@"zipcode"] = [NSString stringWithFormat:@"%@", zipcode];
    
    [_publicDB saveRecord:newUser completionHandler:^(CKRecord *savedPlace, NSError *error) {
        
        
        
    }];

    
}

-(void)manageMapViewRecords:(Year*)manipulatedYear {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString: manipulatedYear.address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
        
        CLLocation *myLocation = [[CLLocation alloc] initWithLatitude: myPlacemark.location.coordinate.latitude longitude:myPlacemark.location.coordinate.longitude];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year = %@", manipulatedYear.year];
        
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"location = %@", myLocation];
        
        NSPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate, predicate2]];
        
        CKQuery *query = [[CKQuery alloc] initWithRecordType:@"mapLocations" predicate:andPredicate];
        
        [_publicDB performQuery:query
                   inZoneWithID:nil
              completionHandler:^(NSArray *results, NSError *error) {
                  
                  if (results.count != 0) {
                      
                      CKRecord *mapYear = [results objectAtIndex:0];
                      
                      _mapYears = mapYear;
                      
                  } else {
                      
                      CKRecordID *mapUser = [[CKRecordID alloc] initWithRecordName:@"MapUser"];
                      
                      CKRecord *mapYear = [[CKRecord alloc] initWithRecordType:@"mapLocations" recordID:mapUser];
                      
                      mapYear[@"location"] = myLocation;
                      mapYear[@"visitors"] = @1;
                      mapYear[@"year"] = manipulatedYear.year;
                      
                      
                      [_publicDB saveRecord:mapYear completionHandler:^(CKRecord *savedPlace, NSError *error) {
                          
                          _mapYears = mapYear;
                          
                      }];
                      
                      
                  }
                  
              }];
        
    }];
    
    
}

@end
