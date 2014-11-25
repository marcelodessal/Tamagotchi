//
//  SelectFoodViewController.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/20/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "SelectFoodViewController.h"
#import "FoodCell.h"
#import "ShowEnergyViewController.h"
#import "Food.h"

@interface SelectFoodViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SelectFoodViewController {
    //NSArray *foodItems;
    NSMutableArray *foodItems;
    NSDictionary *foodList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Food" withExtension:@"plist"];
    foodList = [NSDictionary dictionaryWithContentsOfURL:url];
    foodItems = [[NSMutableArray alloc] init];
    
    for (id key in foodList) {
        Food *item = [[Food alloc] initWithName:key withImage:foodList[key]];
        [foodItems addObject:item];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FoodCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"foodCell"];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *foodCellIdentifier = @"foodCell";
    FoodCell *cell = [tableView dequeueReusableCellWithIdentifier:foodCellIdentifier];
    
    if (!cell) {
        cell = [[FoodCell alloc] init];
    }
    
    cell.foodName.text = [foodItems[indexPath.row] foodName];
    [cell.image setImage:[UIImage imageNamed:[foodItems[indexPath.row] foodImage]]];
    int energyValue = [foodItems[indexPath.row] foodEnergy];
    NSString *energy = [NSString stringWithFormat:@"Energía: +%i", energyValue];
    cell.lblfoodEnergy.text = energy;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return foodItems.count;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectFood:foodItems[indexPath.row]];
}



@end
