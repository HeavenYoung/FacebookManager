//
//  FacebookManager.m
//  LoginTest
//
//  Created by Heaven on 2016/11/8.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "FacebookManager.h"

@interface FacebookManager () <FBSDKSharingDelegate>

/** loginManager */
@property (nonatomic, strong) FBSDKLoginManager *loginManager;
@property (nonatomic, copy) FaceBookInfoSuccess successBlock;
@property (nonatomic, copy) FaceBookInfoFailure failureBlock;
@property (nonatomic, copy) FacebookShareStatusBlock statusBlock;

@end

@implementation FacebookManager

+ (instancetype)sharedManager {

    static FacebookManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FacebookManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        self.loginManager = loginManager;
    }
    return self;
}

#pragma mark -- Login/Logout Part
- (void)facebookLoginSucccess:(FaceBookInfoSuccess)success failure:(FaceBookInfoFailure)failure {
    
    self.successBlock = success;
    self.failureBlock = failure;
    
    // 权限
    NSArray *readPermissions = @[@"public_profile", @"email", @"user_birthday"];
    
    [self.loginManager logInWithReadPermissions:readPermissions fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            self.failureBlock(error);
            
        } else {
            
            // 判断本地缓存
            if ([FBSDKAccessToken currentAccessToken]) {
                
                [self extractUserProfile:CGSizeMake(200, 200)];
            } else {
            
                self.failureBlock(error);
            }
        }
    }];
}

// 用户信息
- (void)extractUserProfile:(CGSize)size {
    
    NSString *value = [NSString stringWithFormat:@"id, name, link, email, gender, birthday, picture.width(%d).height(%d)", (int)size.width, (int)size.height];
        
    NSDictionary *parameters = @{@"fields":value};
        
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me" parameters:parameters HTTPMethod:@"GET"];
        
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
        if (error) {
                
            self.failureBlock(error);
        
        } else {
            
            NSDictionary *fbDict = [self facebookInfoWithDict:result];
                
            self.successBlock(fbDict);
        }
    }];
}

- (NSDictionary *)facebookInfoWithDict:(NSDictionary *)dict {

    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    [mDict setObject:[dict objectForKey:@"birthday"] forKey:@"birthday"];
    [mDict setObject:[dict objectForKey:@"email"] forKey:@"email"];
    [mDict setObject:[dict objectForKey:@"gender"] forKey:@"gender"];
    [mDict setObject:[dict objectForKey:@"id"] forKey:@"id"];
    [mDict setObject:[dict objectForKey:@"link"] forKey:@"link"];
    [mDict setObject:[dict objectForKey:@"name"] forKey:@"name"];
    [mDict setObject:[[[dict objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]forKey:@"url"];

    return mDict.copy;
}

// Facebook登出
- (void)facebookLogout {
    [self.loginManager logOut];
}

#pragma mark -- Share Part
- (void)shareContent:(NSString *)link handler:(FacebookShareStatusBlock)status showFromViewController:(UIViewController *)controller {

    self.statusBlock = status;
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"http://developers.facebook.com"];
    [FBSDKShareDialog showFromViewController:controller withContent:content delegate:self];
}

#pragma mark -- FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    self.statusBlock(FacebookShareStatus_Completed);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    self.statusBlock(FacebookShareStatus_Failed);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    self.statusBlock(FacebookShareStatus_Unknow);
}

@end
