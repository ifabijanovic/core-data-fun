//
//  CartProduct.h
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 31/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cart, Product;

@interface CartProduct : NSManagedObject

@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSDecimalNumber * unitPrice;
@property (nonatomic, retain) Cart *cart;
@property (nonatomic, retain) Product *product;

@end
