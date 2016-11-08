//
//  FacebookManager.h
//  LoginTest
//
//  Created by Heaven on 2016/11/8.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

typedef NS_ENUM(NSInteger, FacebookShareStatus)
{
    FacebookShareStatus_Unknow,
    FacebookShareStatus_Completed,
    FacebookShareStatus_Failed
};
typedef void(^FacebookShareStatusBlock) (FacebookShareStatus status);

typedef void(^FaceBookInfoSuccess)(NSDictionary *fbinfoDict);
typedef void(^FaceBookInfoFailure)(NSError *error);

@interface FacebookManager : NSObject

/**
 单例构造方法

 @return FacebookManager
 */
+ (instancetype)sharedManager;

#pragma mark -- Login/Logout Part
/**
 Facebook 登入

 @param success 成功回调
 @param failure 失败回调
 */
- (void)facebookLoginSucccess:(FaceBookInfoSuccess)success failure:(FaceBookInfoFailure)failure;

/**
 FaceBook 登出
 */
- (void)facebookLogout;

#pragma mark -- Share Part

/**
 Facebook 分享

 @param link 分享链接
 @param status statusBlock
 @param controller 展示到的Controller
 */
-(void)shareContent:(NSString *)link handler:(FacebookShareStatusBlock)status showFromViewController:(UIViewController *)controller;

@end
