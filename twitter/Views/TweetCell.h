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

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell <ButtonViewProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedIcon;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet ButtonView *replyButtonView;
@property (weak, nonatomic) IBOutlet ButtonView *retweetButtonView;
@property (weak, nonatomic) IBOutlet ButtonView *favorButtonView;
@property (weak, nonatomic) IBOutlet ButtonView *messageButtonView;

@property (strong, nonatomic) Tweet *tweet;

- (void)refreshCellWithTweet:(Tweet *)tweet;
- (void)didTapRetweet;
- (void)didTapFavor;

@end

NS_ASSUME_NONNULL_END
