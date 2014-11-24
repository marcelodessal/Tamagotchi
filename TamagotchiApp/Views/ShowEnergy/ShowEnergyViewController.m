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
@property (strong, nonatomic) IBOutlet UIButton *btnExercise;

@property (strong, nonatomic) Pet *pet;

@property BOOL isFoodAvailable;
@property BOOL isExercising;

@end

@implementation ShowEnergyViewController {
    
    NSTimer *timer;
}
    
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
    
    [self.progressView setProgress:1];
    
    self.isFoodAvailable = NO;
    self.isExercising = NO;
    
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

- (IBAction)exercise:(id)sender {
    if (self.isExercising)
        [self stopExercise];
    else
        [self startExercise];
    
    self.isExercising = !self.isExercising;
}

- (void) startExercise {
    [self.btnExercise setTitle:@"Parar" forState:UIControlStateNormal];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startExerciseAnimation) userInfo:nil repeats:YES];
    
}

- (void) stopExercise {
    [self.btnExercise setTitle:@"Ejercitar" forState:UIControlStateNormal];
    [self stopExerciseAnimation];
    
    if (timer && [timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}


#pragma mark - SelectFoodDelegate methods
- (void) didSelectFood:(Food *) foodItem {
    [self.imgFood setImage:[UIImage imageNamed:foodItem.foodImage]];
    [self.imgFood setCenter:CGPointMake(267, 514)];
    [self.navigationController popViewControllerAnimated:YES];
    self.isFoodAvailable = YES;
    [self.imgFood setHidden:NO];
}


#pragma mark - Gestures methods
- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    
    if (self.isFoodAvailable) {
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
                                 [self.pet eat];
                                 [self eatFoodAnimation];
                             }
                         }];
        
    }

}


#pragma mark - Animation methods
- (void) eatFoodAnimation {
    
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
    
    // update progress bar with duration equals to 2 sec (twice previous animation duration of 1 sec)
    [self updateEnergyAnimationWithDuration:2];
}

- (void) startExerciseAnimation {
    
    NSArray *images = [[NSArray alloc] initWithObjects:
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_1",self.pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_2",self.pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_3",self.pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_4",self.pet.petType]],
                       nil];
    
    [self.image setAnimationImages:images];
    [self.image setAnimationDuration:1];
    [self.image setAnimationRepeatCount:1];
    [self.image startAnimating];
    
    [self.pet exercise];
    
    // update progress bar with duration equals to 1 sec
    [self updateEnergyAnimationWithDuration:1];
    
    // check if energy is over
    if ([self.pet getEnergy] == 0)
        [self stopExercise];
    
}

- (void) stopExerciseAnimation {
    [self.image stopAnimating];
}


-(void) updateEnergyAnimationWithDuration:(float) duration {
    float progress = [self.pet getEnergy] / 100.0f;
    [UIView animateWithDuration:duration animations:^{ [self.progressView setProgress:progress animated:YES];}];
}

@end
