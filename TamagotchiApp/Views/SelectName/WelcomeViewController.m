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
#import "PetRemoteService.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Restore previous game

- (IBAction)restoreValues:(id)sender {
    [PetRemoteService getPetWithCode:self.myPet.code success:[self getSuccessHandler] failure:[self getErrorHandler]];
}

- (Success) getSuccessHandler {
    __weak typeof(self) weakerSelf = self;
    return ^(NSURLSessionDataTask *task, id responseObject) {
        [weakerSelf.myPet restoreValuesfromJSON: responseObject];
        [weakerSelf nextScreen];
    };
}

- (Failure) getErrorHandler {
    
    return ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog([NSString stringWithFormat:@"Error: %@", error], nil);
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
    
    // Save screen completion status for skipping this screen in the future
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NAME_SELECTED];
    
    //Push the next screen
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
