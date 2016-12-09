//
//  MapViewController.h
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 12/9/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
#import <CoreData/CoreData.h>
#import <Cloudkit/Cloudkit.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import "CoreDataFunctions.h"
#import "CloudkitDataFunctions.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@end
