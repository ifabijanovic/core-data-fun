//
//  Product.h
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 30/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cart;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSDecimalNumber * unitWeight;
@property (nonatomic, retain) NSString * pictureUrl;
@property (nonatomic, retain) NSDate * lastModified;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSSet *carts;
@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addCartsObject:(Cart *)value;
- (void)removeCartsObject:(Cart *)value;
- (void)addCarts:(NSSet *)values;
- (void)removeCarts:(NSSet *)values;

@end
