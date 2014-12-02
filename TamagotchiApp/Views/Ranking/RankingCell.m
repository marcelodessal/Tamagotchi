//
//  RankingCell.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/28/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "RankingCell.h"
#import "MyPet.h"
#import "Pet.h"

@interface RankingCell()

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *level;
@property (strong, nonatomic) IBOutlet UIButton *btnMap;

@property (strong,nonatomic) Pet *pet;

@end

@implementation RankingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithPet:(Pet *)pet {

    self = [super init];
    if (self) {
        self.pet = pet;
        self.name.text = pet.petName;
        self.level.text = [NSString stringWithFormat:@"%i", pet.petLevel];
        [self.image setImage:[pet getDefaultImage]];
        
        MyPet *myPet = [MyPet sharedInstance];
        
        if ([pet.code isEqualToString:myPet.code]){
            self.backgroundColor = [UIColor grayColor];
        } else {
            self.backgroundColor = [UIColor whiteColor];
        }
    }
    return self;
}

-(void) fillDataWithPet:(Pet*) pet
{
    self.pet = pet;
    self.name.text = pet.petName;
    self.level.text = [NSString stringWithFormat:@"%i", pet.petLevel];
    [self.image setImage:[pet getDefaultImage]];
    
    MyPet *myPet = [MyPet sharedInstance];
    
    if ([pet.code isEqualToString:myPet.code]){
        self.backgroundColor = [UIColor grayColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (IBAction)showMap:(id)sender {
    if (self.delegate) {
        [self.delegate didSelectPetMap:self.pet];
    }
}
@end
