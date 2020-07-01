//
//  DetailsViewController.m
//  twitter
//
//  Created by Fiona Barry on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "APIManager.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedIcon;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCommentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favorCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyIcon;
@property (weak, nonatomic) IBOutlet UIButton *retweetIcon;
@property (weak, nonatomic) IBOutlet UIButton *favorIcon;
@property (weak, nonatomic) IBOutlet UIButton *messageIcon;
//@property (strong, nonatomic) NSString *months = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.profilePicture setImageWithURL:self.tweet.user.profileImageURL];
    self.nameLabel.text = self.tweet.user.name;
    [self.verifiedIcon setHidden:!self.tweet.user.isVerified];
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.contentLabel.text = self.tweet.text;
    
    self.dateLabel.text = [NSString stringWithFormat:@"%ld %ld %ld", self.tweet.createdDate.day, self.tweet.createdDate.month, self.tweet.createdDate.year];
               
    self.retweetCommentCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favorCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    if (self.tweet.retweeted) {
        [self.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    if (self.tweet.favorited) {
        [self.favorIcon setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    if (!self.tweet.retweeted) {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error reweet tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.retweeted = YES;
                self.tweet.retweetCount++;
                self.retweetCommentCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
                [self.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
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

- (IBAction)didTapFavor:(id)sender {
    if (!self.tweet.favorited) {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.favorited = YES;
                self.tweet.favoriteCount++;
                self.favorCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
                [self.favorIcon setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
