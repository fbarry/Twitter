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
#import "ButtonView.h"
#import "TTTAttributedLabel.h"
#import "ComposeViewController.h"
#import "User.h"
#import "LinkViewController.h"
#import "OtherUserViewController.h"

@interface DetailsViewController () <ButtonViewProtocol, TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedIcon;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCommentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favorCountLabel;
@property (weak, nonatomic) IBOutlet ButtonView *replyButtonView;
@property (weak, nonatomic) IBOutlet ButtonView *retweetButtonView;
@property (weak, nonatomic) IBOutlet ButtonView *favorButtonView;
@property (weak, nonatomic) IBOutlet ButtonView *messageButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (strong, nonatomic) NSArray *months;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profileTapped:)];
       [self.profilePicture addGestureRecognizer:profileTapGestureRecognizer];
       [self.profilePicture setUserInteractionEnabled:YES];
    
    self.months = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    
    self.replyButtonView.delegate = self;
    self.favorButtonView.delegate = self;
    self.messageButtonView.delegate = self;
    self.retweetButtonView.delegate = self;
    
    [self.profilePicture setImageWithURL:self.tweet.user.profileImageURL];
    self.nameLabel.text = self.tweet.user.name;
    [self.verifiedIcon setHidden:!self.tweet.user.isVerified];
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    
    self.contentLabel.delegate = self;
    self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    [self.contentLabel setText:self.tweet.text];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", self.tweet.createdDate.hour, self.tweet.createdDate.minute];
    self.dateLabel.text = [NSString stringWithFormat:@"%ld %@ %ld", self.tweet.createdDate.day, self.months[self.tweet.createdDate.month-1], self.tweet.createdDate.year];
               
    self.retweetCommentCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favorCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    self.messageButtonView.type = MESSAGE;
    self.replyButtonView.type = REPLY;
    self.retweetButtonView.type = RETWEET;
    self.favorButtonView.type = FAVOR;
    
    self.messageButtonView.countLabel.text = nil;
    self.retweetButtonView.countLabel.text = nil;
    self.favorButtonView.countLabel.text = nil;
    self.replyButtonView.countLabel.text = nil;
    
    [self.replyButtonView.buttonIcon setImage:[UIImage imageNamed:@"reply-icon.png"] forState:UIControlStateNormal];
    [self.messageButtonView.buttonIcon setImage:[UIImage imageNamed:@"message-icon.png"] forState:UIControlStateNormal];

    if (self.tweet.postImage) {
        [self.postImage setImageWithURL:self.tweet.postImage];
    }
    else {
        [self.postImage removeFromSuperview];
    }
    if (self.tweet.retweeted) {
        [self.retweetButtonView.buttonIcon setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    else {
        [self.retweetButtonView.buttonIcon setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    }
    if (self.tweet.favorited) {
        [self.favorButtonView.buttonIcon setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
    else {
        [self.favorButtonView.buttonIcon setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"DidSelectLink: %@", url);
    [self performSegueWithIdentifier:@"LinkClicked" sender:url];
}

- (void)didTapRetweet {
    
    NSLog(@"Retweet called");
    
    if (!self.tweet.retweeted) {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error reweet tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.retweeted = YES;
                self.tweet.retweetCount++;
                self.retweetCommentCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
                [self.retweetButtonView.buttonIcon setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
            }
        }];
    }
    else {
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweet tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.retweeted = NO;
                self.tweet.retweetCount--;
                self.retweetButtonView.countLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
                self.retweetButtonView.countLabel.textColor = [UIColor darkGrayColor];
                [self.retweetButtonView.buttonIcon setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
            }
        }];
    }
}

- (void)didTapFavor {
    
    NSLog(@"Favor called");
    
    if (!self.tweet.favorited) {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.favorited = YES;
                self.tweet.favoriteCount++;
                self.favorCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
                [self.favorButtonView.buttonIcon setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
            }
        }];
    }
    else {
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.favorited = NO;
                self.tweet.favoriteCount--;
                self.favorButtonView.countLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
                self.favorButtonView.countLabel.textColor = [UIColor darkGrayColor];
                [self.favorButtonView.buttonIcon setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
            }
        }];
    }
}

- (IBAction)replyTabButton:(id)sender {
    [self performSegueWithIdentifier:@"Reply" sender:self];
}

- (void)didTapReply {
    NSLog(@"didTapReply");
    [self performSegueWithIdentifier:@"Reply" sender:self];
}

- (void)profileTapped:(UITapGestureRecognizer *)sender  {
    [self performSegueWithIdentifier:@"OtherUser" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Reply"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeViewController = (ComposeViewController *)navigationController.topViewController;
        composeViewController.tweet = self.tweet;
        composeViewController.type = REPLY_TWEET;
        composeViewController.user = self.user;
    }
    else if ([segue.identifier isEqualToString:@"LinkClicked"]) {
        LinkViewController *linkViewController = [segue destinationViewController];
        linkViewController.link = sender;
    }
    else if ([segue.identifier isEqualToString:@"OtherUser"]) {
        OtherUserViewController *otherUserViewController = [segue destinationViewController];
        otherUserViewController.user = self.tweet.user;
    }
}

@end
