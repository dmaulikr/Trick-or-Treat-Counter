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

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSFetchRequest *fetchRequest;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSMutableArray *loggedYears;
@property (nonatomic) Year *manipulatedYear;
@property (nonatomic) User *currentUser;
@property (nonatomic) CloudkitDataFunctions* cloudkitObject;
@property (nonatomic) CoreDataFunctions* coredataObject;

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
        
        CoreDataFunctions* createNewYear = [[CoreDataFunctions alloc] init];
        
       Year* newYear = [createNewYear newYear:_loggedYears forUser:_currentUser];
        
        [_loggedYears addObject:newYear];
        
        [_appDelegate saveContext];
        
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
    
    [_cloudkitObject savemapViewRecords:_manipulatedYear];
    
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
    
    _managedObjectContext = _appDelegate.persistentContainer.viewContext;
    
    _coredataObject = [[CoreDataFunctions alloc] init];
    
    _currentUser = [_coredataObject performFetch];
    
    NSSet *years = [_currentUser valueForKey:@"years"];
    
    for (Year *i in years) {
        
        [_loggedYears addObject:i];
        
    }
    
    if (_loggedYears.count == 0) {
        
        Year* newYear = [_coredataObject newYear:_loggedYears forUser:_currentUser];
        
        [_loggedYears addObject: newYear];
        
        [_appDelegate saveContext];
    }
        
    for (Year *i in _loggedYears) {
            
        if (i.year == [[NSUserDefaults standardUserDefaults]
            stringForKey:@"manipulatedYear"]) {
                
            _manipulatedYear = i;
                
            break;
            
        } else {
            
            _manipulatedYear = [_loggedYears objectAtIndex:0];
            
        }
    }
    
    [_yearButton setTitle:[[NSUserDefaults standardUserDefaults]
                           stringForKey:@"manipulatedYear"] forState:UIControlStateNormal];
    
    self.counterLabel.text = [NSString stringWithFormat:@"%hd", _manipulatedYear.visitors];
    
    self.counter = _manipulatedYear.visitors;
    
    _cloudkitObject = [[CloudkitDataFunctions alloc] init];
    
    [_cloudkitObject manageMapViewRecords:_manipulatedYear];
    
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
    
    [_cloudkitObject manageMapViewRecords:_manipulatedYear];
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



@end
