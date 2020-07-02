//
//  ButtonView.m
//  twitter
//
//  Created by Fiona Barry on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ButtonView.h"

@implementation ButtonView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (void)customInit {
    [[NSBundle mainBundle] loadNibNamed:@"ButtonViewXIB" owner:self options:nil];
    [self addSubview:self.buttonView];
    self.buttonView.frame = self.bounds;
}

- (IBAction)didTapButton:(id)sender {
    NSLog(@"Button clicked");
    
    switch (self.type) {
        case RETWEET:
            [self.delegate didTapRetweet];
            break;
        case FAVOR:
            [self.delegate didTapFavor];
            break;
        case REPLY:
            [self.delegate didTapReply];
            break;
        default:
            NSLog(@"NONE");
    }
}

@end
