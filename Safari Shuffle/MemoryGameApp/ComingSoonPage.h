//
//  ComingSoonPage.h
//  MemoryGameApp
//
//  Created by Ankita Chordia on 7/26/12.
//  Copyright (c) 2012 Nanostuffs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface ComingSoonPage : UIViewController
{

    UIButton *backBtn;
    
    AppDelegate *mainDelegate;
    
    AVAudioPlayer *buttonClickMusic;

}
@end
