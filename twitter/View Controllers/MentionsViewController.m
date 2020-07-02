//
//  MentionsViewController.m
//  twitter
//
//  Created by Fiona Barry on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "MentionsViewController.h"
#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DetailsViewController.h"
#import "LinkViewController.h"
#import "OtherUserViewController.h"
#import "InfiniteScrollActivityIndicator.h"
#import "ProfileViewController.h"

@interface MentionsViewController () <TweetProtocol, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;

@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = self.view.frame;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tweets = [[NSMutableArray alloc] init];
    
    [self getUser];
    [self getMentions];

    self.tableView.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView.refreshControl addTarget:self action:@selector(getMentions) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl.tintColor = [UIColor colorWithRed:21.0f/255 green:180.0f/255  blue:1 alpha:1];
}

- (void)getUser {
    [[APIManager shared] getCurrentUser:^(User *user, NSError *error) {
        if (user) {
            self.user = user;
        } else {
            NSLog(@"😫😫😫 Error getting user: %@", error.localizedDescription);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)getMentions {
    [[APIManager shared] getMentionsWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = (NSMutableArray *)tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting mentions timeline: %@", error.localizedDescription);
        }
        [self.tableView.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell.delegate = self;
    [cell refreshCellWithTweet:tweet];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Details"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweets[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
        detailsViewController.user = self.user;
    }
    else if ([segue.identifier isEqualToString:@"Reply"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeViewController = (ComposeViewController *)navigationController.topViewController;
        composeViewController.tweet = sender;
        composeViewController.type = REPLY_TWEET;
        composeViewController.user = self.user;
    }
    else if ([segue.identifier isEqualToString:@"LinkClicked"]) {
        LinkViewController *linkViewController = [segue destinationViewController];
        linkViewController.link = sender;
    }
    else if ([segue.identifier isEqualToString:@"OtherUser"]) {
        OtherUserViewController *otherUserViewController = [segue destinationViewController];
        otherUserViewController.user = sender;
    }
}

- (void)replyClicked:(Tweet *)tweet {
    [self performSegueWithIdentifier:@"Reply" sender:tweet];
}

- (void)linkClicked:(NSURL *)url {
    [self performSegueWithIdentifier:@"LinkClicked" sender:url];
}

- (void)didTapProfile:(User *)user {
    NSLog(@"going to segue");
    [self performSegueWithIdentifier:@"OtherUser" sender:user];
}

@end
