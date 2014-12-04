//
//  PetDatabaseHelper.m
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/3/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import "PetDatabaseHelper.h"

@implementation PetDatabaseHelper

#pragma mark - Dabatabe operations

+ (void)insertPet:(Pet *) newPet {
    
    NSManagedObjectContext *context = [[DatabaseHelper sharedInstance] managedObjectContext];
    
    NSError *localerror;
    if (![context save:&localerror]) { //Save changes in context.
        NSLog([NSString stringWithFormat:@"Error al guardar: %@", [localerror localizedDescription]]);
        [context rollback]; }
}

+(void)deleteAllPets {
    NSManagedObjectContext *context = [[DatabaseHelper sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pet" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * pets = [context executeFetchRequest:fetchRequest error:&error];
    
    //error handling goes here
    
    for (NSManagedObject * pet in pets) {
        [context deleteObject:pet];
    }
    
    NSError *saveError = nil;
    if (![context save:&saveError]) { //Guardamos los cambios en el contexto.
        NSLog([NSString stringWithFormat:@"Error al borrar: %@", [saveError localizedDescription]]);
        [context rollback];
    }
}


+(NSArray*)getPetRanking {
    NSManagedObjectContext *context = [[DatabaseHelper sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pet" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:50];
    
    NSSortDescriptor *sortByLevel = [NSSortDescriptor sortDescriptorWithKey:@"petLevel" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByLevel]];
    
    NSError *error;
    NSArray *ranking = [context executeFetchRequest:fetchRequest error:&error];
    
    
//    self.sortedRankingItems = [rankingItems sortedArrayUsingDescriptors:sortDescriptors];
    
    return ranking;
}

@end
