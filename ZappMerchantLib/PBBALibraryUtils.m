//
//  PBBALibraryUtils.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 6/27/16.
//  Copyright 2016 IPCO 2012 Limited
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "PBBALibraryUtils.h"

NSString * const kPBBACustomThemeKey = @"pbbaTheme";

static NSString * const kPBBACustomConfigFileName       = @"pbbaCustomConfig";
static NSString * const kPBBACFIAppUrlScheme            = @"zapp://";
static NSString * const kPBBAPaymentsInfoURLString      = @"http://www.paybybankapp.co.uk/how-it-works/the-experience/";
static NSString * const kPBBARememberCFIAppLaunchKey    = @"com.zapp.bankapp.remembered";

static NSDictionary *sPBBACustomConfig = nil;

@implementation PBBALibraryUtils

+ (NSDictionary *)pbbaCustomConfig
{
    if (sPBBACustomConfig == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:kPBBACustomConfigFileName ofType:@"plist"];
        sPBBACustomConfig = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    return sPBBACustomConfig;
}

+ (void)setPBBACustomConfig:(NSDictionary *)config
{
    sPBBACustomConfig = config;
}

+ (BOOL)isCFIAppAvailable
{
    NSURL *urlToCheck = [NSURL URLWithString:kPBBACFIAppUrlScheme];
    return [[UIApplication sharedApplication] canOpenURL:urlToCheck];
}

+ (BOOL)openBankingApp:(NSString *)secureToken
{
    if (secureToken) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kPBBACFIAppUrlScheme, secureToken]];
        return [[UIApplication sharedApplication] openURL:url];
    }
    
    return NO;
}

+ (void)registerCFIAppLaunch
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPBBARememberCFIAppLaunchKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)wasCFIAppLaunched
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPBBARememberCFIAppLaunchKey];
}

+ (BOOL)shouldLaunchCFIApp
{
    return [self wasCFIAppLaunched] && [self isCFIAppAvailable];
}

+ (BOOL)openTellMeMoreLink
{
    NSURL *url = [NSURL URLWithString:kPBBAPaymentsInfoURLString];
    return [[UIApplication sharedApplication] openURL:url];
}

@end
