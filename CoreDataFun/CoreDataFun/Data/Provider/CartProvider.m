//
//  CartProvider.m
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 31/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import "CartProvider.h"
#import "CartProduct.h"
#import "Constants.h"

#define CART_ENTITY_NAME @"Cart"
#define CART_PRODUCT_ENTITY_NAME @"CartProduct"

@interface CartProvider()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Cart *cart;

@end

@implementation CartProvider

#pragma mark - Init

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (self = [super init]) {
        self.managedObjectContext = managedObjectContext;
        
        Cart *activeCart = [self getActiveCart];
        self.cart = activeCart ? activeCart : [self createNewCart];
    }
    return self;
}

#pragma mark - Public methods

- (void)addProduct:(Product *)product quantity:(int)quantity {
    BOOL exists = NO;
    for (CartProduct *cartProduct in self.cart.product) {
        if ([cartProduct.product isEqual:product]) {
            cartProduct.quantity = [NSNumber numberWithInt:[cartProduct.quantity intValue] + quantity];
            exists = YES;
            break;
        }
    }
    
    if (!exists) {
        CartProduct *cartProduct = [NSEntityDescription insertNewObjectForEntityForName:CART_PRODUCT_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
        cartProduct.product = product;
        cartProduct.cart = self.cart;
        cartProduct.quantity = [NSNumber numberWithInt:quantity];
        cartProduct.unitPrice = product.price;
    }
    
    if (self.managedObjectContext.hasChanges) {
        [self.managedObjectContext save:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:CART_CHANGED_NOTIFICATION object:self];
    }
}

- (NSArray *)getProductsInCart {
    return self.cart ? [self.cart.product allObjects] : [NSArray array];
}

- (void)removeProduct:(CartProduct *)cartProduct {
    [self.managedObjectContext deleteObject:cartProduct];
    [self.managedObjectContext save:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:CART_CHANGED_NOTIFICATION object:self];
}

#pragma mark - Private methods

- (Cart *)getActiveCart {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:CART_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isArchived == NO"];
    [request setPredicate:predicate];
    
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:nil];
    return [result firstObject];
}

- (Cart *)createNewCart {
    Cart *cart = [NSEntityDescription insertNewObjectForEntityForName:CART_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    
    cart.isArchived = [NSNumber numberWithBool:NO];
    
    [self.managedObjectContext save:nil];
    
    return cart;
}

@end
