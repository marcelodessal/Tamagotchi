//
//  WelcomeViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SelectImageViewController.h"

@interface WelcomeViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nombreMascota;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Tamagotchi"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)continuar:(id)sender {
    
    NSString *petName = self.nombreMascota.text.capitalizedString;
    
    if (petName.length > 2) {
        SelectImageViewController *newController = [[SelectImageViewController alloc] initWithNibName:@"SelectImageViewController" bundle:nil withPetName:petName];
        [self.navigationController pushViewController:newController animated:YES];
    } else if (petName.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"El nombre debe tener como mínimo tres letras" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"El nombre no puede estar en blanco" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
