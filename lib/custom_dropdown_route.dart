import 'package:dropdown_recreation/custom_dropdown.dart';
import 'package:flutter/material.dart';

import 'dropdown_item.dart';

class CustomDropdownRoute<T> extends PopupRoute<T> {
  final Map<String, DropdownItem<T>> options;
  final DropdownItemSelectedCallback<T> itemSelected;
  final DropdownItemBuilder<T> itemBuilder;

  /// The rectangle that defines the position and size of the button that opened this dropdown.
  /// Used for layout and positioning of the dropdown list.
  final Rect sourceButtonRect;

  static const _transitionMillis = 100;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: _transitionMillis);

  CustomDropdownRoute({
    required this.options,
    required this.itemSelected,
    required this.itemBuilder,
    required this.sourceButtonRect,
  });

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    // We need to wrap it in a stack so that we can position the dropdown menu relative to the source button with
    // a Positioned widget.
    return Stack(
      children: [
        Positioned(
          left: sourceButtonRect.left,
          top: sourceButtonRect.top + sourceButtonRect.height,
          // Can customize this to show more or less items
          height: sourceButtonRect.height * 8,
          width: sourceButtonRect.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CustomScrollView(
              shrinkWrap: true,
              scrollBehavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
                overscroll: false,
                physics: const ClampingScrollPhysics(),
                platform: Theme.of(context).platform,
              ),
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final entry = options.entries.elementAt(index);
                    final key = entry.key;
                    final item = entry.value;
                    final button = FilledButton(
                      onPressed: () => item.isGroupTitle ? null : itemSelected(key, item),
                      style: ButtonStyle(shape: WidgetStateProperty.all(const ContinuousRectangleBorder())),
                      child: itemBuilder(item, false),
                    );

                    // Don't want the item to appear selectable if it is a group title, so make sure
                    // To ignore the pointer.
                    return item.isGroupTitle ? IgnorePointer(child: button) : button;
                  }, childCount: options.length),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
