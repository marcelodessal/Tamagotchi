//
//  DatabaseHelper.h
//  TamagotchiApp
//
//  Created by Marcelo Fabian Dessal on 12/3/14.
//  Copyright (c) 2014 Marcelo Fabian Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Pet.h"

@interface DatabaseHelper : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype) sharedInstance;
- (NSURL *)applicationDocumentsDirectory; // nice to have to reference files for core data
@end
