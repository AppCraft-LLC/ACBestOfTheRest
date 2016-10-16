//
//  UIRemoteCollectionView.m
//  ACBestOfTheRest
//
//  Created by Alexander Murzanaev on 30.11.14.
//  Copyright (c) 2014 AppCraft. All rights reserved.
//

#import "BOTRCollectionView.h"

static NSString *limitKey;
static NSString *offsetKey;

@interface BOTRCollectionView ()

@property (nonatomic) BOOL activityFooterView;
@property (nonatomic) unsigned int offset;
@property (nonatomic) BOOL enoughData;
@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation BOTRCollectionView

+ (void)initialize {
    limitKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"API Paging Limit Key"];
    offsetKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"API Paging Offset Key"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        self.showLoading = YES;
    }
    return self;
}

- (void)loadData {
    
    NSAssert(self.urlPath, @"Please specify BOTRCollectionView's urlPath");
    NSAssert(self.chunkSize > 0, @"Please specify BOTRCollectionView's chunkSize");
    NSAssert(self.dataArray, @"Please specify BOTRCollectionView's dataArray");
    
    [self.dataArray removeAllObjects];
    [self reloadData];
    if (self.placeholderLabel) self.placeholderLabel.hidden = YES;
    self.offset = 0;
    self.enoughData = NO;
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (offsetKey && limitKey) {
        params[offsetKey] = @(self.offset);
        params[limitKey] = @(self.chunkSize);
    }
    if (self.queryParams)
        [params addEntriesFromDictionary:self.queryParams];
    
    [BOTRCore mapRequest:self.urlPath parameters:params onCollectionView:self dataArray:self.dataArray arrayExtractor:^NSArray *(id response) {
        NSArray *array = [BOTRCore extractDataArrayFromObject:response fromPath:self.dataPath];
        if (array == nil || ![array isKindOfClass:[NSArray class]]) return @[];
        self.offset += (unsigned int)array.count;
        self.enoughData = array.count < self.chunkSize;
        if (self.placeholderLabel && array.count) self.placeholderLabel.hidden = NO;
        return array;
    } animated:self.showLoading];
}

- (void)needMoreData {
    if (self.activityFooterView || self.enoughData) return;
    self.activityFooterView = YES;
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (offsetKey && limitKey) {
        params[offsetKey] = @(self.offset);
        params[limitKey] = @(self.chunkSize);
    }
    if (self.queryParams)
        [params addEntriesFromDictionary:self.queryParams];
    
    [BOTRCore get:self.urlPath parameters:params completion:^(id response) {
        if (response) {
            NSArray *array = [BOTRCore extractDataArrayFromObject:response fromPath:self.dataPath];
            if (array && [array isKindOfClass:[NSArray class]]) {
                self.offset += (unsigned int)array.count;
                self.activityFooterView = NO;
                [self.dataArray addObjectsFromArray:array];
                self.enoughData = array.count < self.chunkSize;
            }
        }
        [self reloadData];
    }];
}

- (void)reloadData {
    [super reloadData];
    [self adjustPlaceholder];
}

- (void)reloadSections:(NSIndexSet *)sections {
    [super reloadSections:sections];
    [self adjustPlaceholder];
}

- (void)adjustPlaceholder {
    if (self.placeholder && (([self numberOfSections] == 1 && [self numberOfItemsInSection:0] == 0) || ([self numberOfSections] == 2 && [self numberOfItemsInSection:0] == 0 && [self numberOfItemsInSection:1] == 0))) {
        [self addPlaceholderLabel];
    }
    else
        [self removePlaceholderLabel];
}

- (void)setPlaceholderIsHidden:(BOOL)placeholderIsHidden {
    _placeholderIsHidden = placeholderIsHidden;
    for (UIView *view in self.subviews)
        if ([view isMemberOfClass:[UILabel class]]) {
            view.hidden = placeholderIsHidden;
            break;
        }
}

- (void)addPlaceholderLabel {
    [self removePlaceholderLabel];
    CGRect frame = self.frame;
    float xOfst = self.bounds.origin.x;
    float yOfst = self.bounds.origin.y;
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + xOfst, frame.size.height + yOfst);
    UILabel* placeholderLabel = [[UILabel alloc] initWithFrame:CGRectInset(frame, 20, 20)];
    placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    placeholderLabel.textAlignment = NSTextAlignmentCenter;
    placeholderLabel.backgroundColor = [UIColor clearColor];
    placeholderLabel.text = self.placeholder;
    placeholderLabel.font = [UIFont systemFontOfSize:13];
    placeholderLabel.textColor = [UIColor lightGrayColor];
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.preferredMaxLayoutWidth = placeholderLabel.frame.size.width;
    placeholderLabel.center = CGPointMake(self.frame.size.width / 2 + xOfst / 2, self.frame.size.height / 2 + yOfst / 2);
    [self addSubview:placeholderLabel];
    NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraint:xCenterConstraint];
    NSLayoutConstraint *yCenterConstraint = [NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self addConstraint:yCenterConstraint];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:30];
    [self addConstraint:leftConstraint];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:30];
    [self addConstraint:rightConstraint];
    [self setPlaceholderIsHidden:_placeholderIsHidden];
    self.placeholderLabel = placeholderLabel;
}

- (void)removePlaceholderLabel {
    if (self.placeholderLabel) {
        [self.placeholderLabel removeFromSuperview];
        self.placeholderLabel = nil;
    }
}

- (void)beginLoading {
    [self endLoading];
    if (self.visibleCells.count == 0) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:activityIndicatorView];
        NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [self addConstraint:xCenterConstraint];
        NSLayoutConstraint *yCenterConstraint = [NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self addConstraint:yCenterConstraint];
        [activityIndicatorView startAnimating];
    }
}

- (void)endLoading {
    for (UIView *view in self.subviews)
        if ([view isMemberOfClass:[UIActivityIndicatorView class]]) {
            [view removeFromSuperview];
            break;
        }
}

@end
