#import "GcUniversal/GcImagePickerUtils.h"
#import "GcUniversal/GcColorPickerUtils.h"
#import <Kitten/libKitten.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;
BOOL enabled = NO;

UIImageView* wallpaperView = nil;
UIImage* wallpaper = nil;
BOOL isDarkWallpaper = YES;

// wallpaper
NSString* wallpaperAlphaValue = @"1.0";

// user interface based wallpaper
BOOL useDifferentInterfaceWallpapersSwitch = NO;

// bookmarks
BOOL hideBookmarksSwitch = NO;
BOOL hideBookmarkHeadersSwitch = NO;
BOOL hideBookmarkTitlesSwitch = NO;
BOOL useDynamicLabelColorSwitch = YES;
BOOL useCustomLabelColorSwitch = NO;
NSString* customLabelColorValue = @"000000";

@interface CatalogViewController : UIViewController
@end

@interface BookmarkFavoritesGridView : UIView
@end

@interface VibrantLabelView : UILabel
@end

@interface BookmarkFavoritesGridSectionHeaderView : UIView
- (void)updateDynamicLabelColor;
@end

@interface BookmarkFavoriteView : UIView
- (void)updateDynamicLabelColor;
@end