//
//  FoodCell.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/20/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *foodName;

@end
