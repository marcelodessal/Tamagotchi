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
#import "NetworkManager.h"

@interface RankingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RankingViewController {
    NSArray *rankingItems;
    NSArray *sortedRankingItems;
    
    NSArray *images;
    Pet *myPet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    myPet = [Pet sharedInstance];
    
    images = [[NSArray alloc] initWithObjects:@"ciervo_comiendo_1", @"gato_comiendo_1", @"leon_comiendo_1", @"jirafa_comiendo_1", nil];
    
    NSDictionary *user1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"MD8462",@"code",@"Fred",@"name", @"0",@"pet_type", @"2",@"level", nil];
    NSDictionary *user2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"AR7666",@"code",@"Bob",@"name", @"2",@"pet_type", @"1",@"level", nil];
    NSDictionary *user3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"NN9999",@"code",@"Greg",@"name", @"3",@"pet_type", @"3",@"level", nil];
    
    rankingItems = [[NSArray alloc] initWithObjects:user1, user2, user3, nil];
    
    NSSortDescriptor *sortByLevel = [NSSortDescriptor sortDescriptorWithKey:@"level" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByLevel];
    sortedRankingItems = [rankingItems sortedArrayUsingDescriptors:sortDescriptors];
    
    [self getRankingFromServer];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RankingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"rankingCell"];
    
    [self.tableView reloadData];

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
        //self.rankingList = [[NSArray alloc] initWithArray:(NSArray *)responseObject];
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
    NSDictionary *item = sortedRankingItems[indexPath.row];
    
    if ([[item objectForKey:@"code"] isEqualToString:myPet.code]){
        cell.backgroundColor = [UIColor grayColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.name.text = [item objectForKey:@"name"];
    
    int index = [[item objectForKey:@"pet_type"] intValue];
    [cell.image setImage:[UIImage imageNamed:images[index]]];
    
    cell.level.text = [item objectForKey:@"level"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    long rows = rankingItems.count;
    return rows;
}


@end


