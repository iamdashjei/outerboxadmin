// import 'package:moor_flutter/moor_flutter.dart';
//
// part 'database.g.dart';
//
// class TbOrdersByTable extends Table {
//   TextColumn get tableId => text().withLength(min: 1, max: 50)();
//
//   TextColumn get name => text().withLength(min: 1, max: 50)();
// }
//
// class TbOrdersItem extends Table {
//   IntColumn get id => integer().autoIncrement()();
//
//   TextColumn get orderId => text().withLength(min: 1, max: 50)();
//
//   TextColumn get tableId => text().withLength(min: 1, max: 50)();
//
//   TextColumn get orderName => text().withLength(min: 1, max: 50)();
//
//   IntColumn get orderQuantity => integer()();
//
//   DateTimeColumn get orderCreated => dateTime().withDefault(Constant(DateTime.now()))();
//
//   IntColumn get startTimer => integer().withDefault(Constant(1))();
//
//   DateTimeColumn get orderCompleted => dateTime().nullable()();
//
//   BoolColumn get isComplete => boolean().withDefault(Constant(false))();
//
//   BoolColumn get isTakeOut => boolean().withDefault(Constant(false))();
// }
//
// class TableWithOrders {
//   String tableName;
//   String orderId;
//   String tableId;
//   int orderQuantity;
//   int startTimer;
//   DateTime orderCreated;
//   DateTime orderCompleted;
//   bool isComplete;
//   bool isTakeOut;
// }
//
// @UseMoor(
//     tables: [TbOrdersByTable, TbOrdersItem],
//     queries : {
//       'tableWithOrders':'SELECT a.name, b.id, b.table_id, b.order_id, b.order_name, b.order_quantity, b.order_created, b.order_completed, b.is_complete, b.is_take_out, b.start_timer FROM tb_orders_by_table a LEFT OUTER JOIN tb_orders_item b ON a.table_id = b.table_id order by b.order_created asc',
//       'updateOrderQuantityByTableIdAndOrderIdAndIsTakeOut': 'UPDATE tb_orders_item SET order_quantity = ? WHERE table_id = ? AND order_id = ? AND is_take_out = ? AND is_complete = 0 AND id = ?',
//       'countUnProcessOrders': 'SELECT COUNT(*) FROM tb_orders_item WHERE is_complete = 0'
// })
// class LocalDatabase extends _$LocalDatabase {
//   LocalDatabase() : super((FlutterQueryExecutor.inDatabaseFolder(
//     path: 'kitchen.sql', logStatements: true,)));
//
//   @override
//   int get schemaVersion => 1;
//
//   Future insertOrdersTable(String tableId, String name) async {
//     return into(tbOrdersByTable).insert(TbOrdersByTableCompanion(
//         tableId: Value(tableId),
//         name: Value(name)
//     ));
//   }
//
//   Future insertItemOrders(String orderId, String tableId, String orderName, int orderQuantity, bool isComplete, bool isTakeOut) {
//     return into(tbOrdersItem).insert(TbOrdersItemCompanion(
//         orderId: Value(orderId),
//       tableId: Value(tableId),
//       orderName: Value(orderName),
//       orderQuantity: Value(orderQuantity),
//       startTimer: Value(1),
//       orderCreated: Value(DateTime.now()),
//       isComplete: Value(isComplete),
//       isTakeOut: Value(isTakeOut),
//     ));
//   }
//
//   Future<List<TbOrdersByTableData>> watchOrdersByTable() => select(tbOrdersByTable, distinct: true).get();
//
//   Future<List<TableWithOrdersResult>> watchTableWithOrders() {
//     return tableWithOrders().get();
//   }
//
//   Future processOrder(int quantity, String tableId, String orderId, bool isTakeOut, int id) {
//     return transaction(() async {
//       await updateOrderQuantityByTableIdAndOrderIdAndIsTakeOut(quantity, tableId, orderId, isTakeOut, id);
//     });
//   }
//
//   Future<int> checkOrders() async => (await (select(tbOrdersItem)..where((tbl) => tbl.orderQuantity.isBiggerThanValue(0))).get()).length;
//
//   Future deleteAll() {
//     delete(tbOrdersByTable).go();
//     return delete(tbOrdersItem).go();
//   }
// }