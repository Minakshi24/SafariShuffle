//
//  ViewController.h
//  MemoryGameApp
//
//  Created by Surjit Joshi on 22/06/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"
#import "AppSpecificValues.h"
#import "AppDelegate.h"

@class GameCenterManager;

@interface FirstPage : UIViewController 
{
    AVAudioPlayer *buttonClickMusic;
    
    AppDelegate *mainDelegate;
        
    float w, h;
}

@property float w, h;

@end
