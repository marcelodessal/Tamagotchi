//
//  WelcomeViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SelectImageViewController.h"
#import "MyPet.h"

@interface WelcomeViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nombreMascota;
@property (strong, nonatomic) MyPet *myPet;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Inicio"];
    
    self.myPet = [MyPet sharedInstance];
    [self.myPet setInitialValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Restore previous game

- (IBAction)restoreValues:(id)sender {
    
    NSString *restoreURLString = [NSString stringWithFormat:@"/pet/%@", self.myPet.code];

    [[NetworkManager sharedInstance] GET:restoreURLString parameters:nil
                                  success:[self getSuccessHandler]
                                  failure:[self getErrorHandler]];
}

- (Success) getSuccessHandler {
    
    return ^(NSURLSessionDataTask *task, id responseObject) {
        [self.myPet restoreValuesfromJSON: responseObject];
        [self nextScreen];
    };
}

- (Failure) getErrorHandler {
    
    return ^(NSURLSessionDataTask *task, NSError *error) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", error];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    };
}

// New game

- (IBAction)continuar:(id)sender {
    
    self.myPet.petName = self.nombreMascota.text.capitalizedString;
    
    if (self.myPet.petName.length > 2) {
        [self nextScreen];
    } else if (self.myPet.petName.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"El nombre debe tener como mínimo tres letras" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"El nombre no puede estar en blanco" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void) nextScreen {
    SelectImageViewController *newController = [[SelectImageViewController alloc] initWithNibName:@"SelectImageViewController" bundle:nil];
    [self.navigationController pushViewController:newController animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].length) {
        return YES;
    } else if(!string.length) { //return exception
        return YES;
    }
    return NO;
}

@end
