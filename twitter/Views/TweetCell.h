//
//  TweetCell.h
//  twitter
//
//  Created by Fiona Barry on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "ButtonView.h"
#import "TTTAttributedLabel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TweetProtocol <NSObject>

- (void)replyClicked:(Tweet *)tweet;
- (void)linkClicked:(NSURL *)url;

@end

@interface TweetCell : UITableViewCell <ButtonViewProtocol, TTTAttributedLabelDelegate>

@property (nonatomic, weak) id <TweetProtocol> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedIcon;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic) IBOutlet ButtonView *replyButtonView;
@property (weak, nonatomic) IBOutlet ButtonView *retweetButtonView;
@property (weak, nonatomic) IBOutlet ButtonView *favorButtonView;
@property (weak, nonatomic) IBOutlet ButtonView *messageButtonView;

@property (strong, nonatomic) Tweet *tweet;

- (void)refreshCellWithTweet:(Tweet *)tweet;
- (void)didTapRetweet;
- (void)didTapFavor;
- (void)didTapReply;

@end

NS_ASSUME_NONNULL_END
