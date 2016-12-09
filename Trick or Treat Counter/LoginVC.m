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
        
        CloudkitDataFunctions *cloudkitObject = [[CloudkitDataFunctions alloc] init];
        
        [cloudkitObject login:self.usernameTextField.text password:self.passwordTextField.text completion: ^(CKRecord* results) {
            
            if (results != nil) {
                
                if (self.stayLoggedInButtonOn == true) {
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    [defaults setObject:self.usernameTextField.text forKey:@"username"];
                    
                }
                
                CoreDataFunctions *coreDataObject = [[CoreDataFunctions alloc] init];
                
                [coreDataObject createnewUser:results userName:self.usernameTextField.text];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
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

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:true];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"username"] != nil) {
        
        UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
        
        [self presentViewController: tabBarController animated:YES completion:nil];
        
    } else {
        
        _stayLoggedInButtonOn = false;
        
    }
}




@end
