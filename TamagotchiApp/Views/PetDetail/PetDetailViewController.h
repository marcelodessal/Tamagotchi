//
//  PetDetailViewController.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/4/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"

@interface PetDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *lblLevel;
@property (strong, nonatomic) IBOutlet UILabel *lblEnergy;
@property (strong, nonatomic) IBOutlet UILabel *lblExperience;

@property (strong, nonatomic) Pet* pet;

- (instancetype)initWithPet:(Pet *)pet;

@end
