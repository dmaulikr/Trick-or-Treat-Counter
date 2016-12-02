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

@end

@implementation LoginVC

- (IBAction)loginButtonPushed:(id)sender {
    
    CKDatabase *publicDB = [[CKContainer defaultContainer] publicCloudDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@", self.usernameTextField.text];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"password = %@", self.passwordTextField.text];
    
    NSPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: @[predicate, predicate2]];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"newUser" predicate:andPredicate];
    
    [publicDB performQuery:query
              inZoneWithID:nil
         completionHandler:^(NSArray *results, NSError *error) {
             
             if (results.count == 1) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    
                     _appDelegate.theRecord = [results objectAtIndex:0];
                     
                     UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
                     
                     [self presentViewController: tabBarController animated:YES completion:nil];
                     
                     
                 });
             }

         }];
    

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



@end
