import 'package:bitirmes/ObjectClasses/customer.dart';
import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

enum ApprovalStatus {
  undefined,
  approved,
  denied;

  static ApprovalStatus fromString(String status) {
    switch (status) {
      case "waiting":
        return ApprovalStatus.undefined;
      case "accepted":
        return ApprovalStatus.approved;
      case "rejected":
        return ApprovalStatus.denied;
      default:
        return ApprovalStatus.undefined;
    }
  }

  bool get isApproved => this == ApprovalStatus.approved;
  bool get isDenided => this == ApprovalStatus.denied;
  bool get isUndefined => this == ApprovalStatus.undefined;
  bool get isDefined => !isUndefined;
}

class BookingItemModel {
  final int id;
  final int customerId;
  final int guiderId;
  final int placeId;
  final DateTime date;
  final String totalPrice;
  final ApprovalStatus approvalStatus;
  final BookingCustomer? customer;
  final BookingGuider? guider;
  final MapPlace place;

  BookingItemModel({
    required this.id,
    required this.customerId,
    required this.guiderId,
    required this.placeId,
    required this.date,
    required this.totalPrice,
    required this.approvalStatus,
    required this.customer,
    required this.guider,
    required this.place,
  });

  // fromjson
  factory BookingItemModel.fromJson(Map<String, dynamic> json) {
    return BookingItemModel(
      id: json['id'],
      customerId: json['customer_id'],
      guiderId: json['guider_id'],
      placeId: json['place_id'],
      date: DateTime.parse(json['date']),
      totalPrice: json['total_price'],
      approvalStatus: ApprovalStatus.fromString(
        json['approval_status'],
      ),
      customer: json['customer'] != null
          ? BookingCustomer.fromJson(json['customer'])
          : null,
      guider: json['guider'] != null
          ? BookingGuider.fromJson(json['guider'])
          : null,
      place: MapPlace.fromJson(json['place']),
    );
  }

  // copywith
  BookingItemModel copyWith({
    int? id,
    int? customerId,
    int? guiderId,
    int? placeId,
    DateTime? date,
    String? totalPrice,
    ApprovalStatus? approvalStatus,
    BookingCustomer? customer,
    MapPlace? place,
  }) {
    return BookingItemModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      guiderId: guiderId ?? this.guiderId,
      placeId: placeId ?? this.placeId,
      date: date ?? this.date,
      totalPrice: totalPrice ?? this.totalPrice,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      customer: customer ?? this.customer,
      guider: guider ?? this.guider,
      place: place ?? this.place,
    );
  }
}

class BookingCustomer {
  final String name;
  final String surname;
  final String email;
  final String phone;

  BookingCustomer({
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
  });

  factory BookingCustomer.fromJson(Map<String, dynamic> json) {
    return BookingCustomer(
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

class BookingGuider {
  final int id;
  final String fullName;
  final String phone;
  final String rating;
  final int rateCount;
  final String availableDays;
  final String? guiderImage;
  final int dailyPrice;
  final String bio;

  BookingGuider({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.rating,
    required this.rateCount,
    required this.availableDays,
    required this.guiderImage,
    required this.dailyPrice,
    required this.bio,
  });

  factory BookingGuider.fromJson(Map<String, dynamic> json) {
    return BookingGuider(
      id: json['id'],
      fullName: json['full_name'],
      phone: json['phone'],
      rating: json['rating'],
      rateCount: json['rate_count'],
      availableDays: json['available_days'],
      guiderImage: json['guider_image'],
      dailyPrice: json['daily_price'],
      bio: json['bio'],
    );
  }
}

class BookingsList extends StatefulWidget {
  const BookingsList({super.key});

  @override
  State<BookingsList> createState() => _BookingsListState();
}

class _BookingsListState extends State<BookingsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _BookingListBody(),
    );
  }
}

class _BookingListBody extends StatelessWidget {
  const _BookingListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LoginFormPage.currentCustomer.getGuiderReservations(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final items = snapshot.data as List<BookingItemModel>;

        return _BookingItemsList(
          items: items,
        );
      },
    );
  }
}

class _BookingItemsList extends StatefulWidget {
  final List<BookingItemModel> items;
  const _BookingItemsList({
    super.key,
    required this.items,
  });

  @override
  State<_BookingItemsList> createState() =>
      __BookingItemsListState(items: items);
}

class __BookingItemsListState extends State<_BookingItemsList> {
  List<BookingItemModel> items;

  __BookingItemsListState({
    required this.items,
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return BookingItem(
          item: item,
          setItemApproval: (ApprovalStatus status) {
            var newItem = item.copyWith(
              approvalStatus: status,
            );
            items = items.map(
              (e) {
                if (e.id == newItem.id) {
                  return newItem;
                }

                return e;
              },
            ).toList();

            setState(() {});
          },
        );
      },
    );
  }
}

class BookingItem extends StatelessWidget {
  final BookingItemModel item;
  final Function(ApprovalStatus status) setItemApproval;
  const BookingItem({
    Key? key,
    required this.item,
    required this.setItemApproval,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Builder(builder: (context) {
          final place = item.place;

          final placeImgs = place.images;
          String? placeImg;
          if (placeImgs != null && placeImgs.isNotEmpty) {
            placeImg = placeImgs[0];
          }

          return ListTile(
            leading: placeImg == null
                ? null
                : CircleAvatar(
                    backgroundImage: NetworkImage(
                      placeImg,
                    ),
                    radius: 32.0,
                  ),
            title: Text(
              place.name ?? '',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16.0,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      [
                        item.date.day.toString().padLeft(2, '0'),
                        item.date.month.toString().padLeft(2, '0'),
                        item.date.year
                      ].join('/'),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16.0,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      item.customer?.name ?? '',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 16.0,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      item.totalPrice,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
              ],
            ),
            trailing: SizedBox(
              width: 100,
              child: Builder(builder: (context) {
                final stat = item.approvalStatus;
                if (stat.isDefined) {
                  if (stat.isApproved) {
                    return Center(child: Text('approved'));
                  } else {
                    return Center(child: Text('denied'));
                  }
                }

                return Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () async {
                        try {
                          await EasyLoading.show(status: 'Loading...');

                          final accepted = await LoginFormPage.currentCustomer
                              .acceptReservation(reservationId: item.id);

                          if (accepted) {
                            setItemApproval(ApprovalStatus.approved);
                          } else {
                            EasyLoading.showError('Failed to accept');
                          }

                          EasyLoading.dismiss();
                        } catch (e) {
                          EasyLoading.dismiss();
                          EasyLoading.showError(e.toString());
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () async {
                        try {
                          await EasyLoading.show(status: 'Loading...');

                          final accepted = await LoginFormPage.currentCustomer
                              .rejectReservation(reservationId: item.id);

                          if (accepted) {
                            setItemApproval(ApprovalStatus.denied);
                          } else {
                            EasyLoading.showError('Failed to reject');
                          }

                          EasyLoading.dismiss();
                        } catch (e) {
                          EasyLoading.dismiss();
                          EasyLoading.showError(e.toString());
                        }
                      },
                    ),
                  ],
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
