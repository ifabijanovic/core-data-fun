//
//  ProductTableViewController.h
//  CoreDataFun
//
//  Created by Ivan Fabijanovic on 30/07/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ProductProvider.h"
#import "CartProvider.h"

@interface ProductTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, retain) ProductProvider *productProvider;
@property (nonatomic, retain) CartProvider *cartProvider;

@end
