//
//  CloudkitDataFunctions.h
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 12/7/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cloudkit/Cloudkit.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import "Year+CoreDataClass.h"
#import "Year+CoreDataProperties.h"
#import "User+CoreDataClass.h"
#import "User+CoreDataProperties.h"



@interface CloudkitDataFunctions : NSObject

@property (nonatomic) CKDatabase *publicDB;
@property (nonatomic) CKRecord* mapYears;

-(instancetype)init;
-(CKRecord*)manageMapViewRecords:(Year*)manipulatedYear;
-(void)savemapViewRecords:(Year*)manipulatedYear;
-(void)createNewUser:(NSString*)firstName lastName:(NSString*)lastName userName:(NSString*)userName password:(NSString*)password streetAddress:(NSString*)streetAddress city:(NSString*)city zipcode:(NSString*)zipcode;
-(void)login: (NSString*)userName password:(NSString*)password completion:(void (^)(CKRecord* record))completionBlock;
                      

@end
