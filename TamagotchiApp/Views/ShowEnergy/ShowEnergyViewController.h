//
//  ShowEnergyViewController.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectFoodViewController.h"
#import "Pet.h"
#import <MessageUI/MessageUI.h>

@interface ShowEnergyViewController : UIViewController <SelectFoodDelegate, MFMailComposeViewControllerDelegate>

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPet:(Pet *) pet;

@end
