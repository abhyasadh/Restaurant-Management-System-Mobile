import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_app/features/favourites/data/model/favourites_hive_model.dart';
import 'package:restaurant_app/features/orders/data/model/order_hive_model.dart';

import '../../../config/constants/hive_table_constant.dart';

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    Hive.registerAdapter(OrderHiveModelAdapter());
    Hive.registerAdapter(FavouritesHiveModelAdapter());
  }

  // ======================== Local Order Queries ========================
  Future<String> addLocalOrder(OrderHiveModel order) async {
    var box = await Hive.openBox<OrderHiveModel>(HiveTableConstant.localOrderBox);
    await box.put(order.orderId, order);
    await box.close();
    return order.orderId;
  }

  Future<OrderHiveModel?> getLocalOrder(String key) async {
    var box = await Hive.openBox<OrderHiveModel>(HiveTableConstant.localOrderBox);
    var order = box.get(key);
    await box.close();
    return order;
  }

  Future<List<OrderHiveModel>> getAllLocalOrders() async {
    var box = await Hive.openBox<OrderHiveModel>(HiveTableConstant.localOrderBox);
    var orders = box.values.toList();
    await box.close();
    return orders;
  }

  Future<void> deleteAnOrder(String key) async {
    var box = await Hive.openBox<OrderHiveModel>(HiveTableConstant.localOrderBox);
    await box.delete(key);
    await box.close();
  }

  Future<List<OrderHiveModel>> clearLocalOrders() async {
    var box = await Hive.openBox<OrderHiveModel>(HiveTableConstant.localOrderBox);
    var orders = box.values.toList();
    await box.clear();
    box.close();
    return orders;
  }

  // ======================== Remote Order Queries ========================
  Future<String> addRemoteOrder(OrderHiveModel order) async {
    var box = await Hive.openBox<OrderHiveModel>(HiveTableConstant.remoteOrderBox);
    await box.put(order.orderId, order);
    await box.close();
    return order.orderId;
  }

  Future<List<OrderHiveModel>> getAllRemoteOrders() async {
    var box = await Hive.openBox<OrderHiveModel>(HiveTableConstant.remoteOrderBox);
    var orders = box.values.toList();
    await box.close();
    return orders;
  }

  Future<List<OrderHiveModel>> clearRemoteOrders() async {
    var box = await Hive.openBox<OrderHiveModel>(HiveTableConstant.remoteOrderBox);
    var orders = box.values.toList();
    await box.clear();
    box.close();
    return orders;
  }

  //========================= Favourites Queries ========================
  Future<void> addFavourites(List<FavouritesHiveModel> favourites) async {
    var box = await Hive.openBox<FavouritesHiveModel>(HiveTableConstant.favouriteBox);
    await box.clear();
    await box.addAll(favourites);
    await box.close();
  }

  Future<List<FavouritesHiveModel>> getFavourites() async {
    var box = await Hive.openBox<FavouritesHiveModel>(HiveTableConstant.favouriteBox);
    var list = box.values.toList();
    await box.close();
    return list;
  }

  // ============================= Close Hive ===========================
  Future<void> closeHive() async {
    await Hive.close();
  }

  // ============================= Delete Hive ===========================
  Future<void> deleteHive() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.localOrderBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.remoteOrderBox);
    await Hive.deleteFromDisk();
  }
}
