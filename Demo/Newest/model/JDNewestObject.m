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

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        self.title =  [aDecoder decodeObjectForKey:@"title"];
        self.score =  [aDecoder decodeFloatForKey:@"score"];
        self.content =  [aDecoder decodeObjectForKey:@"content"];
        self.imageUrls =  [aDecoder decodeObjectForKey:@"imageUrls"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeFloat:self.score forKey:@"score"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.imageUrls forKey:@"imageUrls"];
}
@end
