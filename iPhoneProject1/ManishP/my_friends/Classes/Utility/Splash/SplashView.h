
#import <UIKit/UIKit.h>

@protocol SplashViewDelegate <NSObject>

@optional
- (void)splashIsDone;
@end

typedef enum {
	SplashViewAnimationNone,
	SplashViewAnimationSlideLeft,
	SplashViewAnimationFade,
} SplashViewAnimation;
	
@interface SplashView : UIView
{

	id<SplashViewDelegate> delegate;
	NSTimeInterval delay;
	BOOL touchAllowed;
	SplashViewAnimation animation;
	NSTimeInterval animationDelay;
	
	BOOL isFinishing;
	UILabel *loadingLabel;
}
@property (retain) id<SplashViewDelegate> delegate;
@property NSTimeInterval delay;
@property BOOL touchAllowed;
@property SplashViewAnimation animation;
@property NSTimeInterval animationDelay;
@property BOOL isFinishing;

- (void)startSplash;
- (void)startSplashWithTitle:(NSString *)title;
- (void)dismissSplash;
- (void)dismissSplashFinish;

-(void)updateDisplay:(NSString *)str;

@end
