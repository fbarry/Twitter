//
//  TweetCell.m
//  twitter
//
//  Created by Fiona Barry on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "DateTools.h"

@implementation TweetCell

- (void)refreshCellWithTweet:(Tweet *)tweet {
    
    self.replyButtonView.delegate = self;
    self.retweetButtonView.delegate = self;
    self.messageButtonView.delegate = self;
    self.favorButtonView.delegate = self;
    
    self.replyButtonView.type = REPLY;
    self.retweetButtonView.type = RETWEET;
    self.messageButtonView.type = MESSAGE;
    self.favorButtonView.type = FAVOR;
    
    self.tweet = tweet;
    [self.profilePicture setImageWithURL:tweet.user.profileImageURL];
    self.nameLabel.text = tweet.user.name;
    [self.verifiedIcon setHidden:!tweet.user.isVerified];
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    self.contentLabel.text = tweet.text;
    self.dateLabel.text = [NSDate shortTimeAgoSinceDate:self.tweet.createdDate];
                          
    self.replyButtonView.countLabel.text = nil;
    self.messageButtonView.countLabel.text = nil;
    self.retweetButtonView.countLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    self.favorButtonView.countLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    [self.retweetButtonView.buttonIcon setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    [self.replyButtonView.buttonIcon setImage:[UIImage imageNamed:@"reply-icon.png"] forState:UIControlStateNormal];
    [self.messageButtonView.buttonIcon setImage:[UIImage imageNamed:@"message-icon.png"] forState:UIControlStateNormal];
    [self.favorButtonView.buttonIcon setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    
    if (tweet.retweeted) {
        self.retweetButtonView.countLabel.textColor = [UIColor greenColor];
        [self.retweetButtonView.buttonIcon setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    if (tweet.favorited) {
        self.favorButtonView.countLabel.textColor = [UIColor redColor];
        [self.favorButtonView.buttonIcon setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
}

- (void)didTapRetweet {
    if (!self.tweet.retweeted) {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error reweet tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.retweeted = YES;
                self.tweet.retweetCount++;
                self.retweetButtonView.countLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
                self.retweetButtonView.countLabel.textColor = [UIColor greenColor];
                [self.retweetButtonView.buttonIcon setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
            }
        }];
    }
//    else {
//        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
//            if(error){
//                 NSLog(@"Error unretweet tweet: %@", error.localizedDescription);
//            }
//            else{
//                self.tweet.retweeted = NO;
//                self.tweet.retweetCount--;
//                self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
//                self.retweetCountLabel.textColor = [UIColor darkGrayColor];
//                [self.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
//            }
//        }];
//    }
}

- (void)didTapFavor {
    if (!self.tweet.favorited) {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.favorited = YES;
                self.tweet.favoriteCount++;
                self.favorButtonView.countLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
                self.favorButtonView.countLabel.textColor = [UIColor redColor];
                [self.favorButtonView.buttonIcon setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
            }
        }];
    }
//    else {
//        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
//            if(error){
//                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
//            }
//            else{
//                self.tweet.favorited = NO;
//                self.tweet.favoriteCount--;
//                self.favorCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
//                self.favorCountLabel.textColor = [UIColor darkGrayColor];
//                [self.favorIcon setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
//            }
//        }];
//    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
