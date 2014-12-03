//
//  RankingCell.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/28/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"

@protocol RankingCellDelegate <NSObject>

- (void)didSelectPetMap:(Pet*)pet;

@end

@interface RankingCell : UITableViewCell

@property (weak, nonatomic) id <RankingCellDelegate> delegate;

-(void) fillDataWithPet:(Pet*) pet;

@end
