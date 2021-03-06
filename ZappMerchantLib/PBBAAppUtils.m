//
//  PBBAAppUtils.m
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

#import "PBBAAppUtils.h"
#import "PBBALibraryUtils.h"

@implementation PBBAAppUtils

+ (BOOL)isCFIAppAvailable
{
    return [PBBALibraryUtils isCFIAppAvailable];
}

+ (BOOL)openBankingApp:(NSString *)secureToken
{
    NSAssert(secureToken, @"[PBBAAppUtils] 'secureToken' is a mandatory parameter.");
    
    return [PBBALibraryUtils openBankingApp:secureToken];
}

+ (PBBAPopupViewController *)showPBBAPopup:(UIViewController *)presenter
                               secureToken:(NSString *)secureToken
                                       brn:(NSString *)brn
                                  delegate:(id<PBBAPopupViewControllerDelegate>)delegate
{
    NSAssert(presenter, @"[PBBAAppUtils] 'presenter' is a mandatory parameter.");
    NSAssert(secureToken, @"[PBBAAppUtils] 'secureToken' is a mandatory parameter.");
    NSAssert(brn, @"[PBBAAppUtils] 'brn' is a mandatory parameter.");
    NSAssert(brn.length == 6, @"[PBBAAppUtils] 'brn' length must be 6 characters.");
    
    if ([PBBALibraryUtils shouldLaunchCFIApp]) {
        
        // Dismiss any instance of the presented PBBAPopupViewController before opening the CFI app
        if ([presenter.presentedViewController isKindOfClass:[PBBAPopupViewController class]]) {
            [presenter dismissViewControllerAnimated:NO completion:nil];
        }
        
        // Launch CFI app and exit early
        if ([self openBankingApp:secureToken]) {
            return nil;
        }
    }
    
    // Update the already presented instance of PBBAPopupViewController instead of recreating it
    if ([presenter.presentedViewController isKindOfClass:[PBBAPopupViewController class]]) {
        PBBAPopupViewController *pbbaPopupVC = (PBBAPopupViewController *) presenter.presentedViewController;
        [pbbaPopupVC updateWithSecureToken:secureToken
                                       brn:brn];
        
        pbbaPopupVC.delegate = delegate;
        
        // Exit early
        return pbbaPopupVC;
    }
    
    // Create a new instance of PBBAPopupViewController and try to present it
    PBBAPopupViewController *pbbaPopupVC = [[PBBAPopupViewController alloc] initWithSecureToken:secureToken
                                                                                            brn:brn
                                                                                       delegate:delegate];
    return [self presentPBBAPopup:pbbaPopupVC presenter:presenter];
}

+ (PBBAPopupViewController *)showPBBAErrorPopup:(UIViewController *)presenter
                                      errorCode:(NSString *)errorCode
                                     errorTitle:(NSString *)errorTitle
                                   errorMessage:(NSString *)errorMessage
                                       delegate:(id<PBBAPopupViewControllerDelegate>)delegate
{
    NSAssert(presenter, @"[PBBAAppUtils] 'presenter' is a mandatory parameter.");
    NSAssert(errorMessage, @"[PBBAAppUtils] 'errorMessage' is a mandatory parameter.");
    
    // Update the already presented instance of PBBAPopupViewController instead of recreating it
    if ([presenter.presentedViewController isKindOfClass:[PBBAPopupViewController class]]) {
        PBBAPopupViewController *pbbaPopupVC = (PBBAPopupViewController *) presenter.presentedViewController;
        [pbbaPopupVC updateWithErrorCode:errorCode
                              errorTitle:errorTitle
                            errorMessage:errorMessage];
        
        pbbaPopupVC.delegate = delegate;
        
        // Exit early
        return pbbaPopupVC;
    }
    
    // Create a new instance of PBBAPopupViewController and try to present it
    PBBAPopupViewController *pbbaPopupVC = [[PBBAPopupViewController alloc] initWithErrorCode:errorCode
                                                                                   errorTitle:errorTitle
                                                                                 errorMessage:errorMessage
                                                                                     delegate:delegate];
    
    return [self presentPBBAPopup:pbbaPopupVC presenter:presenter];
}

+ (PBBAPopupViewController *)presentPBBAPopup:(PBBAPopupViewController *)pbbaPopupVC
                                    presenter:(UIViewController *)presenter
{
    [presenter presentViewController:pbbaPopupVC animated:YES completion:nil];
    
    // Return nil if the attempt to present the PBBAPopupViewController has failed
    return (presenter.presentedViewController == pbbaPopupVC) ? pbbaPopupVC : nil;
}

@end
