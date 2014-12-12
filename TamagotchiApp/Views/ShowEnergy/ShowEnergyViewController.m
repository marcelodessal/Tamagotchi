//
//  ShowEnergyViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "ShowEnergyViewController.h"
#import "SelectFoodViewController.h"
#import "RankingViewController.h"
#import "ContactsViewController.h"
#import "MyPet.h"
#import "PushNotificationManager.h"
#import "LocationManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

float const exerciseDuration = 1.0f;

@interface ShowEnergyViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnFeed;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *lblPetName;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIImageView *imgFood;
@property (strong, nonatomic) IBOutlet UIImageView *mouth;
@property (strong, nonatomic) IBOutlet UIButton *btnExercise;

@property BOOL isFoodAvailable;
@property BOOL isExercising;
@property (strong, nonatomic) Food *foodItem;
@property (strong, nonatomic) IBOutlet UILabel *lblEnergy;

@property (strong, nonatomic) IBOutlet UILabel *lblLevel;
@property (strong, nonatomic) IBOutlet UILabel *lblPushNotification;

@property (strong, nonatomic) MyPet *myPet;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) LocationManager *locationManager;
@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation ShowEnergyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Nivel de Energía"];
    
    self.myPet = [MyPet sharedInstance];
    
    if (self.myPet.isExhausted) {
        NSString* imageName = [NSString stringWithFormat:@"%@_exhausto_4",[self.myPet getStringType]];
        [self.image setImage:[UIImage imageNamed:imageName]];
        [self.btnExercise setEnabled:NO];
    } else {
        [self.image setImage:[self.myPet getDefaultImage]];
        [self.btnExercise setEnabled:YES];
    }
    
    [self.lblPetName setText:self.myPet.petName];
    
    // Set mouth position according to pet type
    CGPoint origin = [self.myPet getMouthOriginPosition];
    self.mouth.frame = CGRectMake(origin.x, origin.y, 50, 50);
    
    [self updateEnergyBarAnimationWithDuration:1];
    
    self.isFoodAvailable = NO;
    self.isExercising = NO;
    
    UIBarButtonItem* btnAction = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contacts_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(getContacts:)];
    
    self.navigationItem.rightBarButtonItem = btnAction;
    
    [[LocationManager sharedInstance] startUpdates];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petGetExhausted) name:GET_EXHAUSTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petGetRecovered) name:GET_RECOVERED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petGetPromoted) name:GET_PROMOTED object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Set this view controller to become first responder to motion events
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.timer && [self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_EXHAUSTED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_RECOVERED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_PROMOTED object:nil];
    
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];

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

- (IBAction)listRanking:(id)sender {
    RankingViewController *newController = [[RankingViewController alloc] initWithNibName:@"RankingViewController" bundle:nil];
    [self.navigationController pushViewController:newController animated:YES];
}

- (void)getContacts:(id)sender {
    ContactsViewController *newController = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
    [self.navigationController pushViewController:newController animated:YES];
}


- (IBAction)exercise:(id)sender {
    if (self.isExercising)
        [self stopExercise];
    else
        if (self.myPet.canExercise)
            [self startExercise];
}

- (void)startExercise {
    self.isExercising = YES;
    [self.btnExercise setTitle:@"Parar" forState:UIControlStateNormal];
    
    //start timer to decrease pet energy according to animation duration
    self.timer = [NSTimer scheduledTimerWithTimeInterval:exerciseDuration target:self selector:@selector(startPetExercise) userInfo:nil repeats:YES];
    
    [self startExerciseAnimation];
}

- (void)startPetExercise {
    [self.myPet exercise];
    [self updateEnergyBarAnimationWithDuration:exerciseDuration];
    }

- (void)stopExercise {
    self.isExercising = NO;
    [self.btnExercise setTitle:@"Ejercitar" forState:UIControlStateNormal];
    
    // stop timer to stop decreasing pet energy
    if (self.timer && [self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self stopExerciseAnimation];
}

#pragma mark - Nofifications actions

- (void)petGetExhausted {
    [self stopExercise];
    [self.btnExercise setEnabled:NO];
    [self.image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_exhausto_4",[self.myPet getStringType]]]];
    [self getExhaustAnimation];
}

- (void)petGetRecovered {
    [self.btnExercise setEnabled:YES];
    [self.image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_1",[self.myPet getStringType]]]];
}

- (void)petGetPromoted {
    [self stopExercise];
    NSString *message = [NSString stringWithFormat:@"%@ ha pasado al nivel %i", self.myPet.petName, [self.myPet.petLevel intValue]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Felicidades!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [self sendNotification];
    
}

- (void)sendNotification {
    NSDictionary *data = [self.myPet getNotificationJSON];
    [PushNotificationManager pushNotification:data];
}


#pragma mark - SelectFoodDelegate methods

- (void) didSelectFood:(Food *) foodItem {
    self.foodItem = foodItem;
    [self.imgFood setImage:[UIImage imageNamed:foodItem.foodImage]];
    [self.imgFood setCenter:CGPointMake(250, 430)];
    [self.imgFood setBounds:CGRectMake(0, 0, 55, 55)];
    [self.navigationController popViewControllerAnimated:YES];
    self.isFoodAvailable = YES;
}


#pragma mark - Gestures methods

- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];

    if (self.isFoodAvailable) {
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.imgFood setCenter:location];
                         }
                         completion:^(BOOL finished) {
                             CGPoint pt = CGPointMake(location.x - self.mouth.frame.origin.x, location.y - self.mouth.frame.origin.y);
                             BOOL isInside = [self.mouth pointInside: pt withEvent:nil];
                             if (isInside){
                                 [self.myPet eatFood:self.foodItem];
                                 [self eatAnimation];
                                 self.isFoodAvailable = NO;
                             }
                         }];
        
    }

}


#pragma mark - Animations methods

- (void) eatAnimation {
    //Animate food disappearing
    CGFloat x = self.imgFood.center.x - self.imgFood.frame.size.width / 2;
    CGFloat y = self.imgFood.center.y - self.imgFood.frame.size.height / 2;
    [UIView animateWithDuration:1 animations:^{
        self.imgFood.bounds = CGRectMake(x, y, 0, 0);
    }
     completion:^(BOOL finished) {
         [self eatFoodAnimation];
    }];
}

- (void) eatFoodAnimation {
    // Animate eating process
    NSArray *images = [[NSArray alloc] initWithObjects:
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_1",[self.myPet getStringType]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_2",[self.myPet getStringType]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_3",[self.myPet getStringType]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_4",[self.myPet getStringType]]],
                       nil];
    
    [self.image setAnimationImages:images];
    [self.image setAnimationDuration:1];
    [self.image setAnimationRepeatCount:2];
    [self.image startAnimating];
    
    // Play eating sound
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Eating-Sound" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    
    // update progress bar with duration equals to 2 sec (twice previous animation duration of 1 sec)
    [self updateEnergyBarAnimationWithDuration:2];
}

- (void) startExerciseAnimation {
    NSArray *images = [[NSArray alloc] initWithObjects:
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_1",[self.myPet getStringType]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_2",[self.myPet getStringType]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_3",[self.myPet getStringType]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_4",[self.myPet getStringType]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_5",[self.myPet getStringType]]],
                       nil];
    
    [self.image setAnimationImages:images];
    [self.image setAnimationDuration:exerciseDuration];
    [self.image setAnimationRepeatCount:0];
    [self.image startAnimating];
    
    // Play exercise sound
    NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:@"Toke_and_Exhale" withExtension:@"wav"];
    if (soundFileURL) {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.player.enableRate = YES;
        self.player.rate = 2.2;
        self.player.volume = 0.1;
        self.player.numberOfLoops = -1; //infinite
    }
    [self.player play];
}

- (void) stopExerciseAnimation {
    [self.image stopAnimating];
    [self.player stop];
}

- (void) getExhaustAnimation {
    
    NSArray *images = [[NSArray alloc] initWithObjects:
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_exhausto_1",[self.myPet getStringType]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_exhausto_2",[self.myPet getStringType]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_exhausto_3",[self.myPet getStringType]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_exhausto_4",[self.myPet getStringType]]],
                       nil];
    
    [self.image setAnimationImages:images];
    [self.image setAnimationDuration:2];
    [self.image setAnimationRepeatCount:1];
    [self.image startAnimating];
}


-(void) updateEnergyBarAnimationWithDuration:(float) duration {
    float progress = [self.myPet.petEnergy intValue] / 100.0f;
    [UIView animateWithDuration:duration animations:^{ [self.progressView setProgress:progress animated:YES];}];
    [self.lblEnergy setText:[NSString stringWithFormat:@"%i", [self.myPet.petEnergy intValue]]];
    [self.lblLevel setText:[NSString stringWithFormat:@"Nivel: %i", [self.myPet.petLevel intValue]]];

}

#pragma mark - Shake detection methods

// View controller must become FirstResponder to respond to a shake gesture.
- (BOOL)canBecomeFirstResponder {
    return YES;
}

// We need to detect when a user starts and ends a shake.
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        self.isExercising ? [self stopExercise] : [self startExercise];
    }
}


@end
