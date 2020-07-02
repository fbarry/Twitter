//
//  ComposeViewController.h
//  twitter
//
//  Created by Fiona Barry on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    REPLY_TWEET,
    STATUS_TWEET
} ComposeType;

@protocol ComposeViewControllerDelegate

- (void)didTweet;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Tweet *tweet;
@property (nonatomic) ComposeType type;

@end

NS_ASSUME_NONNULL_END
