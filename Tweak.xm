#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static NSString * const KRDomain = @"com.jiangyiji.keyboardrounded";

static BOOL krEnabled = YES;
static CGFloat krRadius = 32.0;
static CGFloat krHorizontalInset = 0.0;
static CGFloat krVerticalInset = 0.0;
static BOOL krContinuous = YES;

static void KRLoadPreferences(void) {
    NSUserDefaults *d = [[NSUserDefaults alloc] initWithSuiteName:KRDomain];
    if (!d) return;

    krEnabled = [d objectForKey:@"Enabled"] ? [d boolForKey:@"Enabled"] : YES;
    krRadius = [d objectForKey:@"Radius"] ? [d doubleForKey:@"Radius"] : 32.0;
    krHorizontalInset = [d objectForKey:@"HorizontalInset"] ? [d doubleForKey:@"HorizontalInset"] : 0.0;
    krVerticalInset = [d objectForKey:@"VerticalInset"] ? [d doubleForKey:@"VerticalInset"] : 0.0;
    krContinuous = [d objectForKey:@"Continuous"] ? [d boolForKey:@"Continuous"] : YES;

    krRadius = MAX(0.0, MIN(80.0, krRadius));
    krHorizontalInset = MAX(0.0, MIN(40.0, krHorizontalInset));
    krVerticalInset = MAX(0.0, MIN(40.0, krVerticalInset));
}

static BOOL KRIsKeyboardHost(UIView *view) {
    if (!view) return NO;
    NSString *name = NSStringFromClass(view.class);
    return [name isEqualToString:@"UIInputSetHostView"] ||
           [name isEqualToString:@"UIInputSetHost"];
}

static void KRRemoveMaskIfNeeded(UIView *view) {
    if (!view) return;
    view.layer.mask = nil;
}

static void KRApplyKeyboardMask(UIView *view) {
    if (!view || !view.window) return;

    if (!krEnabled) {
        KRRemoveMaskIfNeeded(view);
        return;
    }

    CGRect bounds = view.bounds;
    if (bounds.size.width < 200.0 || bounds.size.height < 80.0) return;

    CGFloat x = MIN(krHorizontalInset, MAX(0.0, bounds.size.width / 2.0 - 1.0));
    CGFloat y = MIN(krVerticalInset, MAX(0.0, bounds.size.height / 2.0 - 1.0));

    CGRect maskRect = CGRectInset(bounds, x, y);
    CGFloat radius = MIN(krRadius, MIN(maskRect.size.width, maskRect.size.height) / 2.0);

    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = bounds;
    mask.path = [UIBezierPath bezierPathWithRoundedRect:maskRect cornerRadius:radius].CGPath;

    view.layer.mask = mask;

    if (@available(iOS 13.0, *)) {
        view.layer.cornerCurve = krContinuous ? kCACornerCurveContinuous : kCACornerCurveCircular;
    }
}

static void KRApplyToViewIfKeyboardHost(id object) {
    UIView *view = (UIView *)object;
    if (!view) return;
    if (!KRIsKeyboardHost(view)) return;
    KRApplyKeyboardMask(view);
}

%hook UIInputSetHostView

- (void)layoutSubviews {
    %orig;
    KRLoadPreferences();
    KRApplyToViewIfKeyboardHost(self);
}

- (void)didMoveToWindow {
    %orig;
    KRLoadPreferences();
    KRApplyToViewIfKeyboardHost(self);
}

- (void)setFrame:(CGRect)frame {
    %orig(frame);
    KRLoadPreferences();
    dispatch_async(dispatch_get_main_queue(), ^{
        KRApplyToViewIfKeyboardHost(self);
    });
}

%end

%hook UIInputSetContainerView

- (void)layoutSubviews {
    %orig;
    KRLoadPreferences();

    if (!krEnabled) return;

    for (UIView *subview in ((UIView *)self).subviews) {
        if (KRIsKeyboardHost(subview)) {
            KRApplyKeyboardMask(subview);
        }
    }
}

%end

%ctor {
    @autoreleasepool {
        KRLoadPreferences();
    }
}
