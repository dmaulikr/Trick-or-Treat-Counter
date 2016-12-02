//
//  CreateAccountViewController.m
//  Trick or Treat Counter
//
//  Created by Christopher Weaver on 12/1/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

#import "CreateAccountViewController.h"

@interface CreateAccountViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *streetAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UITextView *errorTextField;




@end

@implementation CreateAccountViewController

- (IBAction)createAccountButtonPushed:(id)sender {
    
    if ([self fieldsAreFilled]) {
        
    } else {
        
        self.errorTextField.text = @"One or more requried fields was left empty";
    }
    
    CKDatabase *publicDB = [[CKContainer defaultContainer] publicCloudDatabase];
    
    CKRecordID *user = [[CKRecordID alloc] initWithRecordName:@"User"];
    
    CKRecord *newUser = [[CKRecord alloc] initWithRecordType:@"newUser" recordID:user];
    
    newUser[@"firstName"] = [NSString stringWithFormat:@"%@", self.firstNameTextField.text];
    
    newUser[@"lastName"] = [NSString stringWithFormat:@"%@", self.lastNameTextField.text];
    
    newUser[@"userName"] = [NSString stringWithFormat:@"%@", self.usernameTextField.text];
    
    newUser[@"password"] = [NSString stringWithFormat:@"%@", self.passwordTextField.text];
    
    newUser[@"streetAddress"] = [NSString stringWithFormat:@"%@", self.streetAddressTextField.text];
    
    newUser[@"city"] = [NSString stringWithFormat:@"%@", self.cityTextField.text];
    
    newUser[@"zipcode"] = [NSString stringWithFormat:@"%@", self.zipCodeTextField.text];
    
    newUser[@"years"] = @0;
    
    [publicDB saveRecord:newUser completionHandler:^(CKRecord *savedPlace, NSError *error) {
        
        
        
    }];

    
}


-(BOOL)fieldsAreFilled{
    
    if ([self.usernameTextField hasText] && [self.passwordTextField hasText] && [self.firstNameTextField hasText] && [self.lastNameTextField hasText] && [self.streetAddressTextField hasText] && [self.cityTextField hasText] && [self.stateTextField hasText] && [self.zipCodeTextField hasText]) {
        
        return true;
        
    } else {
        
        return false;
        
    }
    
}

-(bool) textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:true];
    return false;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.streetAddressTextField.delegate = self;
    self.cityTextField.delegate = self;
    self.stateTextField.delegate = self;
    self.zipCodeTextField.delegate = self;
}



@end
