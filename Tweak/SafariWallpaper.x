#import "SafariWallpaper.h"

%group SafariWallpaper

%hook CatalogViewController

- (void)viewDidAppear:(BOOL)animated { // add wallpaper

	%orig;

	if (!wallpaperView) {
		wallpaperView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
		[wallpaperView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[wallpaperView setContentMode:UIViewContentModeScaleAspectFill];
		[wallpaperView setAlpha:0.0];
		if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleLight)
			wallpaper = [GcImagePickerUtils imageFromDefaults:@"love.litten.safariwallpaperpreferences" withKey:@"wallpaperImageLight"];
		else if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark)
			wallpaper = [GcImagePickerUtils imageFromDefaults:@"love.litten.safariwallpaperpreferences" withKey:@"wallpaperImageDark"];
	}
	
	[wallpaperView setImage:wallpaper];
	if (![wallpaperView isDescendantOfView:[self view]]) [[self view] insertSubview:wallpaperView atIndex:0];

	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [wallpaperView setAlpha:[wallpaperAlphaValue doubleValue]];
    } completion:nil];

	if (useDynamicLabelColorSwitch && !useCustomLabelColorSwitch && wallpaper) {
		if ([libKitten isDarkImage:wallpaper]) isDarkWallpaper = YES;
		else isDarkWallpaper = NO;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"safariWallpaperUpdateDynamicLabelColor" object:nil];
	}

}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // transition when changing interface mode

	%orig;

	if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleLight) {
		wallpaper = [GcImagePickerUtils imageFromDefaults:@"love.litten.safariwallpaperpreferences" withKey:@"wallpaperImageLight"];
		[UIView transitionWithView:wallpaperView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			[wallpaperView setImage:wallpaper];
		} completion:nil];

		if (useDynamicLabelColorSwitch && !useCustomLabelColorSwitch && wallpaper) {
			if ([libKitten isDarkImage:wallpaper]) isDarkWallpaper = YES;
			else isDarkWallpaper = NO;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"safariWallpaperUpdateDynamicLabelColor" object:nil];
		}
	} else if ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark) {
		wallpaper = [GcImagePickerUtils imageFromDefaults:@"love.litten.safariwallpaperpreferences" withKey:@"wallpaperImageDark"];
		[UIView transitionWithView:wallpaperView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			[wallpaperView setImage:wallpaper];
		} completion:nil];

		if (useDynamicLabelColorSwitch && !useCustomLabelColorSwitch && wallpaper) {
			if ([libKitten isDarkImage:wallpaper]) isDarkWallpaper = YES;
			else isDarkWallpaper = NO;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"safariWallpaperUpdateDynamicLabelColor" object:nil];
		}
	}

}

%end

%hook BookmarkFavoritesGridView

- (void)didMoveToWindow { // hide bookmarks

	%orig;

	[self setHidden:hideBookmarksSwitch];

}

%end

%hook BookmarkFavoritesGridSectionHeaderView

- (id)initWithFrame:(CGRect)frame { // register notification observer

	if (useDynamicLabelColorSwitch && !useCustomLabelColorSwitch) [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDynamicLabelColor) name:@"safariWallpaperUpdateDynamicLabelColor" object:nil];

	return %orig;

}

- (void)didMoveToWindow { // hide bookmark headers and apply custom color

	%orig;

	UILabel* title = [self valueForKey:@"_titleLabel"];

	[title setHidden:hideBookmarkHeadersSwitch];

	if (useCustomLabelColorSwitch && !useDynamicLabelColorSwitch)
		[title setTextColor:[GcColorPickerUtils colorWithHex:customLabelColorValue]];

}

- (void)layoutSubviews { // update label colors

	%orig;
	
	if (useDynamicLabelColorSwitch) {
		[self updateDynamicLabelColor];
		return;
	}

	if (useCustomLabelColorSwitch && !useDynamicLabelColorSwitch) {
		UILabel* title = [self valueForKey:@"_titleLabel"];
		[title setTextColor:[GcColorPickerUtils colorWithHex:customLabelColorValue]];
	}

}

%new
- (void)updateDynamicLabelColor { // update dynamic label color

	if (!useDynamicLabelColorSwitch) return;

	UILabel* title = [self valueForKey:@"_titleLabel"];

	if (isDarkWallpaper)
		[title setTextColor:[UIColor whiteColor]];
	else
		[title setTextColor:[UIColor blackColor]];

}

%end

%hook BookmarkFavoriteView

- (id)initWithFrame:(CGRect)frame { // register notification observer

	if (useDynamicLabelColorSwitch && !useCustomLabelColorSwitch) [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDynamicLabelColor) name:@"safariWallpaperUpdateDynamicLabelColor" object:nil];

	return %orig;

}

- (void)didMoveToWindow { // hide bookmark titles and apply custom color

	%orig;

	VibrantLabelView* title = [self valueForKey:@"_titleLabel"];

	[title setHidden:hideBookmarkTitlesSwitch];

	if (useCustomLabelColorSwitch && !useDynamicLabelColorSwitch)
		[title setTextColor:[GcColorPickerUtils colorWithHex:customLabelColorValue]];

}

- (void)layoutSubviews { // update label colors

	%orig;
	
	if (useDynamicLabelColorSwitch) {
		[self updateDynamicLabelColor];
		return;
	}

	if (useCustomLabelColorSwitch && !useDynamicLabelColorSwitch) {
		VibrantLabelView* title = [self valueForKey:@"_titleLabel"];
		[title setTextColor:[GcColorPickerUtils colorWithHex:customLabelColorValue]];
	}

}

%new
- (void)updateDynamicLabelColor { // update dynamic label color
	
	if (!useDynamicLabelColorSwitch) return;

	VibrantLabelView* title = [self valueForKey:@"_titleLabel"];

	if (isDarkWallpaper)
		[title setTextColor:[UIColor whiteColor]];
	else
		[title setTextColor:[UIColor blackColor]];

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.safariwallpaperpreferences"];

	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	if (!enabled) return;

	// wallpaper
	[preferences registerObject:&wallpaperAlphaValue default:@"1.0" forKey:@"wallpaperAlpha"];

	// user interface based wallpaper
	[preferences registerBool:&useDifferentInterfaceWallpapersSwitch default:NO forKey:@"useDifferentInterfaceWallpapers"];

	// bookmarks
	[preferences registerBool:&hideBookmarksSwitch default:NO forKey:@"hideBookmarks"];
	[preferences registerBool:&hideBookmarkHeadersSwitch default:NO forKey:@"hideBookmarkHeaders"];
	[preferences registerBool:&hideBookmarkTitlesSwitch default:NO forKey:@"hideBookmarkTitles"];
	[preferences registerBool:&useDynamicLabelColorSwitch default:YES forKey:@"useDynamicLabelColor"];
	[preferences registerBool:&useCustomLabelColorSwitch default:NO forKey:@"useCustomLabelColor"];
	[preferences registerObject:&customLabelColorValue default:@"000000" forKey:@"customLabelColor"];

	%init(SafariWallpaper);

}