//
//  CartProvider.h
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 31/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Product.h"
#import "Cart.h"

@interface CartProvider : NSObject

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (void)addProduct:(Product *)product quantity:(int)quantity;
- (NSArray *)getProductsInCart;
- (void)removeProduct:(CartProduct *)cartProduct;

@end
