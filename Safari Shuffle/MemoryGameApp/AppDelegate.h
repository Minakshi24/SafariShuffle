//
//  AppDelegate.h
//  MemoryGameApp
//
//  Created by Surjit Joshi on 22/06/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

//@class FirstPage;

@class LevelSelectionPage;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navigationController;
    
    //LevelSelectionPage *levelSelectionPage;
    
     int totalScore;
    
    
    BOOL level1Flag, level2Flag, level3Flag, level4Flag, level5Flag, level6Flag;
    
    BOOL soundFlag, leaderBoardFlag;
    
    NSMutableArray *facebookPhotoUrl;
    
    BOOL facebookPhotoFlag, yourPhotoFlag, emojiFlag;
    
    NSMutableArray *assets;
    
    int gameCount;
    
    NSMutableArray *assetGroups;
    
    //Activity 
    
    UIAlertView *activityAlert;
    UIActivityIndicatorView *activityView;
    
}

@property (nonatomic, retain) NSMutableArray *assetGroups;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LevelSelectionPage *viewController;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) NSMutableArray *facebookPhotoUrl;
@property (strong, nonatomic) NSMutableArray *assets;

@property int totalScore;

@property int gameCount;

@property BOOL facebookPhotoFlag;

@property BOOL emojiFlag;

@property BOOL yourPhotoFlag;

@property BOOL level1Flag;

@property BOOL level2Flag;

@property BOOL level3Flag;

@property BOOL level4Flag;

@property BOOL level5Flag;

@property BOOL level6Flag;

@property BOOL soundFlag;

@property BOOL leaderBoardFlag;

-(void)getPhotosFromDevice;
-(void)loadImages : (ALAssetsGroup *)assetGrp;

@end
