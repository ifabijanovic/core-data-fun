//
//  Cart.h
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 31/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CartProduct;

@interface Cart : NSManagedObject

@property (nonatomic, retain) NSNumber * isArchived;
@property (nonatomic, retain) NSSet *product;
@end

@interface Cart (CoreDataGeneratedAccessors)

- (void)addProductObject:(CartProduct *)value;
- (void)removeProductObject:(CartProduct *)value;
- (void)addProduct:(NSSet *)values;
- (void)removeProduct:(NSSet *)values;

@end
