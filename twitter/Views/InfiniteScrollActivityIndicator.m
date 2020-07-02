//
//  InfiniteScrollActivityIndicator.m
//  twitter
//
//  Created by Fiona Barry on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "InfiniteScrollActivityIndicator.h"

@implementation InfiniteScrollActivityIndicator

UIActivityIndicatorView* activityIndicatorView;

static CGFloat _defaultHeight = 60.0;

+ (CGFloat)defaultHeight {
    return _defaultHeight;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setupActivityIndicator];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        [self setupActivityIndicator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)setupActivityIndicator {
    activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicatorView.color = [UIColor colorWithRed:21.0f/255 green:180.0f/255  blue:1 alpha:1];
    activityIndicatorView.hidesWhenStopped = true;
    [self addSubview:activityIndicatorView];
}

-(void)stopAnimating {
    [activityIndicatorView stopAnimating];
    self.hidden = true;
}

-(void)startAnimating {
    self.hidden = false;
    [activityIndicatorView startAnimating];
}

@end
