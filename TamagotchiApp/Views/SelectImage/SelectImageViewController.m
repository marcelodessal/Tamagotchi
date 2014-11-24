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
@property (strong, nonatomic) NSString *petName;
@property (strong, nonatomic) NSString *petType;

@end

@implementation SelectImageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPetName:(NSString *)petName;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.petName = petName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Imágen"];
    [self.scrollView setContentSize: CGSizeMake(480, 120)];
    [self.lblPetName setText:self.petName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)continue:(id)sender {
    if (self.imagenSeleccionada.image) {
//        Pet *pet = [[Pet alloc] initWithName:self.petName withImage:self.imagenSeleccionada.image withType:self.petType];
        Pet *pet = [Pet sharedInstance];
        [pet setInitialName:self.petName andImage:self.imagenSeleccionada.image andType:self.petType];
        ShowEnergyViewController *newController = [[ShowEnergyViewController alloc] initWithNibName:@"ShowEnergyViewController" bundle:nil                                                                                   withPet: pet];
        [self.navigationController pushViewController:newController animated:YES];
    } else {
        self.lblMessage.text = @"Seleccione una mascota";
    }
}

- (IBAction)selectImage:(UIButton*)sender {
    
    switch (sender.tag) {
        case 0:
            [self.imagenSeleccionada setImage:[UIImage imageNamed:@"ciervo_comiendo_1"]];
            self.petType = @"ciervo";
            break;
        case 1:
            [self.imagenSeleccionada setImage:[UIImage imageNamed:@"gato_comiendo_1"]];
            self.petType = @"gato";
            break;
        case 2:
            [self.imagenSeleccionada setImage:[UIImage imageNamed:@"leon_comiendo_1"]];
            self.petType = @"leon";
            break;
        case 3:
            [self.imagenSeleccionada setImage:[UIImage imageNamed:@"jirafa_comiendo_1"]];
            self.petType = @"jirafa";
            break;
        default:
            break;
    }
    self.lblMessage.text = @"";
    
}

@end
