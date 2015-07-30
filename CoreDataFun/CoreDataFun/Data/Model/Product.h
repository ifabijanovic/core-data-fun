//
//  Product.h
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 31/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CartProduct;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSNumber * lastModified;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pictureUrl;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSDecimalNumber * unitWeight;
@property (nonatomic, retain) NSSet *cart;
@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addCartObject:(CartProduct *)value;
- (void)removeCartObject:(CartProduct *)value;
- (void)addCart:(NSSet *)values;
- (void)removeCart:(NSSet *)values;

@end
