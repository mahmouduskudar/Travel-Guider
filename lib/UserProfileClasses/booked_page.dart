import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:flutter/material.dart';

import '../GuiderPanel/bookings_list.dart';

class BookedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorItems.projectBackground,
      appBar: AppBar(
        title: const Text(
          'Booked',
        ),
      ),
      body: Builder(
        builder: (context) {
          return _BookingList();
        },
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  const _BookingList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LoginFormPage.currentCustomer.getCustomerReservations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final items = snapshot.data as List<BookingItemModel>?;

        if (items == null || items.isEmpty) {
          return const Center(
            child: Text('No bookings yet'),
          );
        }

        return GridView.builder(
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            return _BookingListItem(
              item: items[index],
            );
          },
        );
      },
    );
  }
}

class _BookingListItem extends StatelessWidget {
  final BookingItemModel item;
  const _BookingListItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Builder(
            builder: (context) {
              final place = item.place;
              final images = place.images;
              String? mainImage;

              if (images != null && images.isNotEmpty) {
                mainImage = images[0];
              }

              return Row(
                children: [
                  CircleAvatar(
                    backgroundImage: mainImage == null
                        ? null
                        : NetworkImage(
                            mainImage,
                          ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    place.name ?? '',
                  ),
                ],
              );
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_month),
                  const SizedBox(
                    width: 8,
                  ),
                  Builder(builder: (context) {
                    final dt = item.date;
                    final dtStr = [
                      dt.day.toString().padLeft(2, '0'),
                      dt.month.toString().padLeft(2, '0'),
                      dt.year.toString(),
                    ].join('/');

                    return Text(
                      dtStr,
                    );
                  }),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.person),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    item.guider?.fullName ?? '',
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.money),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    item.totalPrice,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
