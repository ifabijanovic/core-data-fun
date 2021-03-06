//
//  AppDelegate.h
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 30/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ProductProvider.h"
#import "CartProvider.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, nonatomic) ProductProvider *productProvider;
@property (readonly, strong, nonatomic) CartProvider *cartProvider;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

