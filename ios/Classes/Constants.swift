import Nbmap

/*
 * The mapping is based on the values defined here:
 */

class Constants {
    static let symbolIconAnchorMapping = [
        "center": NGLIconAnchor.center,
        "left": NGLIconAnchor.left,
        "right": NGLIconAnchor.right,
        "top": NGLIconAnchor.top,
        "bottom": NGLIconAnchor.bottom,
        "top-left": NGLIconAnchor.topLeft,
        "top-right": NGLIconAnchor.topRight,
        "bottom-left": NGLIconAnchor.bottomLeft,
        "bottom-right": NGLIconAnchor.bottomRight,
    ]

    static let symbolTextJustificationMapping = [
        "auto": NGLTextJustification.auto,
        "center": NGLTextJustification.center,
        "left": NGLTextJustification.left,
        "right": NGLTextJustification.right,
    ]

    static let symbolTextAnchorMapping = [
        "center": NGLTextAnchor.center,
        "left": NGLTextAnchor.left,
        "right": NGLTextAnchor.right,
        "top": NGLTextAnchor.top,
        "bottom": NGLTextAnchor.bottom,
        "top-left": NGLTextAnchor.topLeft,
        "top-right": NGLTextAnchor.topRight,
        "bottom-left": NGLTextAnchor.bottomLeft,
        "bottom-right": NGLTextAnchor.bottomRight,
    ]

    static let symbolTextTransformationMapping = [
        "none": NGLTextTransform.none,
        "lowercase": NGLTextTransform.lowercase,
        "uppercase": NGLTextTransform.uppercase,
    ]

    static let lineJoinMapping = [
        "bevel": NGLLineJoin.bevel,
        "miter": NGLLineJoin.miter,
        "round": NGLLineJoin.round,
    ]
}
