//
//  SelectImageViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "SelectImageViewController.h"
#import "ShowEnergyViewController.h"
#import "Pet.h"

@interface SelectImageViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblPetName;
@property (strong, nonatomic) IBOutlet UIImageView *imagenSeleccionada;
@property (strong, nonatomic) IBOutlet UIButton *imagen1;
@property (strong, nonatomic) IBOutlet UIButton *imagen2;
@property (strong, nonatomic) IBOutlet UIButton *imagen3;
@property (strong, nonatomic) IBOutlet UIButton *imagen4;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UILabel *lblMessage;

@end

@implementation SelectImageViewController {
    Pet *pet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Imágen"];
    [self.scrollView setContentSize: CGSizeMake(480, 120)];
    pet = [Pet sharedInstance];
    [self.lblPetName setText:pet.petName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)continue:(id)sender {
    if (self.imagenSeleccionada.image) {
        pet.petImage = self.imagenSeleccionada.image;
        ShowEnergyViewController *newController = [[ShowEnergyViewController alloc] initWithNibName:@"ShowEnergyViewController" bundle:nil];
        [self.navigationController pushViewController:newController animated:YES];
    } else {
        self.lblMessage.text = @"Seleccione una mascota";
    }
}

- (IBAction)selectImage:(UIButton*)sender {
    
    switch (sender.tag) {
        case 0:
            [self.imagenSeleccionada setImage:[UIImage imageNamed:@"ciervo_comiendo_1"]];
            pet.petType = @"ciervo";
            break;
        case 1:
            [self.imagenSeleccionada setImage:[UIImage imageNamed:@"gato_comiendo_1"]];
            pet.petType = @"gato";
            break;
        case 2:
            [self.imagenSeleccionada setImage:[UIImage imageNamed:@"leon_comiendo_1"]];
            pet.petType = @"leon";
            break;
        case 3:
            [self.imagenSeleccionada setImage:[UIImage imageNamed:@"jirafa_comiendo_1"]];
            pet.petType = @"jirafa";
            break;
        default:
            break;
    }
    self.lblMessage.text = @"";
    
}

@end
