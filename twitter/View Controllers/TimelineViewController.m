//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

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

@interface TimelineViewController () <UIScrollViewDelegate, TweetProtocol, ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barProfile;

@end

@implementation TimelineViewController

BOOL isMoreDataLoading = false;
InfiniteScrollActivityIndicator* loadingMoreView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tweets = [[NSMutableArray alloc] init];
    
    [self getUser];
    [self getTimeline];

    self.tableView.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl.tintColor = [UIColor colorWithRed:21.0f/255 green:180.0f/255  blue:1 alpha:1];
    
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityIndicator.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityIndicator alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.tableView addSubview:loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityIndicator.defaultHeight;
    self.tableView.contentInset = insets;
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

- (void)getTimeline {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = (NSMutableArray *)tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.tableView.refreshControl endRefreshing];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!isMoreDataLoading) {
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            isMoreDataLoading = true;
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityIndicator.defaultHeight);
            loadingMoreView.frame = frame;
            [loadingMoreView startAnimating];
            [self loadMoreData];
        }
    }
}

-(void)loadMoreData{
    [[APIManager shared] updateHomeTimelineAfter:self.tweets[self.tweets.count-1] withCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            isMoreDataLoading = false;
            [self.tweets addObjectsFromArray:tweets];
            [self.tableView reloadData];
            
            NSLog(@"%ld", self.tweets.count);
        } else {
            NSLog(@"😫😫😫 Error updating home timeline: %@", error.localizedDescription);
        }
        [loadingMoreView stopAnimating];
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
    
    if ([segue.identifier isEqualToString:@"Compose"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController *)navigationController.topViewController;
        composeController.delegate = self;
        composeController.type = STATUS_TWEET;
        composeController.user = self.user;
    }
    else if ([segue.identifier isEqualToString:@"Details"]) {
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
        composeViewController.delegate = self;
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

- (IBAction)didTapCompose:(id)sender {
    [self performSegueWithIdentifier:@"Compose" sender:self];
}

- (void)didTweet:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
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

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}


@end
