import 'package:course_dilaundry/config/app_assets.dart';
import 'package:course_dilaundry/config/app_colors.dart';
import 'package:course_dilaundry/config/app_constants.dart';
import 'package:course_dilaundry/config/app_format.dart';
import 'package:course_dilaundry/config/failure.dart';
import 'package:course_dilaundry/config/nav.dart';
import 'package:course_dilaundry/datasources/promo_datasource.dart';
import 'package:course_dilaundry/datasources/shop_datasource.dart';
import 'package:course_dilaundry/models/promo_model.dart';
import 'package:course_dilaundry/models/shop_model.dart';
import 'package:course_dilaundry/pages/detail_page.dart';
import 'package:course_dilaundry/pages/search_page.dart';
import 'package:course_dilaundry/pages/widgets/error_background.dart';
import 'package:course_dilaundry/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final edtSearch = TextEditingController();

  gotoSearchCity() {
    Nav.push(context, SearchPage(query: edtSearch.text));
  }

  getPromo() {
    PromoDatasource.readLimit().then(
      (value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure:
                setHomePromoStatus(ref, 'Server Error');
                break;
              case NotFoundFailure:
                setHomePromoStatus(ref, 'Error Not Found');
                break;
              case ForbiddenFailure:
                setHomePromoStatus(ref, 'You don\'t have access');
                break;
              case BadRequestFailure:
                setHomePromoStatus(ref, 'Bad request');
                break;
              case UnauthorizedFailure:
                setHomePromoStatus(ref, 'Unauthorised');
                break;
              default:
                setHomePromoStatus(ref, 'Request Error');
                break;
            }
          },
          (result) {
            setHomePromoStatus(ref, 'Success');
            List data = result['data'];
            List<PromoModel> promos =
                data.map((e) => PromoModel.fromJson(e)).toList();
            ref.read(homePromoListProvider.notifier).setData(promos);
          },
        );
      },
    );
  }

  getShopRecommendation() {
    ShopDatasource.readRecommendationLimit().then(
      (value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure:
                setHomeRecommendationStatus(ref, 'Server Error');
                break;
              case NotFoundFailure:
                setHomeRecommendationStatus(ref, 'Error Not Found');
                break;
              case ForbiddenFailure:
                setHomeRecommendationStatus(ref, 'You don\'t have access');
                break;
              case BadRequestFailure:
                setHomeRecommendationStatus(ref, 'Bad request');
                break;
              case UnauthorizedFailure:
                setHomeRecommendationStatus(ref, 'Unauthorised');
                break;
              default:
                setHomeRecommendationStatus(ref, 'Request Error');
                break;
            }
          },
          (result) {
            setHomeRecommendationStatus(ref, 'Success');
            List data = result['data'];
            List<ShopModel> shops =
                data.map((e) => ShopModel.fromJson(e)).toList();
            ref.read(homeRecommendationListProvider.notifier).setData(shops);
          },
        );
      },
    );
  }

  refresh() {
    getPromo();
    getShopRecommendation();
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => refresh(),
      child: ListView(
        children: [
          header(),
          categories(),
          const SizedBox(
            height: 20,
          ),
          promo(),
          const SizedBox(
            height: 20,
          ),
          recommendation(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Consumer recommendation() {
    return Consumer(
      builder: (_, wiRef, __) {
        List<ShopModel> list = wiRef.watch(homeRecommendationListProvider);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommendation',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(
                          color: AppColors.primary, fontSize: 14, height: 1),
                    ),
                  )
                ],
              ),
            ),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: ErrorBackground(
                    ratio: 1.2, message: 'No Recommendation Yet'),
              ),
            if (list.isNotEmpty)
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    ShopModel item = list[index];
                    return GestureDetector(
                      onTap: () {
                        Nav.push(context, DetailPage(shop: item));
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(index == 0 ? 30 : 10, 0,
                            index == list.length - 1 ? 30 : 10, 0),
                        width: 200,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage(
                                placeholder: const AssetImage(
                                    AppAssets.placeholderlaundry),
                                image: NetworkImage(
                                    '${AppConstants.baseImageURL}/shop/${item.image}'),
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.error));
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 150,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.black,
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter)),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              left: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: ['Regular', 'Express'].map(
                                      (e) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          margin:
                                              const EdgeInsets.only(right: 4),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.green
                                                  .withOpacity(0.8)),
                                          child: Text(
                                            e,
                                            style: const TextStyle(
                                                height: 1, color: Colors.white),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: GoogleFonts.ptSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            RatingBarIndicator(
                                              itemBuilder: (context, _) {
                                                return const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                );
                                              },
                                              itemCount: 5,
                                              itemSize: 12,
                                              rating: item.rate,
                                              itemPadding:
                                                  const EdgeInsets.all(0),
                                              unratedColor: Colors.grey[300],
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              '(${item.rate})',
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 11),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          item.location,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
          ],
        );
      },
    );
  }

  Consumer promo() {
    PageController pageController = PageController();
    return Consumer(
      builder: (_, wiRef, __) {
        List<PromoModel> list = wiRef.watch(homePromoListProvider);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Promo',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(
                          color: AppColors.primary, fontSize: 14, height: 1),
                    ),
                  )
                ],
              ),
            ),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: ErrorBackground(ratio: 16 / 9, message: 'No Promo'),
              ),
            if (list.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    PromoModel item = list[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: GestureDetector(
                        onTap: () {
                          Nav.push(context, DetailPage(shop: item.shop));
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage(
                                  placeholder: const AssetImage(
                                      AppAssets.placeholderlaundry),
                                  image: NetworkImage(
                                      '${AppConstants.baseImageURL}/promo/${item.image}'),
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.error));
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 6),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item.shop.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${AppFormat.shortPrice(item.newPrice)} /kg',
                                          style: const TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          '${AppFormat.shortPrice(item.oldPrice)} /kg',
                                          style: const TextStyle(
                                              color: Colors.red,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (list.isNotEmpty)
              const SizedBox(
                height: 8,
              ),
            if (list.isNotEmpty)
              SmoothPageIndicator(
                controller: pageController,
                count: list.length,
                effect: WormEffect(
                    dotWidth: 12,
                    dotHeight: 4,
                    dotColor: Colors.grey[300]!,
                    activeDotColor: AppColors.primary),
              )
          ],
        );
      },
    );
  }

  Consumer categories() {
    return Consumer(
      builder: (_, wiRef, __) {
        String categorySelected = wiRef.watch(homeCategoryProvider);
        return SizedBox(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstants.homeCategories.length,
            itemBuilder: (context, index) {
              String category = AppConstants.homeCategories[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(
                    index == 0 ? 30 : 8,
                    0,
                    index == AppConstants.homeCategories.length - 1 ? 30 : 8,
                    0),
                child: InkWell(
                  onTap: () {
                    setHomeCategory(ref, category);
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: categorySelected == category
                                ? Colors.green
                                : Colors.green[400]!),
                        color: categorySelected == category
                            ? Colors.green
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30)),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      category,
                      style: TextStyle(
                          height: 1,
                          color: categorySelected == category
                              ? Colors.white
                              : Colors.black54),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Padding header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We\'re ready',
            style:
                GoogleFonts.ptSans(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'to clean your clothes',
            style: GoogleFonts.ptSans(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_city_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Find by city',
                    style: TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.grey[600]),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () => gotoSearchCity(),
                                icon: const Icon(Icons.search_rounded)),
                            Expanded(
                              child: TextField(
                                controller: edtSearch,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search...',
                                ),
                                onSubmitted: (value) => gotoSearchCity(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Center(
                        child: Icon(
                          Icons.tune,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
