import 'package:course_dilaundry/config/app_colors.dart';
import 'package:course_dilaundry/config/app_constants.dart';
import 'package:course_dilaundry/config/app_format.dart';
import 'package:course_dilaundry/models/shop_model.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.shop});
  final ShopModel shop;

  launchWA(BuildContext context, String number) async {
    bool? yes = await DInfo.dialogConfirmation(
        context, 'Chat via Whatsapp', 'Yes to confirm');

    if (yes ?? false) {
      const link = WhatsAppUnilink(
        phoneNumber: '6285163622875',
        text: 'Hello, I want to order a laundry service',
      );
      if (await canLaunchUrl(link.asUri())) {
        launchUrl(link.asUri(), mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          headerImage(context),
          const SizedBox(
            height: 10,
          ),
          groupItemInfo(context),
          const SizedBox(
            height: 20,
          ),
          category(),
          const SizedBox(
            height: 20,
          ),
          description(),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Order',
                  style:
                      TextStyle(height: 1, fontSize: 18, color: Colors.white),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Padding description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            shop.description,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          )
        ],
      ),
    );
  }

  Padding category() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Wrap(
            spacing: 8,
            children: [
              'Regular',
              'Express',
              'Economical',
              'Exlusive',
            ].map((e) {
              return Chip(
                  visualDensity: const VisualDensity(vertical: -4),
                  side: const BorderSide(
                    color: AppColors.primary,
                  ),
                  backgroundColor: Colors.white,
                  label: Text(
                    e,
                    style: const TextStyle(height: 1),
                  ));
            }).toList(),
          ),
        ],
      ),
    );
  }

  Padding groupItemInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                itemInfo(Icons.location_city_rounded, shop.city),
                const SizedBox(
                  height: 6,
                ),
                itemInfo(Icons.location_on, shop.location),
                const SizedBox(
                  height: 6,
                ),
                GestureDetector(
                    onTap: () => launchWA(context, shop.whatsapp),
                    child: itemInfo(Icons.call, '+${shop.whatsapp}'))
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(AppFormat.longPrice(shop.price),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      height: 1,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              const Text('/Kg')
            ],
          )
        ],
      ),
    );
  }

  Widget itemInfo(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 20,
          alignment: Alignment.centerLeft,
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        Expanded(
            child: Text(
          text,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ))
      ],
    );
  }

  Widget headerImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  '${AppConstants.baseImageURL}/shop/${shop.image}',
                  fit: BoxFit.cover,
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: 2,
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                      gradient: LinearGradient(
                          colors: [Colors.black, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter)),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: shop.rate,
                            itemCount: 5,
                            allowHalfRating: true,
                            itemPadding: const EdgeInsets.all(0),
                            unratedColor: Colors.grey[300],
                            itemSize: 12,
                            ignoreGestures: true,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (value) {},
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            '(${shop.rate})',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11),
                          )
                        ],
                      ),
                      !shop.pickup && !shop.delivery
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Row(
                                children: [
                                  if (shop.pickup) childOrder('Pickup'),
                                  if (shop.delivery)
                                    const SizedBox(
                                      width: 8,
                                    ),
                                  if (shop.delivery) childOrder('Delivery'),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 36,
              left: 16,
              child: SizedBox(
                height: 36,
                child: FloatingActionButton.extended(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.navigate_before_rounded,
                      color: Colors.black,
                    ),
                    heroTag: 'fab-back-button',
                    extendedPadding: const EdgeInsets.only(left: 10, right: 16),
                    backgroundColor: Colors.white,
                    extendedIconLabelSpacing: 0,
                    label: const Text(
                      'Back',
                      style: TextStyle(
                          height: 1, fontSize: 16, color: Colors.black),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container childOrder(String name) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColors.primary),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(color: Colors.white, height: 1),
          ),
          const SizedBox(
            width: 4,
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 14,
          )
        ],
      ),
    );
  }
}
