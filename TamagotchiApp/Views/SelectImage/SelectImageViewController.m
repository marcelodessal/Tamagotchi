//
//  SelectImageViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "SelectImageViewController.h"
#import "ShowEnergyViewController.h"
#import "MyPet.h"

@interface SelectImageViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblPetName;
@property (strong, nonatomic) IBOutlet UIImageView *imagenSeleccionada;
@property (strong, nonatomic) IBOutlet UIButton *imagen1;
@property (strong, nonatomic) IBOutlet UIButton *imagen2;
@property (strong, nonatomic) IBOutlet UIButton *imagen3;
@property (strong, nonatomic) IBOutlet UIButton *imagen4;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UILabel *lblMessage;

@property (strong, nonatomic) MyPet *myPet;


@end

@implementation SelectImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Imágen"];
    [self.scrollView setContentSize: CGSizeMake(500, 100)];
    
    self.myPet = [MyPet sharedInstance];
    [self.lblPetName setText:self.myPet.petName];
    
    if (self.myPet.petType >= 0) {
        [self.imagenSeleccionada setImage:[self.myPet getDefaultImageForType:self.myPet.petType]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)continue:(id)sender {
    if (self.imagenSeleccionada.image) {
        self.myPet.petImage = self.imagenSeleccionada.image;
        ShowEnergyViewController *newController = [[ShowEnergyViewController alloc] initWithNibName:@"ShowEnergyViewController" bundle:nil];
        [self.navigationController pushViewController:newController animated:YES];
    } else {
        self.lblMessage.text = @"Seleccione una mascota";
    }
}

- (IBAction)selectImage:(UIButton*)sender {
    
    int type = (int)sender.tag;
    
    self.myPet.petType = type;
    [self.imagenSeleccionada setImage:[self.myPet getDefaultImageForType:type]];
    self.myPet.petStringType = [self.myPet getStringType:type];
    self.lblMessage.text = @"";
    
}

@end
