//
//  ShowEnergyViewController.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectFoodViewController.h"

@interface ShowEnergyViewController : UIViewController <SelectFoodDelegate>

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPetName:(NSString *)petName withPetImage:(UIImage *)petImage;

@end
