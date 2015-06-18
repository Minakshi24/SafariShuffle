//
//  SettingsPage.h
//  MemoryGameApp
//
//  Created by Ankita Chordia on 7/25/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <sqlite3.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>
#import "FbGraph.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SettingsPage : UIViewController<SKRequestDelegate,SKProductsRequestDelegate,UIWebViewDelegate>
{

    AppDelegate *mainDelegate;
    UIButton *backBtn;
    
    UIButton *leaderBoardOFfBtn, *leaderBoardAutoBtn;
    
    AVAudioPlayer *buttonClickMusic;
    
    //Database
    
    const char* dbpath;
    sqlite3 *memoryappDB;
    
    UIButton *emojiBtn, *albumBtn, *facebookPhotoBtn;
    
    MBProgressHUD *_hud;

    //Facebook
	
    FbGraph *fbGraph;
    
    NSMutableArray *assetGroups;
    NSMutableArray *purchasedItemIDs;

    //Activity 
    
    UIAlertView *activityAlert;
    UIActivityIndicatorView *activityView;
}

@property (retain) MBProgressHUD *hud;
@property (nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic, retain) NSMutableArray *assetGroups;

- (void) initDatabase;
-(void)getPhotosFromDevice;
-(void)fbPhotosBtnAction;
-(void)loadImages : (ALAssetsGroup *)assetGrp;
-(void) resetScoreToDb : (NSString *)string;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
