//
//  Pet.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/21/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Pet : NSObject
@property (strong, nonatomic) NSString *petName;
@property (strong, nonatomic) UIImage *petImage;
@property (strong, nonatomic) NSString *petType;

+ (instancetype) sharedInstance;
- (instancetype)setInitialName:(NSString*) name andImage:(UIImage*) image andType:(NSString *) type;
- (int) getEnergy;
- (void) eat;
- (void) exercise;
@end
