import 'dart:collection';
import 'dart:convert';

import 'package:bitirmes/GuiderPanel/bookings_list.dart';
import 'package:bitirmes/chat/chat_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// "id": 1,
// "name": "Taha",
// "surname": "Demir",
// "email": "taha.demir11@gmail.com",
// "phone": "055855588"

// "id": 14,
// "full_name": "lar lar",
// "phone": "0000000000",
// "rating": "0",
// "rate_count": 0,
// "available_days": "1,4",
// "guider_image": "https://firebasestorage.googleapis.com/v0/b/grad-proj-taha.appspot.com/o/images%2F1686037031008.jpg?alt=media&token=a391e7a8-b4f0-4e0c-8bc6-5a090a6637c7",
// "daily_price": 5,
// "bio": "Lisa;d",
// "images": [
//     "https://firebasestorage.googleapis.com/v0/b/grad-proj-taha.appspot.com/o/images%2F1686037033606.jpg?alt=media&token=22efb04e-ac22-4830-a788-5fd7dcb0858d",
//     "https://firebasestorage.googleapis.com/v0/b/grad-proj-taha.appspot.com/o/images%2F1686037033607.jpg?alt=media&token=fe9012ed-36a6-46ec-b99b-4e89fa43d5ea",
//     "https://firebasestorage.googleapis.com/v0/b/grad-proj-taha.appspot.com/o/images%2F1686037033602.jpg?alt=media&token=acb84eb2-bbda-40de-a249-20e6d9cc1386"
// ]

class User {
  static const path = "https://travel-application-api.herokuapp.com/api/";

  String _token = "";
  String _fullName = "";
  bool _isCustomer = false;
  int? id;

  // set the current state and store it for eache varible (token ,name, and surname )
  void set fullName(String newFullName) {
    _fullName = newFullName;

    () async {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('fullname', newFullName);
    }();
  }

  void deleteFullName() async {
    fullName = '';
  }

  String get fullName => _fullName;

  void set token(String newToken) {
    _token = newToken;
    () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', newToken);
    }();
  }

  void set isCustomer(bool newIsCustomer) {
    _isCustomer = newIsCustomer;
    () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isCustomer', newIsCustomer);
    }();
  }

  void deleteToken() async {
    token = '';
  }

  String get token => _token;
  bool get isCustomer => _isCustomer;
  bool get isGuider => !_isCustomer;

  User() {}

  Future<LinkedHashMap<String, dynamic>> login(email, password) async {
    var response = await http.post(
      Uri.parse(path + "login"),
      body: json.encode(
        {
          "email": email,
          "password": password,
        },
      ),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );
    var response_json = json.decode(response.body);
    if (response_json["status"] == 1) {
      this.token = response_json["access_token"];
      this.isCustomer = response_json["type"] != "guider";
    }
    return response_json;
  }

  Future<LinkedHashMap<String, dynamic>> addFavorite(placeId) async {
    var response = await http.post(Uri.parse(path + "add-favorite"),
        body: json.encode({
          "place_id": placeId,
        }),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer " + this.token
        });
    var response_json = json.decode(response.body);

    return response_json;
  }

  Future<LinkedHashMap<String, dynamic>> deleteFavorite(placeId) async {
    var url = Uri.parse(path + "favorite-place-delete/$placeId");

    var response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + this.token
      },
    );

    var response_json = json.decode(response.body);

    return response_json;
  }

  Future<List<MapPlace>?> listAllFavoritePlaces() async {
    var response =
        await http.get(Uri.parse(path + "customer-favorite-places"), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + this.token
    });

    final dec = json.decode(response.body);

    if (dec['status'] == 1) {
      final List<MapPlace> places = [];
      try {
        final data = dec['data'];
        for (var place in data) {
          try {
            final plc = MapPlace.fromJson(place);
            places.add(plc);
          } catch (e) {
            print(e);
          }
        }
      } catch (e) {
        print(e);
      }
      return places;
    } else {
      return null;
    }
  }

  Future<LinkedHashMap<String, dynamic>> profile() async {
    var response = await http.get(Uri.parse(path + "profile"), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + this.token
    });
    var response_json = json.decode(response.body);

    if (this.isGuider) {
      this.id = response_json["data"]["id"];
      this.fullName = response_json["data"]["full_name"];
    } else {
      this.id = response_json["data"]["id"];
      this.fullName = [
        response_json["data"]["name"],
        response_json["data"]["surname"]
      ].join(" ");
    }

    return response_json;
  }

  Future<Map<String, dynamic>> register(
    String name,
    String surname,
    String phone,
    String email,
    String password,
    String repassword,
  ) async {
    var response = await http.post(Uri.parse(path + "register"),
        body: json.encode({
          "name": name,
          "surname": surname,
          "phone": phone,
          "email": email,
          "password": password,
          "password_confirmation": repassword
        }),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });
    var response_json = json.decode(response.body);

    return response_json;
  }

  Future<Map<String, dynamic>> registerGuider(
    String name,
    String surname,
    String phone,
    String email,
    String password,
    String repassword,
    List<int> availableDays,
    String guiderImageLink,
    int dailyPrice,
    String bio,
    List<String> imagesLinks,
  ) async {
    final availableDaysStr = availableDays.join(",");

    var response = await http.post(
      Uri.parse(path + "register-guider"),
      body: json.encode(
        {
          "full_name": [name, surname].join(" "),
          "phone": phone,
          "email": email,
          "password": password,
          "password_confirmation": repassword,
          "available_days": availableDaysStr,
          "guider_image": guiderImageLink,
          "daily_price": dailyPrice,
          "bio": bio,
          "images": imagesLinks,
        },
      ),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );
    var response_json = json.decode(response.body);

    return response_json;
  }

  Future<Map<String, dynamic>> updateGuider(
    String fullName,
    List<int> availableDays,
    String guiderImageLink,
    int dailyPrice,
    String bio,
    List<String> imagesLinks,
  ) async {
    final availableDaysStr = availableDays.join(",");

    var response = await http.post(
      Uri.parse(path + "guider/edit"),
      body: json.encode(
        {
          "full_name": fullName,
          "available_days": availableDaysStr,
          "guider_image": guiderImageLink,
          "daily_price": dailyPrice,
          "bio": bio,
          "images": imagesLinks,
        },
      ),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + this.token
      },
    );
    var response_json = json.decode(response.body);

    return response_json;
  }

  Future<Guider?> getGuiderProfile() async {
    try {
      var response = await http.get(Uri.parse(path + "profile"), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + this.token
      });

      final dec = json.decode(response.body);

      if (dec["status"] == 1) {
        final guider = Guider.fromJson(dec["data"]);
        return guider;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<LinkedHashMap<String, dynamic>> logOut() async {
    var response = await http.get(Uri.parse(path + "logout"), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + this.token
    });
    print(json.decode(response.body).runtimeType);
    deleteFullName();
    deleteToken();
    return json.decode(response.body);
  }

  Future<LinkedHashMap<String, dynamic>> changePassword(
      String oldPassword, String newPassword, String reNewPassword) async {
    var response = await http.post(Uri.parse(path + "customer/change-password"),
        body: json.encode({
          "old_password": oldPassword,
          "new_password": newPassword,
          "new_password_confirmation": reNewPassword,
        }),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer " + this.token
        });

    return json.decode(response.body);
  }

  Future<List<MapPlace>?> getMapPlaces() async {
    var response = await http.get(
      Uri.parse(path + "list-all-places"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + this.token
      },
    );

    final dec = json.decode(response.body);

    if (dec['status'] == 1) {
      final List<MapPlace> places = [];
      try {
        final data = dec['data'];
        for (var place in data) {
          try {
            final plc = MapPlace.fromJson(place);
            places.add(plc);
          } catch (e) {
            print(e);
          }
        }
      } catch (e) {
        print(e);
      }
      return places;
    } else {
      return null;
    }
  }

  Future<List<BookingItemModel>?> getGuiderReservations() async {
    var response = await http.get(
      Uri.parse(path + "reservation/getReservationsOfGuider"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + this.token
      },
    );

    final dec = json.decode(response.body);

    if (dec['status'] == 1) {
      final List<BookingItemModel> places = [];
      try {
        final data = dec['data'];
        for (var place in data) {
          try {
            final plc = BookingItemModel.fromJson(place);
            places.add(plc);
          } catch (e) {
            print(e);
          }
        }
      } catch (e) {
        print(e);
      }
      return places;
    } else {
      return null;
    }
  }

  Future<List<BookingItemModel>?> getCustomerReservations() async {
    var response = await http.get(
      Uri.parse(path + "reservation/getReservationsOfCustomer"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + this.token
      },
    );

    final dec = json.decode(response.body);

    if (dec['status'] == 1) {
      final List<BookingItemModel> places = [];
      try {
        final data = List<Map<String, dynamic>>.from(dec['data']);
        for (var place in data) {
          try {
            final plc = BookingItemModel.fromJson(place);
            places.add(plc);
          } catch (e) {
            print(e);
          }
        }
      } catch (e) {
        print(e);
      }
      return places;
    } else {
      return null;
    }
  }

  Future<GuiderReservationList?> getGuiderReservedDates(int guiderId) async {
    var response = await http.get(
      Uri.parse(
        path + "guider/reservations/" + guiderId.toString(),
      ),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + this.token
      },
    );

    final dec = json.decode(response.body);

    try {
      final List<DateTime> dates = [];
      final data = dec['data'];
      for (var date in data) {
        try {
          final dt = DateTime.parse(date);
          dates.add(dt);
        } catch (e) {
          print(e);
        }
      }

      final GuiderReservationList reservations =
          GuiderReservationList(dates: dates);

      return reservations;
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<bool> reserveGuider({
    required int placeId,
    required int guiderId,
    required DateTime date,
    required int totalPrice,
  }) async {
    var response = await http.post(
      Uri.parse(
        path + "make_reservation",
      ),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + this.token
      },
      body: json.encode(
        {
          "total_price": totalPrice,
          "guider_id": guiderId,
          "place_id": placeId,
          // "date": "2023/05/21",
          "date": [
            date.year,
            date.month.toString().padLeft(2, '0'),
            date.day.toString().padLeft(2, '0'),
          ].join("/"),
        },
      ),
    );

    var response_json = json.decode(response.body);
    if (response_json["status"] == 1) {
      return true;
    }
    return false;
  }

  Future<bool> acceptReservation({required int reservationId}) async {
    var response = await http.put(
      Uri.parse(
        path + "reservation/accept/" + reservationId.toString(),
      ),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + this.token
      },
    );

    var response_json = json.decode(response.body);
    if (response_json["status"] == 1) {
      return true;
    }
    return false;
  }

  Future<bool> rejectReservation({required int reservationId}) async {
    var response = await http.put(
      Uri.parse(
        path + "reservation/reject/" + reservationId.toString(),
      ),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer " + this.token
      },
    );

    var response_json = json.decode(response.body);
    if (response_json["status"] == 1) {
      return true;
    }
    return false;
  }

  Future<Chat?> startChat({required int userId}) async {
    try {
      final res = await http.post(
        Uri.parse(
          path + "chat/start",
        ),
        body: json.encode(
          {
            if (isCustomer) "guider_id": userId else "customer_id": userId,
          },
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer " + this.token
        },
      );

      final dec = json.decode(res.body);

      if (dec['status'] == 1) {
        final chat = Chat.fromJson(dec['data']);

        return chat;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<List<Chat>?> getChats() async {
    try {
      final res = await http.get(
        Uri.parse(
          path + "chat/getChats",
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer " + this.token
        },
      );

      final dec = json.decode(res.body);

      if (dec['status'] == 1) {
        final List<Chat> chats = [];
        final data = List<Map<String, dynamic>>.from(dec['data']);
        for (var chat in data) {
          try {
            final cht = Chat.fromJson(chat);
            chats.add(cht);
          } catch (e) {
            print(e);
          }
        }

        return chats;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<bool> sendMessage({
    required int chatId,
    required DateTime date,
    required String body,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(
          path + "chat/sendMessage",
        ),
        body: json.encode(
          {
            "chat_id": chatId,
            "date": date.toIso8601String(),
            "body": body,
          },
        ),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer " + this.token
        },
      );

      final dec = json.decode(res.body);

      if (dec['status'] == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
}

class MapPlace {
  final int? id;
  final String? name;
  final String? city;
  final String? area;
  final String? desc;
  final double? latitude;
  final double? longitude;
  final String? rating;
  final int? rate_count;
  final List<Guider>? guiders;
  final List<String>? images;

  MapPlace({
    this.id,
    this.name,
    this.city,
    this.area,
    this.desc,
    this.latitude,
    this.longitude,
    this.rating,
    this.rate_count,
    this.guiders,
    this.images,
  });

  factory MapPlace.fromJson(Map<String, dynamic> json) {
    final ims = json['images'];

    List<String>? imgs = null;
    try {
      final firstImg = ims != null && ims.isNotEmpty ? ims[0] : null;
      if (firstImg != null) {
        if (firstImg is String) {
          imgs = List<String>.from(
            ims.map(
              (e) {
                return e.toString();
              },
            ).toList(),
          );
        } else {
          final imgsMap = List<Map<String, dynamic>>.from(json['images']);
          imgs = imgsMap.map(
            (e) {
              return e.values.elementAt(0).toString();
            },
          ).toList();
        }
      }
    } catch (e) {
      print(e);
    }
    return MapPlace(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      area: json['area'],
      desc: json['desc'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      rating: json['rating'],
      rate_count: json['rate_count'],
      guiders: json['guiders']
          ?.map<Guider>(
            (e) => Guider.fromJson(e),
          )
          .toList(),
      images: imgs,
    );
  }

  Marker? toMapMarker(void Function(MapPlace) onTap) {
    if (latitude == null || longitude == null) {
      return null;
    }

    try {
      final lat = latitude;
      final lng = longitude;

      if (lat == null || lng == null) {
        return null;
      }

      final marker = Marker(
        markerId: MarkerId(id.toString()),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: name,
          snippet: desc,
        ),
        onTap: () => onTap(this),
      );

      return marker;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class GuiderReservationList {
  final List<DateTime> dates;

  GuiderReservationList({
    required this.dates,
  });

  factory GuiderReservationList.fromJson(Map<String, dynamic> json) {
    return GuiderReservationList(
      dates: json['dates']
              ?.map<DateTime>(
                (e) => DateTime.parse(e),
              )
              ?.toList() ??
          [],
    );
  }
}

class Guider {
  final int? id;
  final String? fullName;
  final String? phone;
  final String? rating;
  final int? rateCount;
  final String? availableDays;
  final String? guiderImage;
  final int? dailyPrice;
  final String? bio;
  final List<String>? images;

  Guider({
    this.id,
    this.fullName,
    this.phone,
    this.rating,
    this.rateCount,
    this.availableDays,
    this.guiderImage,
    this.dailyPrice,
    this.bio,
    this.images,
  });

  String get workingDaysStr {
    final days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];

    final daysList = availableDays?.split(',') ?? [];

    final daysStr = daysList.map((e) => days[int.parse(e)]).join(', ');

    return daysStr;
  }

  List<int> get workingDays {
    final daysList = availableDays?.split(',') ?? [];

    final days = daysList.map((e) => int.parse(e)).toList();

    return days;
  }

  factory Guider.fromJson(Map<String, dynamic> json) {
    return Guider(
      id: json['id'],
      fullName: json['full_name'],
      phone: json['phone'],
      rating: json['rating'],
      rateCount: json['rate_count'],
      availableDays: json['available_days'],
      guiderImage: json['guider_image'],
      dailyPrice: json['daily_price'],
      bio: json['bio'],
      images: json['images']?.cast<String>(),
    );
  }
}

class Customer {
  final int id;
  final String name;
  final String surname;
  final String email;
  final String phone;

  String get fullName => "$name $surname";

  const Customer({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
