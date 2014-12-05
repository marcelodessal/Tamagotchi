//
//  PetDetailViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/4/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "PetDetailViewController.h"
#import "Pet.h"

@interface PetDetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *lblLevel;
@property (strong, nonatomic) IBOutlet UILabel *lblEnergy;
@property (strong, nonatomic) IBOutlet UILabel *lblExperience;

@property (strong, nonatomic) Pet *pet;

@end

@implementation PetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.lblName.text = self.pet.petName;
    self.lblLevel.text = [NSString stringWithFormat:@"Nivel: %i", [self.pet.petLevel intValue]];
    self.lblEnergy.text = [NSString stringWithFormat:@"Energía: %i", [self.pet.petEnergy intValue]];
    self.lblExperience.text = [NSString stringWithFormat:@"Experiencia: %i", [self.pet.petExperience intValue]];
    int type = [self.pet.petType intValue];
    [self.image setImage:[self.pet getDefaultImageForType:type]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
 }

- (instancetype)initWithPet:(Pet *)pet {
    self = [super init];
    if (self) {
        self.pet = pet;
    }
    return self;
}



@end
