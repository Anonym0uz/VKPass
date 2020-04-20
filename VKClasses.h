#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#import <Preferences/PSViewController.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIViewController.h>
#import "vkpassprefs/VKPrefsPasscode.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, BKPasscodeLockScreenManagerDelegate>
@property(retain, nonatomic) UIWindow *window;
-(void)showModalViewController:(id)arg1;
-(void)presentViewController:(id)arg1 animated:(BOOL)arg2 completion:(id)arg3;
-(void)pushViewController:(id)arg1 animated:(BOOL)arg2;
@end

@interface VKMMainController : NSObject

@end

@interface VKMNavigationController : NSObject
{
    _Bool _presenterTemporaryDismissed;
    UIWindow *_presentedWindow;
}

+ (_Bool)isNavigationWithPresentedWindow:(id)arg1;
@property(nonatomic) _Bool presenterTemporaryDismissed; // @synthesize presenterTemporaryDismissed=_presenterTemporaryDismissed;
@property(retain, nonatomic) UIWindow *presentedWindow; // @synthesize presentedWindow=_presentedWindow;
- (unsigned long long)supportedInterfaceOrientations;
- (void)dealloc;
-(void)showStatusBar;
@end
