import "package:flutter/material.dart";

class GridWidget extends StatefulWidget {
  const GridWidget({super.key});

  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  bool isRow(int index) {
    return index % 11 == 0;
  }

  int rowNumber(int index) {
    return index ~/ 11;
  }

  bool isCol(int index) {
    return index < 11;
  }

  int colNumber(int index) {
    return index % 11;
  }

  bool isLabel(int index) {
    return isRow(index) || isCol(index);
  }

  String getLabel(int index) {
    if (index == 0) return "";

    if (isRow(index)) {
      // return A, B, C, ...
      return String.fromCharCode(64 + rowNumber(index));
    } else if (isCol(index)) {
      return colNumber(index).toString();
    }

    return "";
  }

  getCellColor(int index) {
    if (index == 0) return Colors.transparent;

    int colorIntensity =
        Theme.of(context).brightness == Brightness.light ? 100 : 400;

    return ((isLabel(index)
            ? Colors.green[colorIntensity]
            : Colors.blue[colorIntensity])
        ?.withOpacity(0.5));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 11,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) => Container(
        decoration: index == 0
            ? null
            : BoxDecoration(
                color: getCellColor(index),
                border: Border.all(
                  color: Colors.grey[400]!,
                  width: 1,
                ),
              ),
        alignment: Alignment.center,
        child: Text(
          getLabel(index),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      itemCount: 11 * 11,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
