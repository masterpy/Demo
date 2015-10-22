//
//  NewestTableViewCell.m
//  Demo
//
//  Created by he15his on 15/10/20.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import "JDNewestTableViewCell.h"
#import "JDNewestObject.h"
#import "JDDateFormatter.h"
#import "JDNewestPhotoView.h"

@interface JDNewestTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *dateContentView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (weak, nonatomic) IBOutlet JDNewestPhotoView *photoView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *scoreContentView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabetToTopConstraint;

@end

@implementation JDNewestTableViewCell

- (void)configCellDataWithObject:(JDNewestObject *)object showDate:(BOOL)showDate {
    self.dateContentView.hidden = !showDate;
    
    if (showDate) {
        NSDateFormatter *formatter = [JDDateFormatter shareInstance];
        formatter.dateFormat = @"dd";
        self.dayLabel.text = [formatter stringFromDate:object.createdAt];
        formatter.dateFormat = @"MM";
        self.monthLabel.text = [NSString stringWithFormat:@"%@月", [formatter stringFromDate:object.createdAt]];
    }
    
    [self.photoView configViewDataWithObject:object];
    self.titleLabel.text = object.title;
    self.descriptionLabel.text = object.content;
    
    if (object.score > 0) {
        self.scoreContentView.hidden = NO;
        self.scoreLabel.text = [NSString stringWithFormat:@"%.1f", object.score];
        self.contentLabetToTopConstraint.constant = 5;
    }else {
        self.scoreContentView.hidden = YES;
        self.contentLabetToTopConstraint.constant = -16;
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
