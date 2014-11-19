//
//  ShowEnergyViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "ShowEnergyViewController.h"

@interface ShowEnergyViewController ()
@property (strong, nonatomic) IBOutlet UILabel *energyLeft;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation ShowEnergyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    int energy = [self.progressView progress] * 100;
    NSString *value = [NSString stringWithFormat:@" %i ",energy];
    [self.energyLeft setText: value];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
