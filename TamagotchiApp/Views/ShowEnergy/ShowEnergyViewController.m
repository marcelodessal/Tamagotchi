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
#import "Pet.h"
#import "PushNotificationManager.h"

@interface ShowEnergyViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnFeed;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *lblPetName;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIImageView *imgFood;
@property (strong, nonatomic) IBOutlet UIImageView *mouth;
@property (strong, nonatomic) MFMailComposeViewController *mailComposer;
@property (strong, nonatomic) IBOutlet UIButton *btnExercise;

@property BOOL isFoodAvailable;
@property BOOL isExercising;
@property (strong, nonatomic) Food *foodItem;
@property (strong, nonatomic) IBOutlet UILabel *lblEnergy;

@property (strong, nonatomic) IBOutlet UILabel *lblLevel;
@property (strong, nonatomic) IBOutlet UILabel *lblPushNotification;

@end

@implementation ShowEnergyViewController {
    
    Pet *pet;
    NSTimer *timer;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Nivel de Energía"];
    pet = [Pet sharedInstance];
    [self.lblPetName setText:pet.petName];
    [self.image setImage:pet.petImage];
    
    
    [self updateEnergyBarAnimationWithDuration:1];
    
    self.isFoodAvailable = NO;
    self.isExercising = NO;
    
    
    //Add mail button to navigation bar
    UIBarButtonItem* mailButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mail_icon"]  style:UIBarButtonItemStyleDone target:self action:@selector(sendMail:)];
 
    self.navigationItem.rightBarButtonItem = mailButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petGetExhausted) name:GET_EXHAUSTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petGetRecovered) name:GET_RECOVERED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petGetPromoted) name:GET_PROMOTED object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (timer && [timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_EXHAUSTED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_RECOVERED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_PROMOTED object:nil];
    
    [super viewWillDisappear:YES];

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

- (void)sendMail:(id)sender {
    NSString *emailTitle = @"Que app copada";
    NSString *messageBody = [NSString stringWithFormat:@"Buenas! Soy %@, cómo va? Quería comentarte que estuve usando la App TamagotchiApp para comerme todo y está genial. Bajatela YA!!   Saludos", pet.petName];
    
    self.mailComposer = [[MFMailComposeViewController alloc] init];
    self.mailComposer.mailComposeDelegate = self;
    [self.mailComposer setSubject:emailTitle];
    [self.mailComposer setMessageBody:messageBody isHTML:NO];
    
    // Present mail view controller on screen
    [self presentViewController:self.mailComposer animated:YES completion:nil];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    UIAlertView *alert;
    switch (result) {
         case MFMailComposeResultCancelled:
            alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"Has cancelado el mensaje" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case MFMailComposeResultSaved:
            alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"El mensaje ha sido guardado como borrador." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case MFMailComposeResultSent:
            alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"El mensaje fue enviado exitosamente." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case MFMailComposeResultFailed:
            alert = [[UIAlertView alloc] initWithTitle:@"Atención" message:@"El envio ha fallado." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)exercise:(id)sender {
    if (self.isExercising)
        [self stopExercise];
    else
        if (pet.canExercise)
            [self startExercise];
}

- (void)startExercise {
    self.isExercising = YES;
    [self.btnExercise setTitle:@"Parar" forState:UIControlStateNormal];
    
    //start timer to decrease pet energy every 1 sec
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startPetExercise) userInfo:nil repeats:YES];
    
    [self startExerciseAnimation];
}

- (void)startPetExercise {
    [pet exercise];
    [self updateEnergyBarAnimationWithDuration:1];
    }

- (void)stopExercise {
    self.isExercising = NO;
    [self.btnExercise setTitle:@"Ejercitar" forState:UIControlStateNormal];
    
    // stop timer to stop decreasing pet energy
    if (timer && [timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
    
    [self stopExerciseAnimation];
}

#pragma mark - Nofifications actions

- (void)petGetExhausted {
    [self stopExercise];
    [self.btnExercise setEnabled:NO];
    [self.image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_exhausto_4",pet.petType]]];
    [self getExhaustAnimation];
}

- (void)petGetRecovered {
    [self.btnExercise setEnabled:YES];
    [self.image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_1",pet.petType]]];
}

- (void)petGetPromoted {
    [self stopExercise];
    NSString *message = [NSString stringWithFormat:@"%@ ha pasado al nivel %i", pet.petName, [pet getLevel]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Felicidades!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [self postToServer];
    [self sendNotification];
    
}

- (void)sendNotification {
    NSDictionary *data = [pet getNotificationJSON];
    [PushNotificationManager pushNotification:data];
}

- (void)postToServer {
    NSDictionary *parameters = [pet getServerJSON];
    
    [[NetworkManager sharedInstance] POST:@"/pet" parameters:parameters
                                 success:[self getSuccessHandler]
                                 failure:[self getErrorHandler]];
}

- (Success) getSuccessHandler {
    
    return ^(NSURLSessionDataTask *task, id responseObject) {
        // Do something
    };
}

- (Failure) getErrorHandler {
    
    return ^(NSURLSessionDataTask *task, NSError *error) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", error];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    };
}


#pragma mark - SelectFoodDelegate methods

- (void) didSelectFood:(Food *) foodItem {
    self.foodItem = foodItem;
    [self.imgFood setImage:[UIImage imageNamed:foodItem.foodImage]];
    [self.imgFood setCenter:CGPointMake(250, 430)];
    [self.navigationController popViewControllerAnimated:YES];
    self.isFoodAvailable = YES;
    [self.imgFood setHidden:NO];
}


#pragma mark - Gestures methods

- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];

    // Set mouth position according to the animal and its state
    
    if (pet.isExhausted) {
        if ([pet.petType isEqualToString:@"ciervo"]){
            [self.mouth setCenter:CGPointMake(160, 320)];
        } else if ([pet.petType isEqualToString:@"gato"]){
            [self.mouth setCenter:CGPointMake(160, 330)];
        } else if ([pet.petType isEqualToString:@"leon"]){
            [self.mouth setCenter:CGPointMake(105, 330)];
        } else { // jirafa
            [self.mouth setCenter:CGPointMake(170, 265)];
        }
    } else {
        if ([pet.petType isEqualToString:@"ciervo"]){
            [self.mouth setCenter:CGPointMake(175, 300)];
        } else if ([pet.petType isEqualToString:@"gato"]){
            [self.mouth setCenter:CGPointMake(125, 300)];
        } else if ([pet.petType isEqualToString:@"leon"]){
            [self.mouth setCenter:CGPointMake(110, 320)];
        } else { // jirafa
            [self.mouth setCenter:CGPointMake(160, 245)];
        }
    }

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
                                 [pet eatFood:self.foodItem];
                                 [self eatFoodAnimation];
                                 self.isFoodAvailable = NO;
                             }
                         }];
        
    }

}


#pragma mark - Animations methods

- (void) eatFoodAnimation {
    
    NSArray *images = [[NSArray alloc] initWithObjects:
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_1",pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_2",pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_3",pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_comiendo_4",pet.petType]],
                       nil];
    
    [self.image setAnimationImages:images];
    [self.image setAnimationDuration:1];
    [self.image setAnimationRepeatCount:2];
    [self.image startAnimating];
    
    // update progress bar with duration equals to 2 sec (twice previous animation duration of 1 sec)
    [self updateEnergyBarAnimationWithDuration:2];
}

- (void) startExerciseAnimation {
    
    NSArray *images = [[NSArray alloc] initWithObjects:
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_1",pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_2",pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_3",pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_4",pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_ejercicio_5",pet.petType]],
                       nil];
    
    [self.image setAnimationImages:images];
    [self.image setAnimationDuration:1];
    [self.image setAnimationRepeatCount:0];
    [self.image startAnimating];
}

- (void) stopExerciseAnimation {
    [self.image stopAnimating];
}

- (void) getExhaustAnimation {
    
    NSArray *images = [[NSArray alloc] initWithObjects:
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_exhausto_1",pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_exhausto_2",pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_exhausto_3",pet.petType]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@_exhausto_4",pet.petType]],
                       nil];
    
    [self.image setAnimationImages:images];
    [self.image setAnimationDuration:2];
    [self.image setAnimationRepeatCount:1];
    [self.image startAnimating];
}


-(void) updateEnergyBarAnimationWithDuration:(float) duration {
    float progress = [pet getEnergy] / 100.0f;
    [UIView animateWithDuration:duration animations:^{ [self.progressView setProgress:progress animated:YES];}];
    [self.lblEnergy setText:[NSString stringWithFormat:@"%i", [pet getEnergy]]];
    [self.lblLevel setText:[NSString stringWithFormat:@"Nivel: %i", [pet getLevel]]];

}


@end
