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
    NSArray *foodItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    foodItems = [[NSArray alloc] initWithObjects:
                 [[Food alloc] initWithName:@"Tarta" withImage:@"comida_0"],
                 [[Food alloc] initWithName:@"Torta" withImage:@"comida_1"],
                 [[Food alloc] initWithName:@"Helado" withImage:@"comida_2"],
                 [[Food alloc] initWithName:@"Pollo" withImage:@"comida_3"],
                 [[Food alloc] initWithName:@"Hamburguesa" withImage:@"comida_4"],
                 [[Food alloc] initWithName:@"Pescado" withImage:@"comida_5"],
                 [[Food alloc] initWithName:@"Fruta" withImage:@"comida_6"],
                 [[Food alloc] initWithName:@"Salchicha" withImage:@"comida_7"],
                 [[Food alloc] initWithName:@"Pan" withImage:@"comida_8"],nil];
   
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
