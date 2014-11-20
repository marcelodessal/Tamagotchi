//
//  SelectFoodViewController.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/20/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"

@protocol SelectFoodDelegate <NSObject>

-(void) didSelectFood:(Food *) foodItem;

@end

@interface SelectFoodViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,weak) id <SelectFoodDelegate> delegate;
@end
