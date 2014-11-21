//
//  ShowEnergyViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "ShowEnergyViewController.h"
#import "SelectFoodViewController.h"

@interface ShowEnergyViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnFeed;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *lblPetName;
@property (strong, nonatomic) IBOutlet UILabel *lblEnergy;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIImageView *imgFood;

@property (strong, nonatomic) NSString *petName;
@property (strong, nonatomic) UIImage *petImage;


@end

@implementation ShowEnergyViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPetName:(NSString *)petName withPetImage:(UIImage *)petImage;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.petName = petName;
        self.petImage = petImage;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Nivel de Energía"];
    [self.lblPetName setText:self.petName];
    [self.image setImage:self.petImage];
    
    int energy = [self.progressView progress] * 100;
    NSString *energyLevel = [NSString stringWithFormat:@" %i ",energy];
    [self.lblEnergy setText: energyLevel];
    
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
}


#pragma mark - Gestures methods
- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    
    if (self.imgFood) {
        [UIView animateWithDuration:1.0f animations:^(void) {
            [self.imgFood setCenter:location];
        }];
        
    }
    
}

@end
