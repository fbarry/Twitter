//
//  ProfileViewController.m
//  twitter
//
//  Created by Fiona Barry on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "TTTAttributedLabel.h"
#import "LinkViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface ProfileViewController () <TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedIcon;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUser];
}

- (void)getUser {
    [[APIManager shared] getCurrentUser:^(User *user, NSError *error) {
        if (user) {
            self.user = user;
            [self setupView];
            NSLog(@"succes %@", user.name);
        } else {
            NSLog(@"😫😫😫 Error getting user: %@", error.localizedDescription);
        }
    }];
}

- (void) setupView {
    
    if (!self.user.isVerified) {
        [self.verifiedIcon setHidden:YES];
    }
    if (self.user.bannerURL) {
        [self.headerImage setImageWithURL:self.user.bannerURL];
    }
    if (self.user.profileImageURL) {
        [self.profileImage setImageWithURL:self.user.profileImageURL];
    }
    self.nameLabel.text = self.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    
    self.descriptionLabel.delegate = self;
    self.descriptionLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    [self.descriptionLabel setText:self.user.descriptionText];
    
     self.statsLabel.text = [NSString stringWithFormat:@"%d Tweets  %d Following  %d Followers", self.user.numTweets, self.user.numFollowing, self.user.numFollowers];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"DidSelectLink: %@", url);
    [self performSegueWithIdentifier:@"LinkClicked" sender:url];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"LinkClicked"]) {
        LinkViewController *linkViewController = [segue destinationViewController];
        linkViewController.link = sender;
    }
}

@end
