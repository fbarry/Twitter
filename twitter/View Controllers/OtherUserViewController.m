//
//  OtherUserViewController.m
//  twitter
//
//  Created by Fiona Barry on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "OtherUserViewController.h"
#import "TTTAttributedLabel.h"
#import "UIImageView+AFNetworking.h"
#import "LinkViewController.h"

@interface OtherUserViewController () <TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedIcon;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statsLabel;

@end

@implementation OtherUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"LinkClicked"]) {
        LinkViewController *linkViewController = [segue destinationViewController];
        linkViewController.link = sender;
    }
}

@end
