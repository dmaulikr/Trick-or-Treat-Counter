//
//  MapViewController.m
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 12/9/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) NSMutableArray *years;

@property (nonatomic) NSMutableArray *annotations;

typedef void (^myCompletion)(BOOL finished);

@end

@implementation MapViewController

- (void)viewDidLoad {
    
    self.mapView.delegate = self;
    
    CoreDataFunctions* coredataObject = [[CoreDataFunctions alloc] init];
    User *currentUser = [coredataObject performFetch];
    
    NSSet *yearsSet = [currentUser valueForKey:@"years"];
    
    _years = [[NSMutableArray alloc] init];

    _annotations = [[NSMutableArray alloc]init];
    
    [self addAnnotations:^(BOOL finished) {
        
        if(finished){
            
            [self.mapView addAnnotations:_annotations];
        }
    }];
    
}

-(void) addAnnotations:(myCompletion) completionBlock{
    
    CloudkitDataFunctions* cloudkitObject = [[CloudkitDataFunctions alloc] init];
    
    [cloudkitObject returnMapViewRecords:@"2016" completion: ^(NSArray* results) {
        
        for (CKRecord *i in results) {
            
            CLLocation *location = [i objectForKey:@"location"];
            
            CLLocationCoordinate2D pinCoordinate;
            pinCoordinate.latitude = location.coordinate.latitude;
            pinCoordinate.longitude = location.coordinate.longitude;
            
            
            MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
            
            myAnnotation.coordinate = pinCoordinate;
            myAnnotation.subtitle = [NSString stringWithFormat:@"%@", [i objectForKey:@"visitors"]];
                                
            [_annotations addObject:myAnnotation];
            
        }
        
        completionBlock(YES);
    
    }];
    
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    double zoomWidth = mapView.visibleMapRect.size.width;
    int zoomFactor = (int)log2(zoomWidth);
    
    //populate at a zoom factor of about 17
    
}


-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    
        NSString *defaultPinID = @"pin";
    
        MKAnnotationView *pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    
        pinView.enabled = true;
        [pinView setFrame:CGRectMake(0, 0, 30, 30)];
        pinView.layer.borderWidth = 1.0;
        pinView.layer.masksToBounds = false;
        pinView.layer.borderColor = [UIColor whiteColor].CGColor;
        pinView.layer.cornerRadius = pinView.frame.size.width / 2;
        pinView.backgroundColor = [UIColor orangeColor];
        pinView.canShowCallout = YES;
    
        UILabel *visitorsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        visitorsLabel.text = annotation.subtitle;
    
        [visitorsLabel setAdjustsFontSizeToFitWidth:true];
    
        [pinView addSubview:visitorsLabel];
        
    
    return pinView;
}

@end
