//
//  RankingViewController.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/28/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingCell.h"

@interface RankingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RankingCellDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
