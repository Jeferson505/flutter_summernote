class BottomToolbarLabels {
  /// **Label for copy option**
  ///
  /// Default value is:
  /// ```dart
  /// "Copy"
  /// ```
  final String copyLabel;

  /// **Label for paste option**
  ///
  /// Default value is:
  /// ```dart
  /// "Paste"
  /// ```
  final String pasteLabel;

  /// **Label for attachment option**
  ///
  /// Default value is:
  /// ```dart
  /// "Attach"
  /// ```
  final String attachmentLabel;

  /// **Label for camera attachment option**
  ///
  /// Default value is:
  /// ```dart
  /// "Camera"
  /// ```
  final String cameraLabel;

  /// **Label for gallery attachment option**
  ///
  /// Default value is:
  /// ```dart
  /// "Gallery"
  /// ```
  final String galleryLabel;

  /// **Description for camera attachment option**
  ///
  /// Default value is:
  /// ```dart
  /// "Attach image from camera"
  /// ```
  final String cameraAttachmentDescriptionLabel;

  /// **Description for gallery attachment option**
  ///
  /// Default value is:
  /// ```dart
  /// "Attach image from gallery"
  /// ```
  final String galleryAttachmentDescriptionLabel;

  const BottomToolbarLabels({
    this.copyLabel = "Copy",
    this.pasteLabel = "Paste",
    this.attachmentLabel = "Attach",
    this.cameraLabel = "Camera",
    this.galleryLabel = "Gallery",
    this.cameraAttachmentDescriptionLabel = "Attach image from camera",
    this.galleryAttachmentDescriptionLabel = "Attach image from gallery",
  });
}
