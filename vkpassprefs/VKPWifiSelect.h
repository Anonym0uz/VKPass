#import <Preferences/Preferences.h>
//#import <Preferences/PSListController.h>
//#import <Preferences/PSSpecifier.h>
#import <SystemConfiguration/CaptiveNetwork.h>
//#import "MobileWiFi/MobileWiFi.h"
#import "WifiSrc/DMNetwork.h"
#import "WifiSrc/DMNetworksManager.h"
#import "VKPPaths.h"

@interface VKPWifiSelect: PSViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* wifiArray;
    NSString* SSID;
    WiFiNetworkRef network;
}
@property(nonatomic, copy) NSString *SSID;
@property(nonatomic, assign, readonly) WiFiNetworkRef _networkRef;
- (UITableView *)tableView;
@end
