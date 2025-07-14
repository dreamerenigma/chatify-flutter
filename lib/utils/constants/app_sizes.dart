import '../../features/personalization/controllers/fonts_controller.dart';

class ChatifySizes {
  // Padding and margin sizes
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // Icon sizes
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;

  // Font sizes
  static double fontSizeLm = 12.0;
  static double fontSizeSm = 14.0;
  static double fontSizeMd = 16.0;
  static double fontSizeLg = 18.0;
  static double fontSizeBg = 20.0;
  static double fontSizeXl = 22.0;
  static double fontSizeMg = 24.0;
  static double fontSizeGl = 28.0;
  static double fontSizeUn = 34.0;
  static double fontSizeXxl = 38.0;

  static void updateFontSizes(FontMode fontMode) {
    switch (fontMode) {
      case FontMode.small:
        fontSizeLm = 10.0;
        fontSizeSm = 12.0;
        fontSizeMd = 14.0;
        fontSizeLg = 16.0;
        fontSizeBg = 18.0;
        fontSizeMg = 20.0;
        fontSizeGl = 24.0;
        break;
      case FontMode.big:
        fontSizeLm = 14.0;
        fontSizeSm = 16.0;
        fontSizeMd = 18.0;
        fontSizeLg = 20.0;
        fontSizeBg = 24.0;
        fontSizeMg = 28.0;
        fontSizeGl = 32.0;
        break;
      default:
        fontSizeLm = 12.0;
        fontSizeSm = 14.0;
        fontSizeMd = 16.0;
        fontSizeLg = 18.0;
        fontSizeBg = 20.0;
        fontSizeMg = 24.0;
        fontSizeGl = 28.0;
        break;
    }
  }

  // Button sizes
  static const double buttonElevation = 4.0;
  static const double buttonRadius = 12.0;
  static const double buttonHeight = 18.0;
  static const double buttonWidth = 120.0;

  // AppBar height
  static const double appBarHeight = 56.0;

  // Image sizes
  static const double imageThumbSize = 80.0;

  // Default spacing between sections
  static const double spaceBtwLittle = 10.0;
  static const double spaceBtwDefault = 12.0;
  static const double spaceBtwItemsSmall = 14.0;
  static const double spaceBtwItems = 16.0;
  static const double spaceBtwItemsDefault = 20.0;
  static const double defaultSpace = 24.0;
  static const double spaceBtwSections = 32.0;
  static const double spaceBtwSectionsExpanded = 36.0;

  // Border radius
  static const double borderRadiusSm = 4.0;
  static const double borderRadiusMd = 8.0;
  static const double borderRadiusLg = 12.0;
  static const double borderRadiusBg = 14.0;
  static const double borderRadiusXl = 16.0;
  static const double borderRadiusMg = 18.0;

  // Divider height
  static const double dividerHeight = 1.0;

  // Product item dimensions
  static const double productImageRadius = 16.0;
  static const double productImageSize = 120.0;
  static const double productItemHeight = 160.0;

  // Input field
  static const double inputFieldRadius = 12.0;
  static const double spaceBtwInputFields = 16.0;

  // Card sizes
  static const double cardElevation = 2.0;
  static const double cardRadiusXs = 6.0;
  static const double cardRadiusSm = 10.0;
  static const double cardRadiusMd = 12.0;
  static const double cardRadiusLg = 16.0;
  static const double cardRadiusBg = 20.0;
  static const double cardRadiusXl = 26.0;

  // Image carousel height
  static const double imageCarouselHeight = 200.0;

  // Loading indicator size
  static const double loadingIndicatorSize = 36.0;

  // Grid view spacing
  static const double gridViewSpacingSmall = 10.0;
  static const double gridViewSpacing = 16.0;
}
