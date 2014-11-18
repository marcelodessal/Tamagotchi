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

@end

@implementation SelectImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)select1:(id)sender {
    
}

@end
