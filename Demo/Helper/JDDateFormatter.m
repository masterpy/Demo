//
//  JDDateFormatter.m
//  Demo
//
//  Created by he15his on 15/10/20.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import "JDDateFormatter.h"

@implementation JDDateFormatter

+ (instancetype)shareInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}
@end
