//
//  PBBAPopupContainerController.h
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/3/16.
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

#import <UIKit/UIKit.h>
#import "PBBAPopupContentViewController.h"
#import "PBBAAppearance.h"

/**
 *  The popup container view controller which holds all content (child) view controllers.
 */
@interface PBBAPopupContainerController : UIViewController

/**
 *  The appearance which will be forwarded to the child view controllers.
 */
@property (nonatomic, strong) PBBAAppearance *appearance;

/**
 *  The active content (child) view controller
 */
@property (nonatomic, strong) PBBAPopupContentViewController *activeViewController;

/**
 *  Get an instance of popup container view controller for given content controller.
 *
 *  @param viewController The instance of popup content view controller.
 *
 *  @return An instance of popup container view controller.
 */
- (instancetype)initWithContentViewController:(PBBAPopupContentViewController *)viewController;

/**
 *  Push new content (child) view controller to container controller.
 *
 *  @param viewController The instance of the new content view controller.
 */
- (void)pushViewController:(PBBAPopupContentViewController *)viewController;

@end
