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
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *rankingItems;
@property (strong, nonatomic) NSArray *sortedRankingItems;

@end

@implementation RankingViewController {
    NSArray *images;
    Pet *myPet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    myPet = [Pet sharedInstance];
    
    images = [[NSArray alloc] initWithObjects:@"ciervo_comiendo_1", @"gato_comiendo_1", @"leon_comiendo_1", @"jirafa_comiendo_1", nil];
    
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
        self.rankingItems = [[NSArray alloc] initWithArray:responseObject];
        
        NSSortDescriptor *sortByLevel = [NSSortDescriptor sortDescriptorWithKey:@"level" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByLevel];
        self.sortedRankingItems = [self.rankingItems sortedArrayUsingDescriptors:sortDescriptors];

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
    
    if ([[item objectForKey:@"code"] isEqualToString:myPet.code]){
        cell.backgroundColor = [UIColor grayColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.name.text = [item objectForKey:@"name"];
    
    int imagesArrayIndex = [[item objectForKey:@"pet_type"] intValue];
    [cell.image setImage:[UIImage imageNamed:images[imagesArrayIndex]]];
    cell.level.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"level"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedRankingItems.count;
}


@end


