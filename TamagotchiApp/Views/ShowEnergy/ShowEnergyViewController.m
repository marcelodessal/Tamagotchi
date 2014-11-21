//
//  ShowEnergyViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "ShowEnergyViewController.h"
#import "SelectFoodViewController.h"
#import "Pet.h"

@interface ShowEnergyViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnFeed;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *lblPetName;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIImageView *imgFood;
@property (strong, nonatomic) IBOutlet UIImageView *mouth;

@property (strong, nonatomic) Pet *pet;

@property BOOL foodAvailable;

@end

@implementation ShowEnergyViewController
    
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPet:(Pet *) pet
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pet = pet;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Nivel de Energía"];
    [self.lblPetName setText:self.pet.petName];
    [self.image setImage:self.pet.petImage];
    
    self.foodAvailable = NO;
    
    // Set mouth position according to what animal is
    if ([self.pet.petType isEqualToString:@"ciervo"]){
        [self.mouth setCenter:CGPointMake(175, 300)];
    } else if ([self.pet.petType isEqualToString:@"gato"]){
        [self.mouth setCenter:CGPointMake(125, 300)];
    } else if ([self.pet.petType isEqualToString:@"leon"]){
        [self.mouth setCenter:CGPointMake(110, 320)];
    } else { // jirafa
        [self.mouth setCenter:CGPointMake(160, 245)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feed:(id)sender {
    SelectFoodViewController *newController = [[SelectFoodViewController alloc] initWithNibName:@"SelectFoodViewController" bundle:nil];
    [newController setDelegate:self];
    [self.navigationController pushViewController:newController animated:YES];
}


#pragma mark - SelectFoodDelegate methods
- (void) didSelectFood:(Food *) foodItem {
    [self.imgFood setImage:[UIImage imageNamed:foodItem.foodImage]];
    [self.imgFood setCenter:CGPointMake(267, 514)];
    [self.navigationController popViewControllerAnimated:YES];
    self.foodAvailable = YES;
    [self.imgFood setHidden:NO];
}


#pragma mark - Gestures methods
- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    
    if (self.foodAvailable) {
        [UIView animateWithDuration:2.0f
                              delay:0.5f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self.imgFood setCenter:location];
                         }
                         completion:^(BOOL finished) {
                             CGPoint pt = CGPointMake(location.x - self.mouth.frame.origin.x, location.y - self.mouth.frame.origin.y);
                             BOOL isInside = [self.mouth pointInside: pt withEvent:nil];
                             if (isInside){
                                 [self.imgFood setHidden:YES];
                                 [self eatFood];
                             }
                         }];
        
    }

}


#pragma mark - Animation methods
- (void) eatFood {
    
    NSArray *images = [[NSArray alloc] initWithObjects:
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_1",self.pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_2",self.pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_3",self.pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_4",self.pet.petType]],
                       nil];
    
    [self.image setAnimationImages:images];
    [self.image setAnimationDuration:1];
    [self.image setAnimationRepeatCount:2];
    [self.image startAnimating];
    [self changeEnergy];
}

-(void) changeEnergy {
    [UIView animateWithDuration:2 animations:^{ [self.progressView setProgress:1 animated:YES];}];
}

@end
