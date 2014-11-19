//
//  SelectImageViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "SelectImageViewController.h"

@interface SelectImageViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imagenSeleccionada;
@property (strong, nonatomic) IBOutlet UIButton *imagen1;
@property (strong, nonatomic) IBOutlet UIButton *imagen2;
@property (strong, nonatomic) IBOutlet UIButton *imagen3;
@property (strong, nonatomic) IBOutlet UIButton *imagen4;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SelectImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.scrollView setContentSize: CGSizeMake(480, 120)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
