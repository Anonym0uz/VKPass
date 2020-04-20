#import "VKPWifiSelect.h"

NSMutableDictionary *wifiDict;

@implementation VKPWifiSelect
@synthesize SSID;
@synthesize _networkRef = _network;

static void loadWifiDict()
{
    wifiDict = [[NSMutableDictionary alloc] initWithContentsOfFile:wifiPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:wifiPath])
    {
        NSMutableDictionary *wifiDict = [[NSMutableDictionary alloc] init];
        [wifiDict writeToFile:wifiPath atomically:YES];
    }
    
}

- (id)initWithNetwork:(WiFiNetworkRef)network
{
    self = [super init];
    
    if (self) {
        _network = (WiFiNetworkRef)CFRetain(network);
    }
    
    return self;
}

- (void)populateData
{
    // SSID
    NSString *SSID = (NSString *)WiFiNetworkGetSSID(_network);
    [self setSSID:SSID];
}

+ (NSString *)GetCurrentWifiHotSpotName {
    NSString *wifiName = nil;
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        if (info[@"SSID"]) {
            wifiName = info[@"SSID"];
        }
    }
    return wifiName;
}

-(void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    loadWifiDict();
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    //wifiArray = [NSMutableArray arrayWithObjects:@"LOLZ", @"LOLZ2", @"LOLZ3", @"LOLZ4", @"LOLZ5", nil];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.autoresizingMask = 1;
    self.view = tableView;
    [super viewDidLoad];
}

- (UITableView *)tableView
{
    return (UITableView *)self.view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [wifiArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    NSString *wifiName = nil;
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        //NSLog(@"info:%@",info);
        if (info[@"SSID"]) {
            wifiName = info[@"SSID"];
        }
    }
    //CFArrayRef myArray = CNCopySupportedInterfaces();
    //wifiArray = CNCopySupportedInterfaces();
    //CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
    //cell.textLabel.text = [myArray objectAtIndex:indexPath.row];//wifiName;//[ifs objectAtIndex:indexPath.row];
    DMNetwork *network = [[[DMNetworksManager sharedInstance] networks] objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[network SSID]];
    
    return cell;
}

@end

// vim:ft=objc
