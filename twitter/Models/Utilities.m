//
//  Utilities.m
//  twitter
//
//  Created by Fiona Barry on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "Utilities.h"
#import "UIImageView+AFNetworking.h"

@implementation Utilities

+ (nonnull UITableViewCell *)initTweetCellWithTweet:(Tweet *)tweet
                                       forTableView:(nonnull UITableView *)tableView
                              cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
                    
    if (!tweet) {
        return cell;
    }
    
    cell.tweet = tweet;
    [cell.profilePicture setImageWithURL:tweet.user.profileImageURL];
    cell.nameLabel.text = tweet.user.name;
    [cell.verifiedIcon setHidden:!tweet.user.isVerified];
    cell.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    cell.dateLabel.text = tweet.createdAtString;
    cell.contentLabel.text = tweet.text;
    
    cell.replyCountLabel.text = nil;
    cell.retweetCountLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.favorCountLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    if (tweet.retweeted) {
        [cell.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon-green.png"]];
    }
    if (tweet.favorited) {
        [cell.favorIcon setImage:[UIImage imageNamed:@"favor-icon-red.png"]];
    }
    
    return cell;
    
//    @property (weak, nonatomic) IBOutlet UIImageView *replyIcon;
//    @property (weak, nonatomic) IBOutlet UILabel *replyCountLabel;
//    @property (weak, nonatomic) IBOutlet UIImageView *messageIcon;
}
    

@end
