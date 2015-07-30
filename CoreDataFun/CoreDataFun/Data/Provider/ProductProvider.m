//
//  ProductProvider.m
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 30/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import "ProductProvider.h"
#import <AFNetworking/AFNetworking.h>
#import "Product.h"

#define ENTITY_NAME @"Product"
#define URL_KEY @"Product Source URL"

@interface ProductProvider()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) BOOL hasChanges;

@end

@implementation ProductProvider

#pragma mark - Init

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (self = [super init]) {
        self.managedObjectContext = managedObjectContext;
        self.hasChanges = NO;
    }
    return self;
}

#pragma mark - Public methods

- (void)load {
    __block UIBackgroundTaskIdentifier task;
    __block BOOL shouldStop = NO;
    
    // Begin a background task so execution can continue even if user exits the app
    task = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        shouldStop = YES;
        [[UIApplication sharedApplication] endBackgroundTask:task];
        task = UIBackgroundTaskInvalid;
    }];
    
    // Perform loading in the background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
        NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:configPath];
        if (config) {
            NSString *url = [config objectForKey:URL_KEY];
            
            [[AFHTTPRequestOperationManager manager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *data = responseObject;
                NSArray *content = [data objectForKey:@"content"];
                if (content) {
                    for (NSDictionary *item in content) {
                        if (shouldStop) return;
                        [self insertOrUpdateItem:item];
                    }
                }
                
                if (self.hasChanges) {
                    [self.managedObjectContext save:nil];
                    self.hasChanges = NO;
                }
            } failure:nil];
        }
    });
}

#pragma mark - Private methods

- (void)insertOrUpdateItem:(NSDictionary *)item {
    NSString *productId = [item objectForKey:@"id"];
    Product *product = [self getProductWithId:productId];
    if (product) {
        [self updateProduct:product withData:item];
    } else {
        product = [self createProductWithData:item];
    }
}

- (Product *)getProductWithId:(NSString *)productId {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productId = %@", productId];
    [request setPredicate:predicate];
    
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:nil];
    return [result firstObject];
}

- (Product *)createProductWithData:(NSDictionary *)data {
    Product *product = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    
    product.productId = [data objectForKey:@"id"];
    [self fillProduct:product withData:data];
    
    return product;
}

- (void)updateProduct:(Product *)product withData:(NSDictionary *)data {
    NSNumber *lastModified = [data objectForKey:@"modifiedTmstp"];
    
    // Check if product was modified since last time
    if ([lastModified longValue] > [product.lastModified longValue]) {
        [self fillProduct:product withData:data];
    }
}

- (void)fillProduct:(Product *)product withData:(NSDictionary *)data {
    product.name = [data objectForKey:@"name"];
    product.desc = [data objectForKey:@"description"];
    product.currency = [data objectForKey:@"currency"];
    product.pictureUrl = [data objectForKey:@"pictureUrl"];
    
    NSNumber *price = [data objectForKey:@"price"];
    product.price = [NSDecimalNumber decimalNumberWithDecimal:[price decimalValue]];
    
    NSNumber *unitWeight = [data objectForKey:@"unitWeight"];
    product.unitWeight = [NSDecimalNumber decimalNumberWithDecimal:[unitWeight decimalValue]];
    
    product.lastModified = [data objectForKey:@"modifiedTmstp"];
    
    self.hasChanges = YES;
}

@end

