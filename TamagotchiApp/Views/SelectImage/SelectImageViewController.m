//
//  SelectImageViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "SelectImageViewController.h"
#import "ShowEnergyViewController.h"

@interface SelectImageViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblPetName;
@property (strong, nonatomic) IBOutlet UIImageView *imagenSeleccionada;
@property (strong, nonatomic) IBOutlet UIButton *imagen1;
@property (strong, nonatomic) IBOutlet UIButton *imagen2;
@property (strong, nonatomic) IBOutlet UIButton *imagen3;
@property (strong, nonatomic) IBOutlet UIButton *imagen4;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSString *petName;


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
    [self setTitle:@"Selección de Imágen"];
    [self.scrollView setContentSize: CGSizeMake(480, 120)];
    [self.lblPetName setText:self.petName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)continue:(id)sender {
    ShowEnergyViewController *newController = [[ShowEnergyViewController alloc] initWithNibName:@"ShowEnergyViewController" bundle:nil                                                                                   withPetName:self.petName withPetImage:self.imagenSeleccionada.image];
    [self.navigationController pushViewController:newController animated:YES];
}

- (IBAction)selectImage:(UIButton*)sender {
    
    switch (sender.tag) {
        case 0:
            [self.imagenSeleccionada setImage:[UIImage imageNamed:@"ciervo_comiendo_1"]];
            break;
        case 1:
            [self.imagenSeleccionada setImage:[UIImage imageNamed:@"gato_comiendo_1"]];
            break;
        case 2:
            [self.imagenSeleccionada setImage:[UIImage imageNamed:@"leon_comiendo_1"]];
            break;
        case 3:
            [self.imagenSeleccionada setImage:[UIImage imageNamed:@"jirafa_comiendo_1"]];
            break;
        default:
            break;
    }
    
}

@end
