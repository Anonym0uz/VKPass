#import "../Passcode/BKPasscodeField.h"
#import "../Passcode/BKPasscodeInputView.h"
#import "../Passcode/BKPasscodeViewController.h"
#import "../Passcode/BKShiftingView.h"
#import "../Passcode/BKPasscodeLockScreenManager.h"
#import "../Passcode/BKPasscodeDummyViewController.h"
#import "../Passcode/BKTouchIDManager.h"
#import "../Passcode/BKTouchIDSwitchView.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Preferences/Preferences.h>
//#import <Preferences/PSViewController.h>
//#import <Preferences/PSDetailController.h>
//#import <Preferences/PSTableCell.h>
//#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <sys/utsname.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIViewController.h>
#import "../FBEncrypt/FBEncryptorAES.h"
#import "../FBEncrypt/NSData+Base64.h"
#import "UIAlertView+Sheet/UIAlertView+Blocks.h"
#import "../VKClasses.h"
#import "VKPPaths.h"
#import "VKPassLP.h"

//Passcode/APPinViewController.m Passcode/BKPasscodeField.m Passcode/BKPasscodeInputView.m Passcode/BKPasscodeViewController.m Passcode/AFViewShaker.m Passcode/BKShiftingView.m VKPrefsPasscode.mm

@protocol VKPrefsPasscodeDelegate <NSObject>
- (void)passcodeHasBeenCreated;
- (void)passcodeHasBeenChecked;
- (void)passcodeHasBeenChanged;
- (void)passcodeHasBeenDisabled;
- (void)passcodeHasBeenDeleted;
- (void)passcodeForDialogsChecked;
- (void)passcodeForDialogsDisabled;
@end
extern NSString *const BKPasscodeKeychainServiceName;
@interface VKPrefsPasscode : PSViewController <BKPasscodeViewControllerDelegate>
@property (nonatomic, assign) id<VKPrefsPasscodeDelegate> delegate;
@property (strong, nonatomic) NSString          *passcode;
@property (nonatomic) NSUInteger                failedAttempts;
@property (strong, nonatomic) NSDate            *lockUntilDate;
@property (strong, retain) NSMutableDictionary *passcodeFile;
@property (nonatomic, assign) BOOL deletePasscode;
@property (nonatomic, assign) BOOL disablePasscode;
@property (nonatomic, assign) BOOL disableVKPasscode;
@property (nonatomic, assign) BOOL lostPassAuthCompl;
//+(NSString *)passcode;
+(VKPrefsPasscode *) sharedInstance;
//+(void)passcodeSettings;
// New rewrite
// - (void)openPasscodeViewControllerWithType:(NSString *)type;

- (id)checkDisablePINVCWithType:(NSString *)typePasscode;
-(id)checkDisableVKPINVC;
-(id)setPINVC;
-(id)changePINVC;
- (id)checkPINVCWithType:(NSString *)typePasscode;
-(id)deletePINVC;
-(id)lostPassword;
@end
