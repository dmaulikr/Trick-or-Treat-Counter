//
//  ViewController.m
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 11/21/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "CounterViewController.h"
#import "CounterButton.h"
#import "AppDelegate.h"
#import "Year+CoreDataClass.h"
#import "Year+CoreDataProperties.h"
#import "User+CoreDataClass.h"
#import "User+CoreDataProperties.h"


@interface CounterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (nonatomic) int counter;
@property (nonatomic) UIVisualEffectView *blurEffectView;
@property (nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *yearButton;
@property (nonatomic) CKDatabase *publicDB;

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSFetchRequest *fetchRequest;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSMutableArray *loggedYears;
@property (nonatomic) Year *manipulatedYear;
@property (nonatomic) User *currentUser;
@property (nonatomic) CKRecord* mapYears;

@end

@implementation CounterViewController

- (IBAction)yearButtonPushed:(id)sender {
    
    NSDate *date = [NSDate date];
        
    Year *lastYearObject = [_loggedYears objectAtIndex: _loggedYears.count - 1];
    
    NSString *lastYearString = lastYearObject.year;
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *halloweenDate = [formatter dateFromString: [NSString stringWithFormat: @"%@-10-31", lastYearString]];
    
    if ([date compare: halloweenDate] == NSOrderedDescending) {
        
        [formatter setDateFormat:@"YYYY"];
        
        NSString *currentYearString = [formatter stringFromDate: date];
        
        int nextyearInteger = [currentYearString integerValue] + 1;
        
        NSString *nextYear = [NSString stringWithFormat: @"%i", nextyearInteger];
        
        NSManagedObject *newYear = [NSEntityDescription insertNewObjectForEntityForName:@"Year" inManagedObjectContext:self.managedObjectContext];
        [newYear setValue:nextYear forKey:@"year"];
        [newYear setValue: @0 forKey:@"visitors"];
        
        NSMutableSet *newYearSet = [_currentUser mutableSetValueForKey:@"years"];
        [newYearSet addObject:newYear];
        
        [_currentUser setValue:newYearSet forKey:@"years"];
        
        [_appDelegate saveContext];
        
        [_loggedYears addObject:newYear];
        
        
        
    }
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
            
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _blurEffectView.frame = self.view.bounds;
        _blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
        [self.view addSubview:_blurEffectView];
            
        UIPickerView *yearPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.center.x - 200, self.view.frame.origin.y, 400, 400)];
        yearPickerView.delegate = self;
        yearPickerView.dataSource = self;
        [_blurEffectView addSubview:yearPickerView];
            
        UIButton *yearPicker = [UIButton buttonWithType:UIButtonTypeCustom];
        [yearPicker addTarget:self
                        action:@selector(yearPicked)
                forControlEvents:UIControlEventTouchUpInside];
        [yearPicker setTitle:@"Pick Year" forState:UIControlStateNormal];
        yearPicker.frame = CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height / 2, 100, 100);
        yearPicker.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [yearPicker setBackgroundColor: [UIColor orangeColor]];
        [_blurEffectView addSubview:yearPicker];
            
            
        } else {
           // self.view.backgroundColor = [UIColor blackColor];
        }

}

-(void)yearPicked {
    
    [self.blurEffectView removeFromSuperview];
    
}

- (IBAction)addButtonPushed:(CounterButton *)sender {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        self.counter ++;
        
        self.counterLabel.text = [NSString stringWithFormat:@"%d",self.counter];
        
        [_manipulatedYear setValue: @(_counter) forKey:@"visitors"];
        [_appDelegate saveContext];
        
        

        
        
    });
    
    sender.currentAngle = 1;
    sender.buttonPushed = true;
    [sender setNeedsDisplay];
    
    UIImage *ghost = [UIImage imageNamed:@"ghost"];
    
    UIImageView *ghostImageView = [[UIImageView alloc] initWithFrame: CGRectMake(-35, self.counterLabel.frame.origin.y - 10 , 50, 50)];
    ghostImageView.image = ghost;
    
    [self.view addSubview:ghostImageView];
    
    [UIView animateWithDuration:2.2 animations:^ {
        
        [ghostImageView setFrame:CGRectMake(self.view.frame.size.width + 35, self.counterLabel.frame.origin.y - 10, 50, 50)];
    
    }completion:^(BOOL finished) {
        
        [ghostImageView removeFromSuperview];
        
    }];
    
}

- (IBAction)subtractButtonPushed:(CounterButton *)sender {
    
    sender.currentAngle = 1;
    sender.buttonPushed = true;
    [sender setNeedsDisplay];
    
    if (_counter > 0) {
        self.counter -- ;
        self.counterLabel.text = [NSString stringWithFormat:@"%d", self.counter];
        [_manipulatedYear setValue: @(_counter) forKey:@"visitors"];
        [_appDelegate saveContext];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [_mapYears setObject: @(_counter) forKey:@"visitors"];
    
    [_publicDB saveRecord: _mapYears completionHandler:^(CKRecord *savedPlace, NSError *error) {
        
        
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:true];
    
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: [UIColor orangeColor].CGColor, [UIColor whiteColor].CGColor, [UIColor orangeColor].CGColor, [UIColor whiteColor].CGColor, [UIColor orangeColor].CGColor, [UIColor whiteColor].CGColor, [UIColor orangeColor].CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    
    [self.view.layer insertSublayer:theViewGradient atIndex:0];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _loggedYears = [[NSMutableArray alloc] init];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
  //  [self matchingRecordsToICloud];
    
    
    _managedObjectContext = _appDelegate.persistentContainer.viewContext;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@", [defaults objectForKey:@"username"]];
    
    _fetchRequest.predicate = predicate;
    _fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    NSArray *userArray = [[self.managedObjectContext executeFetchRequest: self.fetchRequest error:nil] mutableCopy];
    
    _currentUser = [userArray objectAtIndex:0];
    
    NSSet *years = [_currentUser valueForKey:@"years"];
    
    for (Year *i in years) {
        
        [_loggedYears addObject:i];
        
    }
    
    if (_loggedYears.count == 0) {
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY"];
        NSString *stringFromDate = [formatter stringFromDate:date];
        
        NSManagedObject *newYear = [NSEntityDescription insertNewObjectForEntityForName:@"Year" inManagedObjectContext:self.managedObjectContext];
        
        [newYear setValue:stringFromDate forKey:@"year"];
        [newYear setValue: [NSString stringWithFormat:@"%@,%@,%@,%@", @"605 N Bridge St", @"Yorkville", @"Il", @"60560"] forKey:@"address"];
        
        
        NSSet *newYearSet = [NSSet setWithObjects:newYear, nil];
        
        [_currentUser setValue:newYearSet forKey:@"years"];
        
        [_appDelegate saveContext];
        
        [[NSUserDefaults standardUserDefaults] setObject:stringFromDate forKey:@"manipulatedYear"];
        
        [_loggedYears addObject: newYear];
        
    }
        
    for (Year *i in _loggedYears) {
            
        if (i.year == [[NSUserDefaults standardUserDefaults]
            stringForKey:@"manipulatedYear"]) {
                
            _manipulatedYear = i;
                
            break;
        }
    }
    
    [_yearButton setTitle:[[NSUserDefaults standardUserDefaults]
                           stringForKey:@"manipulatedYear"] forState:UIControlStateNormal];
    
    self.counterLabel.text = [NSString stringWithFormat:@"%hd", _manipulatedYear.visitors];
    
    self.counter = _manipulatedYear.visitors;
    
    [self manageMapViewRecords: _manipulatedYear.year];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _loggedYears.count;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _manipulatedYear = [_loggedYears objectAtIndex:row];
    
     [[NSUserDefaults standardUserDefaults] setObject: self.manipulatedYear.year forKey:@"manipulatedYear"];
    
    [_yearButton setTitle: self.manipulatedYear.year forState:UIControlStateNormal];
    
    self.counterLabel.text = [NSString stringWithFormat:@"%hd", _manipulatedYear.visitors];
    
    self.counter = _manipulatedYear.visitors;
    
    [self manageMapViewRecords: _manipulatedYear.year];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    Year *selectedYear = [_loggedYears objectAtIndex:row];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor orangeColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = selectedYear.year;
    label.textAlignment = NSTextAlignmentCenter;

    return label;
}

-(void)manageMapViewRecords:(NSString*)year {
    
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString: _manipulatedYear.address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
        
        CLLocation *myLocation = [[CLLocation alloc] initWithLatitude: myPlacemark.location.coordinate.latitude longitude:myPlacemark.location.coordinate.longitude];
        
        
        _publicDB = [[CKContainer defaultContainer] publicCloudDatabase];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year = %@", year];
        
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"location = %@", myLocation];
        
        
        NSPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate, predicate2]];
        
        CKQuery *query = [[CKQuery alloc] initWithRecordType:@"mapLocations" predicate:andPredicate];
        
        [_publicDB performQuery:query
                   inZoneWithID:nil
              completionHandler:^(NSArray *results, NSError *error) {
                  
                  if (results.count != 0) {
                      
                      _mapYears = [results objectAtIndex:0];
                      
                      
                  } else {
                      
                      CKRecordID *mapUser = [[CKRecordID alloc] initWithRecordName:@"MapUser"];
                      
                      CKRecord *mapLocations = [[CKRecord alloc] initWithRecordType:@"mapLocations" recordID:mapUser];
                      
                      mapLocations[@"location"] = myLocation;
                      mapLocations[@"visitors"] = @1;
                      mapLocations[@"year"] = year;
                      
                      
                      [_publicDB saveRecord:mapLocations completionHandler:^(CKRecord *savedPlace, NSError *error) {
                          
                          
                      }];

                  }
                  
              }];
        
    }];
    
    
}

-(void)matchingRecordsToICloud {
    
    _publicDB = [[CKContainer defaultContainer] publicCloudDatabase];
    
    [_publicDB fetchRecordWithID:_currentUser.ckRecord completionHandler:^(CKRecord *fetchedPlace, NSError *error) {
                
        if (fetchedPlace != nil) {
            
            [_publicDB saveRecord:fetchedPlace completionHandler:^(CKRecord *savedPlace, NSError *savedError) {
                
            }];
        } else {
            // handle errors here
        }
    }];
    
    
}


@end
