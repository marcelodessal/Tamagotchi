//
//  RankingViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/28/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "RankingViewController.h"
#import "RankingCell.h"
#import "Pet.h"
#import "MyPet.h"
#import "NetworkManager.h"
#import "PetRemoteService.h"
#import "MapViewController.h"
#import "PetDatabaseHelper.h"

@interface RankingViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *sortedRankingItems;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) MyPet *myPet;

@end

@implementation RankingViewController

@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.images = [[NSArray alloc] initWithObjects:@"ciervo_comiendo_1", @"gato_comiendo_1", @"leon_comiendo_1", @"jirafa_comiendo_1", nil];
    self.myPet = [MyPet sharedInstance];
    
    
    // Get ranking from app database
    self.sortedRankingItems = [PetDatabaseHelper getPetRanking];
    if (self.sortedRankingItems.count)
        [self.tableView reloadData];
//    else
//        [self getRankingFromServer];
    
    // After 5 sec, get ranking from server
    [self performSelector:@selector(getRankingFromServer) withObject:nil afterDelay:5];
    
    // Register cell view
    [self.tableView registerNib:[UINib nibWithNibName:@"RankingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"rankingCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDatabaseWithRankingFromServer {
    
    for (Pet *pet in self.sortedRankingItems) {
       [PetDatabaseHelper insertPet:pet];
    }

}
- (void)getRankingFromServer {
    
    [PetRemoteService getAllPets:[self getSuccessHandler] failure:[self getErrorHandler]];
}

- (Success) getSuccessHandler {
    
    return ^(NSURLSessionDataTask *task, id responseObject) {
        __weak typeof (self) weakerSelf = self;
        NSArray *array = [[NSArray alloc] initWithArray:responseObject];
        NSMutableArray *rankingItems = [[NSMutableArray alloc] init];
        
        [PetDatabaseHelper deleteAllPets];
        
        for (NSDictionary* dict in array) {
            Pet *pet = [[Pet alloc] initWithDictionary:dict];
            [rankingItems addObject:pet];
        }
        
        NSSortDescriptor *sortByLevel = [NSSortDescriptor sortDescriptorWithKey:@"petLevel" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByLevel];
        weakerSelf.sortedRankingItems = [rankingItems sortedArrayUsingDescriptors:sortDescriptors];
        
        // Update app database
        [weakerSelf updateDatabaseWithRankingFromServer];

        [weakerSelf.tableView reloadData];
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



#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *rankingCellIdentifier = @"rankingCell";
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:rankingCellIdentifier];
    
    if (!cell) {
        cell = [[RankingCell alloc] init];
    }
    
    // Populate each cell
    [cell fillDataWithPet:self.sortedRankingItems[indexPath.row]];
    cell.delegate = self;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedRankingItems.count;
}




#pragma mark - RankingCellDelegate
- (void) didSelectPetMap:(Pet *)pet {
    MapViewController *newController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    newController.pet = pet;
    [self.navigationController pushViewController:newController animated:YES];
}


@end


