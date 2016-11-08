//
//  ViewController.m
//  LoginTest
//
//  Created by Heaven on 2016/11/8.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FacebookManager.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *emailLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake((width-150)/2, 60, 150, 150)];
    avatarView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:avatarView];
    self.avatarView = avatarView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((width-300)/2, 220, 300, 30)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake((width-300)/2, 265, 300, 30)];
    emailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:emailLabel];
    self.emailLabel = emailLabel;
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"Login With Facebook" forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(30, 420, width-60, 40);
    loginButton.layer.cornerRadius = 10.0f;
    loginButton.layer.masksToBounds = YES;
    loginButton.backgroundColor = [UIColor blueColor];
    [self.view addSubview:loginButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton addTarget:self action:@selector(shareButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setTitle:@"Share With Facebook" forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(30, 480, width-60, 40);
    shareButton.layer.cornerRadius = 10.0f;
    shareButton.layer.masksToBounds = YES;
    shareButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:shareButton];
}

- (void)login {

    [[FacebookManager sharedManager] facebookLoginSucccess:^(NSDictionary *fbinfoDict) {
        
        NSLog(@"%@", fbinfoDict);
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL  URLWithString:[fbinfoDict objectForKey:@"url"]]];
        self.avatarView.image = [UIImage imageWithData:imageData];
        self.nameLabel.text = [fbinfoDict objectForKey:@"name"];
        self.emailLabel.text = [fbinfoDict objectForKey:@"email"];
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error);

    }];
}

- (void)shareButtonDidClicked {

    [[FacebookManager sharedManager] shareContent:@"1111" handler:^(FacebookShareStatus status) {
        
    }
    showFromViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
