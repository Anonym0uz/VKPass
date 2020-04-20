#import <os/log.h> 
//@interface VKPPaths : NSObject
//@property (nonatomic, readwrite) int lostPasswrd;
//@end
/////////////////////////////////////////////
////////////////VK APP NON-JB////////////////
/////////////////////////////////////////////

// #define passcodePath [NSHomeDirectory() stringByAppendingString:@"/Documents/ru.anonz.vkpasscode.plist"]
// #define settingsPath [NSHomeDirectory() stringByAppendingString:@"/Documents/ru.anonz.vkpassprefs.plist"]
// #define settingsFilePath [NSHomeDirectory() stringByAppendingString:@"/Documents/ru.anonz.vkpassprefs.plist"]
// #define wifiPath [NSHomeDirectory() stringByAppendingString:@"/Documents/ru.anonz.vkpasswifi.plist"]

/////////////////////////////////////////////
//////////////////VK APP JB//////////////////
/////////////////////////////////////////////
#define passcodePath @"/var/mobile/Library/Preferences/ru.anonz.vkpasscode.plist"
#define settingsPath @"/var/mobile/Library/Preferences/ru.anonz.vkpassprefs.plist"
#define settingsFilePath @"/var/mobile/Library/Preferences/ru.anonz.vkpassprefs.plist"
#define wifiPath @"/var/mobile/Library/Preferences/ru.anonz.vkpasswifi.plist"
