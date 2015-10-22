//
//  NewestObject.m
//  Demo
//
//  Created by he15his on 15/10/20.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import "JDNewestObject.h"

@implementation JDNewestObject

@dynamic title;
@dynamic score;
@dynamic content;
@dynamic imageUrls;

+ (NSString *)parseClassName {
    return @"JDNewestObject";
}
@end
