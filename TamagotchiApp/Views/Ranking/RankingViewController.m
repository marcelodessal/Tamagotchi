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

@interface RankingViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *sortedRankingItems;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) MyPet *myPet;

@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.images = [[NSArray alloc] initWithObjects:@"ciervo_comiendo_1", @"gato_comiendo_1", @"leon_comiendo_1", @"jirafa_comiendo_1", nil];
    self.myPet = [MyPet sharedInstance];
    
    [self getRankingFromServer];

    [self.tableView registerNib:[UINib nibWithNibName:@"RankingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"rankingCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getRankingFromServer {
    
    NSString *rankingURLString = @"/pet/all";
    
    [[NetworkManager sharedInstance] GET:rankingURLString parameters:nil
                                 success:[self getSuccessHandler]
                                 failure:[self getErrorHandler]];
}

- (Success) getSuccessHandler {
    
    return ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *rankingItems = [[NSArray alloc] initWithArray:responseObject];
        
        NSSortDescriptor *sortByLevel = [NSSortDescriptor sortDescriptorWithKey:@"level" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByLevel];
        self.sortedRankingItems = [rankingItems sortedArrayUsingDescriptors:sortDescriptors];

        [self.tableView reloadData];
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
    NSDictionary *item = self.sortedRankingItems[indexPath.row];
    Pet *pet = [[Pet alloc] initWithDictionary:item];
    
    return [cell initWithPet:pet];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedRankingItems.count;
}


@end


