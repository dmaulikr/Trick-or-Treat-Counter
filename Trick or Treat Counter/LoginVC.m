//
//  LoginVC.m
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 12/1/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"


@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *stayLoggedInButton;
@property (nonatomic) BOOL *stayLoggedInButtonOn;

@end

@implementation LoginVC


- (IBAction)stayLoggedInButtonPushed:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.stayLoggedInButtonOn == false) {
        self.stayLoggedInButton.alpha = 1.0;
        self.stayLoggedInButtonOn = true;
    } else {
        self.stayLoggedInButton.alpha = 0.5;
        self.stayLoggedInButtonOn = false;
        [defaults setObject:nil forKey:@"username"];
    }
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    
    }

- (IBAction)loginButtonPushed:(id)sender {
    
    if ([self.usernameTextField hasText] && [self.passwordTextField hasText]) {
    
    CKDatabase *publicDB = [[CKContainer defaultContainer] publicCloudDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@", self.usernameTextField.text];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"password = %@", self.passwordTextField.text];
    
    NSPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate, predicate2]];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"newUser" predicate:andPredicate];
    
    [publicDB performQuery:query
              inZoneWithID:nil
         completionHandler:^(NSArray *results, NSError *error) {
             
             if (results.count == 1) {
                 
                 if (self.stayLoggedInButtonOn == true) {
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

                     [defaults setObject:self.usernameTextField.text forKey:@"username"];
                     
                 }
                 
                 [self handlePersistence:[results objectAtIndex:0]];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    
                     _appDelegate.theRecord = [results objectAtIndex:0];
                     
                     UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
                     
                     [self presentViewController: tabBarController animated:YES completion:nil];
                     
                     
                 });
             }

         }];
    }
    
}
- (IBAction)createAccountButtonPushed:(id)sender {
    

    
}

-(bool) textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:true];
    return false;
}

- (void)viewDidLoad {
 
    [super viewDidLoad];

    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:true];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"username"] != nil) {
        
        UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
        
        [self presentViewController: tabBarController animated:YES completion:nil];
        
    } else {
        
        _stayLoggedInButtonOn = false;
        
    }

    
}

-(void)handlePersistence:(CKRecord*)record{
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = _appDelegate.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@", self.usernameTextField.text];
    
    fetchRequest.predicate = predicate;
    
    NSArray *userArray = [[managedObjectContext executeFetchRequest: fetchRequest error:nil] mutableCopy];
    
    if (userArray.count == 0) {
        
        NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
        
        [newUser setValue:self.usernameTextField.text forKey:@"username"];
        [newUser setValue: record forKey:@"ckRecord"];
        
        [_appDelegate saveContext];

    } else {
        
        
        
    }
    
}



@end
