//
//  AppDelegate.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/18/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "SelectImageViewController.h"
#import "ShowEnergyViewController.h"
#import "PetDetailViewController.h"
#import "MyPet.h"
#import "PetRemoteService.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [Parse setApplicationId:@"guhchukKgURzzZVCHBFOxyD35VHeMQm3EUZEdJvD"
                  clientKey:@"SnnbrQ9yOemJspA7LRt1MCACFFUYNkbQ1k2IM1vH"];
    
    // Register for Push Notitications
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes: (UIUserNotificationTypeAlert |UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil]];
    }
    else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                               UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)]; }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
#endif
    
    // Subscribe to channel
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObject:@"PeleaDeMascotas" forKey:@"channels"];
        [currentInstallation saveInBackground];
    
    // Detect shake motion
    application.applicationSupportsShakeToEdit = YES;
        

    // Load user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Set the home screen
    UIViewController *home;
    
//    home = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
    
    if (![defaults boolForKey:NAME_SELECTED])
        home = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
    else if (![defaults boolForKey:IMAGE_SELECTED])
        home = [[SelectImageViewController alloc] initWithNibName:@"SelectImageViewController" bundle:nil];
    else
        home = [[ShowEnergyViewController alloc] initWithNibName:@"ShowEnergyViewController" bundle:nil];
    
    UINavigationController* navControllerHome = [[UINavigationController alloc] initWithRootViewController:home];
    
    [self.window setRootViewController:navControllerHome];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[PFPush handlePush:userInfo];
    NSString *code = [userInfo objectForKey:@"code"];
    NSString *name = [userInfo objectForKey:@"name"];
    NSString *level = [userInfo objectForKey:@"level"];
    
    NSString *message = [NSString stringWithFormat:@"%@ (%@) ha subido al nivel %@", name, code, level];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self savePetToDisk];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self savePetToDisk];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *urlString = [url absoluteString];
    NSArray *components = [urlString componentsSeparatedByString:@"/"];
    
    if ([[components objectAtIndex:2] isEqualToString:@"pet"]) {
        NSString *petCode = [components objectAtIndex:3];
        [PetRemoteService getPetWithCode:[petCode uppercaseString] success:[self getSuccessHandler] failure:[self getErrorHandler]];
    }
    return YES;
}

- (void) savePetToDisk {
    [[MyPet sharedInstance] saveMeToDisk];
}

- (Success) getSuccessHandler {
    
    return ^(NSURLSessionDataTask *task, id responseObject) {
        __weak typeof (self) weakerSelf = self;
        Pet *pet = [[Pet alloc] initWithDictionary:responseObject];
        PetDetailViewController *newController = [[PetDetailViewController alloc] initWithPet:pet];
        [(UINavigationController*)weakerSelf.window.rootViewController pushViewController:newController animated:YES];
     };
}

- (Failure) getErrorHandler {
    
    return ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog([NSString stringWithFormat:@"Error: %@", error], nil);
    };
}


@end
