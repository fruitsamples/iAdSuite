/*     File: TextViewController.m */
/* Abstract: A simple view controller that manages a content view and an ADBannerView */
/*  Version: 2.0 */
/*  */
/* Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple */
/* Inc. ("Apple") in consideration of your agreement to the following */
/* terms, and your use, installation, modification or redistribution of */
/* this Apple software constitutes acceptance of these terms.  If you do */
/* not agree with these terms, please do not use, install, modify or */
/* redistribute this Apple software. */
/*  */
/* In consideration of your agreement to abide by the following terms, and */
/* subject to these terms, Apple grants you a personal, non-exclusive */
/* license, under Apple's copyrights in this original Apple software (the */
/* "Apple Software"), to use, reproduce, modify and redistribute the Apple */
/* Software, with or without modifications, in source and/or binary forms; */
/* provided that if you redistribute the Apple Software in its entirety and */
/* without modifications, you must retain this notice and the following */
/* text and disclaimers in all such redistributions of the Apple Software. */
/* Neither the name, trademarks, service marks or logos of Apple Inc. may */
/* be used to endorse or promote products derived from the Apple Software */
/* without specific prior written permission from Apple.  Except as */
/* expressly stated in this notice, no other rights or licenses, express or */
/* implied, are granted by Apple herein, including but not limited to any */
/* patent rights that may be infringed by your derivative works or by other */
/* works in which the Apple Software may be incorporated. */
/*  */
/* The Apple Software is provided by Apple on an "AS IS" basis.  APPLE */
/* MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION */
/* THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS */
/* FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND */
/* OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. */
/*  */
/* IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL */
/* OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF */
/* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS */
/* INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, */
/* MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED */
/* AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), */
/* STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE */
/* POSSIBILITY OF SUCH DAMAGE. */
/*  */
/* Copyright (C) 2011 Apple Inc. All Rights Reserved. */
/*  */

#import "TextViewController.h"

@implementation TextViewController
{
    ADBannerView *_bannerView;
    NSTimer *_timer;
    CFTimeInterval _ticks;
}

@synthesize contentView = _contentView;
@synthesize textView = _textView;
@synthesize timerLabel = _timerLabel;
@synthesize text = _text;

- (id)init
{
    self = [super initWithNibName:@"TextViewController" bundle:nil];
    if (self) {
        _bannerView = [[ADBannerView alloc] init];
        _bannerView.delegate = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)dealloc
{
    [_timer invalidate];
    // When running on iOS 5.0 and later, ADBannerView's delegate property acts as a weak reference, making this unnecessary.
    // However since this sample supports iOS 4.2 and later, we do this here to ensure correct behavior on all systems.
    _bannerView.delegate = nil;
}

- (void)layoutAnimated:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        contentFrame.size.height -= _bannerView.frame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        _contentView.frame = contentFrame;
        [_contentView layoutIfNeeded];
        _bannerView.frame = bannerFrame;
    }];
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    self.textView.text = text;
}

- (void)timerTick:(NSTimer *)timer
{
    // Timers are not guaranteed to tick at the nominal rate specified, so this isn't technically accurate.
    // However, this is just an example to demonstrate how to stop some ongoing activity, so we can live with that inaccuracy.
    _ticks += 0.1;
    double seconds = fmod(_ticks, 60.0);
    double minutes = fmod(trunc(_ticks / 60.0), 60.0);
    double hours = trunc(_ticks / 3600.0);
    self.timerLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f:%04.1f", hours, minutes, seconds];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:_bannerView];
    self.textView.text = self.text;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.contentView = nil;
    self.textView = nil;
    self.timerLabel = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self layoutAnimated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    [self layoutAnimated:duration > 0.0];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self layoutAnimated:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    [_timer invalidate];
    _timer = nil;
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
}

@end
