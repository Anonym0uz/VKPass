#import <objc/runtime.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#import <Preferences/PSViewController.h>
#import <QuartzCore/QuartzCore.h>
#import <notify.h>
#import <Foundation/Foundation.h>
#import "VKClasses.h"
#import <Preferences/PSListController.h>
#import "VKPrefsPasscode.h"
#import "VPBiometricAuthenticationFacade.h"
#import "vkpassprefs/VKPassPrefs.h"
#import "vkpassprefs/VKPPaths.h"

//NON-JAIL
//#define settingsFilePath [NSHomeDirectory() stringByAppendingString:@"/Documents/ru.anonz.vkpassprefs.plist"]
//JAILED
//#define settingsFilePath @"/var/mobile/Library/Preferences/ru.anonz.vkpassprefs.plist"
//#import "vkcolorizebundle/VKCImagePicker.h"

@interface VKPass : NSObject
+(VKPass *) sharedInstance;
-(VKPass *) init;
-(void)showVKPassSettings;
-(void)showPassView;
@end
