//
//  Food.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 11/20/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject
@property (strong, nonatomic) NSString *foodImage;
@property (strong, nonatomic) NSString *foodName;

- (instancetype)initWithName:(NSString*) name withImage:(NSString*) image;

@end
