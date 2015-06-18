//
//  AlreadyPurchased.h
//  Match Games 'Social'
//
//  Created by Ankita Chordia on 8/1/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <StoreKit/StoreKit.h>
#import "FbGraph.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>

@interface AlreadyPurchased : UIViewController<SKRequestDelegate,SKProductsRequestDelegate,UIWebViewDelegate>
{

    UIButton *backBtn;
    
    AppDelegate *mainDelegate;
    
    AVAudioPlayer *buttonClickMusic;
    
    NSString *identifierStr;
    
    MBProgressHUD *_hud;
    UIButton *restoreButton;
    
    UIView *detailView;
    int w,h;
    //UIButton *hint150,*hint300,*award20,*award200,*valuePack,*cancelBtn,*iTuneBtn;
    
    NSMutableArray *purchasedItemIDs;
    
    UIView *moreView;
    
    //Facebook
	
    FbGraph *fbGraph;
    
    NSMutableArray *assetGroups;
    
}

@property (nonatomic, retain) NSString *identifierStr;

@property (retain) MBProgressHUD *hud;
@property (nonatomic, retain) FbGraph *fbGraph;


@property (nonatomic, retain) NSMutableArray *assetGroups;

-(void)fbPhotosBtnAction;
-(void)getFriendPicsFromFB;
-(void)getPhotosFromDevice;
-(void)loadImages : (ALAssetsGroup *)assetGrp;
//- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
