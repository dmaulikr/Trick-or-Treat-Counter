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


@interface CounterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (nonatomic) int counter;
@property (nonatomic) UIVisualEffectView *blurEffectView;
@property (nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *yearButton;

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSFetchRequest *fetchRequest;
@property (nonatomic) NSMutableArray *loggedYears;

@end

@implementation CounterViewController



- (IBAction)yearButtonPushed:(id)sender {

        
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
        self.counter --;
        self.counterLabel.text = [NSString stringWithFormat:@"%d", self.counter];
    }
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.counterLabel.text = @"0";
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDate *date = [NSDate date];
    
  
    NSManagedObjectContext *managedObjectContext = _appDelegate.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Year"];
    _loggedYears = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    if (_loggedYears.count == 0) {
        
        NSManagedObject *newYear = [NSEntityDescription insertNewObjectForEntityForName:@"Year" inManagedObjectContext:managedObjectContext];
        
        [newYear setValue:date forKey:@"year"];
        [newYear setValue: @0 forKey:@"visitors"];
        
        [_appDelegate saveContext];
        
        
    } else {
        
        
    }

    
    [_yearButton setTitle:@"2015" forState:UIControlStateNormal];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

/*

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = nil;
    
    switch(row) {
        case 0:
            title = @"2016";
            
            
            break;
        case 1:
            title = @"2015";
            
            break;
        case 2:
            title = @"2014";
            
            break;
    }
    return title;
}

*/

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor orangeColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    
    switch(row) {
        case 0:
            label.text = @"2016";
            label.textAlignment = NSTextAlignmentCenter;
            break;
        case 1:
            label.text = @"2015";
            label.textAlignment = NSTextAlignmentCenter;
            break;
        case 2:
            label.text = @"2014";
            label.textAlignment = NSTextAlignmentCenter;
            break;
    }

    return label;
}



@end
