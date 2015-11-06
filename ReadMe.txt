iAdSuite
==========

iAdSuite demonstrates how to manage ADBannerViews in three common scenarios, an application with a single view controller (BasicAdBanner), an application that uses a UITabBarViewController (AdBannerTabbed), and an application that uses a UINavigationViewController (AdBannerNavigation).

BasicAdBanner displays a read-only UITextView and creates an ADBannerView if one isn't specified in the nib. AdBannerTabbed and AdBannerNavigation add an MKMapView as a second view displayed, reachable by tabbed or navigation based browsing within the application. These samples all demonstrate the ad banner placed at the bottom of the view, and all support both portrait and landscape orientations.

Build Requirements
iOS 4.1 SDK

Runtime Requirements
iPhone OS 4.0 or later.

Changes from Previous Versions
1.1 - Updated for iOS 4.1. Reseting banner frame instead of center to move the banner view on/off screen.

Note: On iOS 4.1, an ADBannerView may not update correctly unless you call -setFrame: or -setHidden: when updating its geometry

1.0 - First release

Copyright (C) 2010 Apple Inc. All rights reserved.
