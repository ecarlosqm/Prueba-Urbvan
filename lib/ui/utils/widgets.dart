import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(
  BuildContext context,
  String title,
  String description,
  VoidCallback onConfirm,
) async {
  final buttonTextStyle = const TextStyle(fontSize: 18);
  final titleTextStyle = const TextStyle(fontSize: 20);
  final descriptionTextStyle = const TextStyle(fontSize: 17);
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  description,
                  style: descriptionTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  child: Text(
                    "Cancelar",
                    style: buttonTextStyle,
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(20))),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              Expanded(
                child: TextButton(
                  child: Text(
                    "Confirmar",
                    style: buttonTextStyle,
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(20))),
                  onPressed: () {
                    onConfirm.call();
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<bool?> showMessage(
  BuildContext context,
  String title,
  String description,
) async {
  final buttonTextStyle = const TextStyle(fontSize: 18);
  final titleTextStyle = const TextStyle(fontSize: 20);
  final descriptionTextStyle = const TextStyle(fontSize: 17);
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  description,
                  style: descriptionTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  child: Text(
                    "Ok",
                    style: buttonTextStyle,
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(20))),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

showImageModal(BuildContext context, String url) {
  showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(5),
            child: FadeInImage.assetNetwork(
              fadeInDuration: Duration(milliseconds: 200),
              fadeOutDuration: Duration(milliseconds: 200),
              image: url,
              placeholder: "assets/images/meal_image_placeholder.png",
              fit: BoxFit.fitHeight,
            ),
          ));
}

Future<T?> navigateTo<T>(BuildContext context, Widget page) {
  return Navigator.of(context)
      .push<T>(MaterialPageRoute(builder: (context) => page));
}
