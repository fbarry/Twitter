//
//  TweetCell.h
//  twitter
//
//  Created by Fiona Barry on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedIcon;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favorCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyIcon;
@property (weak, nonatomic) IBOutlet UIButton *retweetIcon;
@property (weak, nonatomic) IBOutlet UIButton *favorIcon;
@property (weak, nonatomic) IBOutlet UIButton *messageIcon;

@property (strong, nonatomic) Tweet *tweet;

- (void)refreshCellWithTweet:(Tweet *)tweet;
- (IBAction)didTapRetweet:(id)sender;
- (IBAction)didTapFavor:(id)sender;

@end

NS_ASSUME_NONNULL_END
