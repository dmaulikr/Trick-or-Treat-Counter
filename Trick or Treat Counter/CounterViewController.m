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

@property (nonatomic) AppDelegate *appDelegate;

//@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (nonatomic) NSFetchRequest *fetchRequest;

@end

@implementation CounterViewController





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
    
 //   _fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Year"];
   // _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext: self.app.persistentContainer.viewContext sectionNameKeyPath:nil cacheName:nil];
    

  
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

   
    
}



// NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] init];
// NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];


@end
