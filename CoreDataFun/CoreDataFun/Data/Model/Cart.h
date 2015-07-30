//
//  Cart.h
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 30/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface Cart : NSManagedObject

@property (nonatomic, retain) NSSet *items;
@end

@interface Cart (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Product *)value;
- (void)removeItemsObject:(Product *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
