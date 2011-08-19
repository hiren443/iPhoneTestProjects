
#import "SplashView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SplashView

@synthesize delegate;
@synthesize delay;
@synthesize touchAllowed;
@synthesize animation;
@synthesize isFinishing;
@synthesize animationDelay;

- (id)init
{
	if (self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]])
	{
		//self.delay = 2;
		self.touchAllowed = NO;
		self.animation = SplashViewAnimationNone;
		self.animationDelay = .5;
		self.isFinishing = NO;
	}
	return self;
}

- (void)startSplash
{
	[[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self];
	
	UIActivityIndicatorView *av = (UIActivityIndicatorView *)[self viewWithTag:1];
	CGRect tempFrame = [UIScreen mainScreen].applicationFrame;
	if(!av)
	{
		av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		tempFrame.origin.x = tempFrame.size.width / 2 - 20;
		tempFrame.origin.y = tempFrame.size.height / 2 - 20;
		tempFrame.size.width = 40;
		tempFrame.size.height = 40;
		av.frame = tempFrame;
		av.tag  = 1;
		[av startAnimating];
		[self addSubview:av];
		[av release];
	}
	
	/*loadingLabel = (UILabel *)[self viewWithTag:2];
	if(!loadingLabel)
	{
		tempFrame = [UIScreen mainScreen].applicationFrame;
		tempFrame.origin.x = 0;
		tempFrame.origin.y = tempFrame.size.height / 2 + 30;
		//tempFrame.size.width = 200;
		tempFrame.size.height = 30;
		
		loadingLabel =	[[[UILabel alloc] initWithFrame:tempFrame]autorelease];
		loadingLabel.text = NSLocalizedString(@"Loading...", nil);
		loadingLabel.textColor = [UIColor whiteColor];
		loadingLabel.backgroundColor = [UIColor clearColor];
		loadingLabel.textAlignment = UITextAlignmentCenter;
		loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
		loadingLabel.tag = 2;
		[self addSubview:loadingLabel];
	}*/
	self.backgroundColor = [UIColor blackColor];
	self.alpha = 0.8;
}


- (void)startSplashWithTitle:(NSString *)title
{
	[[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self];
	self.backgroundColor = [UIColor clearColor];
	UIView *bgView = (UIView *)[self viewWithTag:3];
	CGRect tempFrame = [UIScreen mainScreen].applicationFrame;
	if(!bgView)
	{
		tempFrame.origin.x = tempFrame.size.width / 2 - 100;
		tempFrame.origin.y = tempFrame.size.height / 2 - 40;
		tempFrame.size.width = 200;
		tempFrame.size.height = 100;
		bgView = [[UIView alloc]initWithFrame:tempFrame];
		bgView.tag  = 3;
		bgView.backgroundColor = [UIColor blackColor];
		bgView.alpha = 0.8;
		//[bgView.layer setBorderWidth:2.0];
		[bgView.layer setCornerRadius:10.0];
		//[bgView.layer setBorderColor:[[UIColor clearColor] CGColor]];
		[self addSubview:bgView];
		[bgView release];
	}
	[self sendSubviewToBack:bgView];
	
	UIActivityIndicatorView *av = (UIActivityIndicatorView *)[self viewWithTag:1];
	tempFrame = [UIScreen mainScreen].applicationFrame;
	if(!av)
	{
		av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		tempFrame.origin.x = tempFrame.size.width / 2 - 20;
		tempFrame.origin.y = tempFrame.size.height / 2 - 20;
		tempFrame.size.width = 40;
		tempFrame.size.height = 40;
		av.frame = tempFrame;
		av.tag  = 1;
		[av startAnimating];
		[self addSubview:av];
		[av release];
	}
	
	[self bringSubviewToFront:av];
	
	loadingLabel = (UILabel *)[self viewWithTag:2];
	if(!loadingLabel)
	{
		tempFrame = [UIScreen mainScreen].applicationFrame;
		tempFrame.origin.x = 0;
		tempFrame.origin.y = tempFrame.size.height / 2 + 20;
		//tempFrame.size.width = 200;
		tempFrame.size.height = 30;
		loadingLabel =	[[[UILabel alloc] initWithFrame:tempFrame]autorelease];
		loadingLabel.textColor = [UIColor whiteColor];
		loadingLabel.backgroundColor = [UIColor clearColor];
		loadingLabel.textAlignment = UITextAlignmentCenter;
		loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
		loadingLabel.tag = 2;
		[self addSubview:loadingLabel];
	}
	loadingLabel.text = NSLocalizedString(title, nil);
	[self bringSubviewToFront:loadingLabel];
}


- (void)dismissSplash
{

	if(self.isFinishing || self.animation == SplashViewAnimationNone)
	{
		[self dismissSplashFinish];
	}
	self.isFinishing = YES;
}

- (void)dismissSplashFinish
{
	[self removeFromSuperview];
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(splashIsDone)])
	{
		[delegate splashIsDone];
	}
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.touchAllowed)
	{
		[self dismissSplash];
	}
}

-(void)updateDisplay:(NSString *)str
{
	//[self.label performSelectorOnMainThread : @ selector(setText : ) withObject:str waitUntilDone:YES];
	[loadingLabel performSelectorOnMainThread : @ selector(setText : ) withObject:str waitUntilDone:YES];
	
}
- (void)dealloc
{
	[super dealloc];
}


@end
