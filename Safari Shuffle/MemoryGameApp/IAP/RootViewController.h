
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>
#import "FbGraph.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>


@interface RootViewController : UIViewController<SKRequestDelegate,SKProductsRequestDelegate,UIWebViewDelegate> 
{
    
    MBProgressHUD *_hud;
    AppDelegate *mainDelegate;
    UIButton *restoreButton;
    
    UIView *detailView;
    int w,h;
    //UIButton *hint150,*hint300,*award20,*award200,*valuePack,*cancelBtn,*iTuneBtn;

    NSMutableArray *purchasedItemIDs;
    
    UIView *moreView;
    
    //Facebook
	
    FbGraph *fbGraph;
    
    NSMutableArray *assetGroups;
    UIButton *backBtn;
    AVAudioPlayer *buttonClickMusic;
    
    UIButton *restoreBtn;
    
    
    UIAlertView *photosPurchase, *fbPhotosPurchased;
    
    //Activity 
    
    UIAlertView *activityAlert;
    UIActivityIndicatorView *activityView;
    
}

@property (retain) MBProgressHUD *hud;
@property (nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic, retain) NSMutableArray *assetGroups;


//- (void) initDatabase;
-(void)getPhotosFromDevice;
-(void)getFriendPicsFromFB;
-(void)fbPhotosBtnAction;
-(void)loadImages : (ALAssetsGroup *)assetGrp;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
