//
//  JDAddCasusTableViewController.h
//  Demo
//
//  Created by he15his on 15/10/22.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDNewestObject;
typedef void(^AddSuccessBlock)(JDNewestObject *object);

@interface JDAddCasusTableViewController : UITableViewController
@property (nonatomic, strong)  AddSuccessBlock addSuccessBlock;

@end
