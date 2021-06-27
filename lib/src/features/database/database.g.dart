// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'database.dart';
//
// // **************************************************************************
// // MoorGenerator
// // **************************************************************************
//
// // ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
// class TbOrdersByTableData extends DataClass
//     implements Insertable<TbOrdersByTableData> {
//   final String tableId;
//   final String name;
//   TbOrdersByTableData({@required this.tableId, @required this.name});
//   factory TbOrdersByTableData.fromData(
//       Map<String, dynamic> data, GeneratedDatabase db,
//       {String prefix}) {
//     final effectivePrefix = prefix ?? '';
//     final stringType = db.typeSystem.forDartType<String>();
//     return TbOrdersByTableData(
//       tableId: stringType
//           .mapFromDatabaseResponse(data['${effectivePrefix}table_id']),
//       name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
//     );
//   }
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (!nullToAbsent || tableId != null) {
//       map['table_id'] = Variable<String>(tableId);
//     }
//     if (!nullToAbsent || name != null) {
//       map['name'] = Variable<String>(name);
//     }
//     return map;
//   }
//
//   TbOrdersByTableCompanion toCompanion(bool nullToAbsent) {
//     return TbOrdersByTableCompanion(
//       tableId: tableId == null && nullToAbsent
//           ? const Value.absent()
//           : Value(tableId),
//       name: name == null && nullToAbsent ? const Value.absent() : Value(name),
//     );
//   }
//
//   factory TbOrdersByTableData.fromJson(Map<String, dynamic> json,
//       {ValueSerializer serializer}) {
//     serializer ??= moorRuntimeOptions.defaultSerializer;
//     return TbOrdersByTableData(
//       tableId: serializer.fromJson<String>(json['tableId']),
//       name: serializer.fromJson<String>(json['name']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer serializer}) {
//     serializer ??= moorRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'tableId': serializer.toJson<String>(tableId),
//       'name': serializer.toJson<String>(name),
//     };
//   }
//
//   TbOrdersByTableData copyWith({String tableId, String name}) =>
//       TbOrdersByTableData(
//         tableId: tableId ?? this.tableId,
//         name: name ?? this.name,
//       );
//   @override
//   String toString() {
//     return (StringBuffer('TbOrdersByTableData(')
//           ..write('tableId: $tableId, ')
//           ..write('name: $name')
//           ..write(')'))
//         .toString();
//   }
//
//   @override
//   int get hashCode => $mrjf($mrjc(tableId.hashCode, name.hashCode));
//   @override
//   bool operator ==(dynamic other) =>
//       identical(this, other) ||
//       (other is TbOrdersByTableData &&
//           other.tableId == this.tableId &&
//           other.name == this.name);
// }
//
// class TbOrdersByTableCompanion extends UpdateCompanion<TbOrdersByTableData> {
//   final Value<String> tableId;
//   final Value<String> name;
//   const TbOrdersByTableCompanion({
//     this.tableId = const Value.absent(),
//     this.name = const Value.absent(),
//   });
//   TbOrdersByTableCompanion.insert({
//     @required String tableId,
//     @required String name,
//   })  : tableId = Value(tableId),
//         name = Value(name);
//   static Insertable<TbOrdersByTableData> custom({
//     Expression<String> tableId,
//     Expression<String> name,
//   }) {
//     return RawValuesInsertable({
//       if (tableId != null) 'table_id': tableId,
//       if (name != null) 'name': name,
//     });
//   }
//
//   TbOrdersByTableCompanion copyWith(
//       {Value<String> tableId, Value<String> name}) {
//     return TbOrdersByTableCompanion(
//       tableId: tableId ?? this.tableId,
//       name: name ?? this.name,
//     );
//   }
//
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (tableId.present) {
//       map['table_id'] = Variable<String>(tableId.value);
//     }
//     if (name.present) {
//       map['name'] = Variable<String>(name.value);
//     }
//     return map;
//   }
//
//   @override
//   String toString() {
//     return (StringBuffer('TbOrdersByTableCompanion(')
//           ..write('tableId: $tableId, ')
//           ..write('name: $name')
//           ..write(')'))
//         .toString();
//   }
// }
//
// class $TbOrdersByTableTable extends TbOrdersByTable
//     with TableInfo<$TbOrdersByTableTable, TbOrdersByTableData> {
//   final GeneratedDatabase _db;
//   final String _alias;
//   $TbOrdersByTableTable(this._db, [this._alias]);
//   final VerificationMeta _tableIdMeta = const VerificationMeta('tableId');
//   GeneratedTextColumn _tableId;
//   @override
//   GeneratedTextColumn get tableId => _tableId ??= _constructTableId();
//   GeneratedTextColumn _constructTableId() {
//     return GeneratedTextColumn('table_id', $tableName, false,
//         minTextLength: 1, maxTextLength: 50);
//   }
//
//   final VerificationMeta _nameMeta = const VerificationMeta('name');
//   GeneratedTextColumn _name;
//   @override
//   GeneratedTextColumn get name => _name ??= _constructName();
//   GeneratedTextColumn _constructName() {
//     return GeneratedTextColumn('name', $tableName, false,
//         minTextLength: 1, maxTextLength: 50);
//   }
//
//   @override
//   List<GeneratedColumn> get $columns => [tableId, name];
//   @override
//   $TbOrdersByTableTable get asDslTable => this;
//   @override
//   String get $tableName => _alias ?? 'tb_orders_by_table';
//   @override
//   final String actualTableName = 'tb_orders_by_table';
//   @override
//   VerificationContext validateIntegrity(
//       Insertable<TbOrdersByTableData> instance,
//       {bool isInserting = false}) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('table_id')) {
//       context.handle(_tableIdMeta,
//           tableId.isAcceptableOrUnknown(data['table_id'], _tableIdMeta));
//     } else if (isInserting) {
//       context.missing(_tableIdMeta);
//     }
//     if (data.containsKey('name')) {
//       context.handle(
//           _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
//     } else if (isInserting) {
//       context.missing(_nameMeta);
//     }
//     return context;
//   }
//
//   @override
//   Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
//   @override
//   TbOrdersByTableData map(Map<String, dynamic> data, {String tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
//     return TbOrdersByTableData.fromData(data, _db, prefix: effectivePrefix);
//   }
//
//   @override
//   $TbOrdersByTableTable createAlias(String alias) {
//     return $TbOrdersByTableTable(_db, alias);
//   }
// }
//
// class TbOrdersItemData extends DataClass
//     implements Insertable<TbOrdersItemData> {
//   final int id;
//   final String orderId;
//   final String tableId;
//   final String orderName;
//   final int orderQuantity;
//   final DateTime orderCreated;
//   final int startTimer;
//   final DateTime orderCompleted;
//   final bool isComplete;
//   final bool isTakeOut;
//   TbOrdersItemData(
//       {@required this.id,
//       @required this.orderId,
//       @required this.tableId,
//       @required this.orderName,
//       @required this.orderQuantity,
//       @required this.orderCreated,
//       @required this.startTimer,
//       this.orderCompleted,
//       @required this.isComplete,
//       @required this.isTakeOut});
//   factory TbOrdersItemData.fromData(
//       Map<String, dynamic> data, GeneratedDatabase db,
//       {String prefix}) {
//     final effectivePrefix = prefix ?? '';
//     final intType = db.typeSystem.forDartType<int>();
//     final stringType = db.typeSystem.forDartType<String>();
//     final dateTimeType = db.typeSystem.forDartType<DateTime>();
//     final boolType = db.typeSystem.forDartType<bool>();
//     return TbOrdersItemData(
//       id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
//       orderId: stringType
//           .mapFromDatabaseResponse(data['${effectivePrefix}order_id']),
//       tableId: stringType
//           .mapFromDatabaseResponse(data['${effectivePrefix}table_id']),
//       orderName: stringType
//           .mapFromDatabaseResponse(data['${effectivePrefix}order_name']),
//       orderQuantity: intType
//           .mapFromDatabaseResponse(data['${effectivePrefix}order_quantity']),
//       orderCreated: dateTimeType
//           .mapFromDatabaseResponse(data['${effectivePrefix}order_created']),
//       startTimer: intType
//           .mapFromDatabaseResponse(data['${effectivePrefix}start_timer']),
//       orderCompleted: dateTimeType
//           .mapFromDatabaseResponse(data['${effectivePrefix}order_completed']),
//       isComplete: boolType
//           .mapFromDatabaseResponse(data['${effectivePrefix}is_complete']),
//       isTakeOut: boolType
//           .mapFromDatabaseResponse(data['${effectivePrefix}is_take_out']),
//     );
//   }
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (!nullToAbsent || id != null) {
//       map['id'] = Variable<int>(id);
//     }
//     if (!nullToAbsent || orderId != null) {
//       map['order_id'] = Variable<String>(orderId);
//     }
//     if (!nullToAbsent || tableId != null) {
//       map['table_id'] = Variable<String>(tableId);
//     }
//     if (!nullToAbsent || orderName != null) {
//       map['order_name'] = Variable<String>(orderName);
//     }
//     if (!nullToAbsent || orderQuantity != null) {
//       map['order_quantity'] = Variable<int>(orderQuantity);
//     }
//     if (!nullToAbsent || orderCreated != null) {
//       map['order_created'] = Variable<DateTime>(orderCreated);
//     }
//     if (!nullToAbsent || startTimer != null) {
//       map['start_timer'] = Variable<int>(startTimer);
//     }
//     if (!nullToAbsent || orderCompleted != null) {
//       map['order_completed'] = Variable<DateTime>(orderCompleted);
//     }
//     if (!nullToAbsent || isComplete != null) {
//       map['is_complete'] = Variable<bool>(isComplete);
//     }
//     if (!nullToAbsent || isTakeOut != null) {
//       map['is_take_out'] = Variable<bool>(isTakeOut);
//     }
//     return map;
//   }
//
//   TbOrdersItemCompanion toCompanion(bool nullToAbsent) {
//     return TbOrdersItemCompanion(
//       id: id == null && nullToAbsent ? const Value.absent() : Value(id),
//       orderId: orderId == null && nullToAbsent
//           ? const Value.absent()
//           : Value(orderId),
//       tableId: tableId == null && nullToAbsent
//           ? const Value.absent()
//           : Value(tableId),
//       orderName: orderName == null && nullToAbsent
//           ? const Value.absent()
//           : Value(orderName),
//       orderQuantity: orderQuantity == null && nullToAbsent
//           ? const Value.absent()
//           : Value(orderQuantity),
//       orderCreated: orderCreated == null && nullToAbsent
//           ? const Value.absent()
//           : Value(orderCreated),
//       startTimer: startTimer == null && nullToAbsent
//           ? const Value.absent()
//           : Value(startTimer),
//       orderCompleted: orderCompleted == null && nullToAbsent
//           ? const Value.absent()
//           : Value(orderCompleted),
//       isComplete: isComplete == null && nullToAbsent
//           ? const Value.absent()
//           : Value(isComplete),
//       isTakeOut: isTakeOut == null && nullToAbsent
//           ? const Value.absent()
//           : Value(isTakeOut),
//     );
//   }
//
//   factory TbOrdersItemData.fromJson(Map<String, dynamic> json,
//       {ValueSerializer serializer}) {
//     serializer ??= moorRuntimeOptions.defaultSerializer;
//     return TbOrdersItemData(
//       id: serializer.fromJson<int>(json['id']),
//       orderId: serializer.fromJson<String>(json['orderId']),
//       tableId: serializer.fromJson<String>(json['tableId']),
//       orderName: serializer.fromJson<String>(json['orderName']),
//       orderQuantity: serializer.fromJson<int>(json['orderQuantity']),
//       orderCreated: serializer.fromJson<DateTime>(json['orderCreated']),
//       startTimer: serializer.fromJson<int>(json['startTimer']),
//       orderCompleted: serializer.fromJson<DateTime>(json['orderCompleted']),
//       isComplete: serializer.fromJson<bool>(json['isComplete']),
//       isTakeOut: serializer.fromJson<bool>(json['isTakeOut']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer serializer}) {
//     serializer ??= moorRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'orderId': serializer.toJson<String>(orderId),
//       'tableId': serializer.toJson<String>(tableId),
//       'orderName': serializer.toJson<String>(orderName),
//       'orderQuantity': serializer.toJson<int>(orderQuantity),
//       'orderCreated': serializer.toJson<DateTime>(orderCreated),
//       'startTimer': serializer.toJson<int>(startTimer),
//       'orderCompleted': serializer.toJson<DateTime>(orderCompleted),
//       'isComplete': serializer.toJson<bool>(isComplete),
//       'isTakeOut': serializer.toJson<bool>(isTakeOut),
//     };
//   }
//
//   TbOrdersItemData copyWith(
//           {int id,
//           String orderId,
//           String tableId,
//           String orderName,
//           int orderQuantity,
//           DateTime orderCreated,
//           int startTimer,
//           DateTime orderCompleted,
//           bool isComplete,
//           bool isTakeOut}) =>
//       TbOrdersItemData(
//         id: id ?? this.id,
//         orderId: orderId ?? this.orderId,
//         tableId: tableId ?? this.tableId,
//         orderName: orderName ?? this.orderName,
//         orderQuantity: orderQuantity ?? this.orderQuantity,
//         orderCreated: orderCreated ?? this.orderCreated,
//         startTimer: startTimer ?? this.startTimer,
//         orderCompleted: orderCompleted ?? this.orderCompleted,
//         isComplete: isComplete ?? this.isComplete,
//         isTakeOut: isTakeOut ?? this.isTakeOut,
//       );
//   @override
//   String toString() {
//     return (StringBuffer('TbOrdersItemData(')
//           ..write('id: $id, ')
//           ..write('orderId: $orderId, ')
//           ..write('tableId: $tableId, ')
//           ..write('orderName: $orderName, ')
//           ..write('orderQuantity: $orderQuantity, ')
//           ..write('orderCreated: $orderCreated, ')
//           ..write('startTimer: $startTimer, ')
//           ..write('orderCompleted: $orderCompleted, ')
//           ..write('isComplete: $isComplete, ')
//           ..write('isTakeOut: $isTakeOut')
//           ..write(')'))
//         .toString();
//   }
//
//   @override
//   int get hashCode => $mrjf($mrjc(
//       id.hashCode,
//       $mrjc(
//           orderId.hashCode,
//           $mrjc(
//               tableId.hashCode,
//               $mrjc(
//                   orderName.hashCode,
//                   $mrjc(
//                       orderQuantity.hashCode,
//                       $mrjc(
//                           orderCreated.hashCode,
//                           $mrjc(
//                               startTimer.hashCode,
//                               $mrjc(
//                                   orderCompleted.hashCode,
//                                   $mrjc(isComplete.hashCode,
//                                       isTakeOut.hashCode))))))))));
//   @override
//   bool operator ==(dynamic other) =>
//       identical(this, other) ||
//       (other is TbOrdersItemData &&
//           other.id == this.id &&
//           other.orderId == this.orderId &&
//           other.tableId == this.tableId &&
//           other.orderName == this.orderName &&
//           other.orderQuantity == this.orderQuantity &&
//           other.orderCreated == this.orderCreated &&
//           other.startTimer == this.startTimer &&
//           other.orderCompleted == this.orderCompleted &&
//           other.isComplete == this.isComplete &&
//           other.isTakeOut == this.isTakeOut);
// }
//
// class TbOrdersItemCompanion extends UpdateCompanion<TbOrdersItemData> {
//   final Value<int> id;
//   final Value<String> orderId;
//   final Value<String> tableId;
//   final Value<String> orderName;
//   final Value<int> orderQuantity;
//   final Value<DateTime> orderCreated;
//   final Value<int> startTimer;
//   final Value<DateTime> orderCompleted;
//   final Value<bool> isComplete;
//   final Value<bool> isTakeOut;
//   const TbOrdersItemCompanion({
//     this.id = const Value.absent(),
//     this.orderId = const Value.absent(),
//     this.tableId = const Value.absent(),
//     this.orderName = const Value.absent(),
//     this.orderQuantity = const Value.absent(),
//     this.orderCreated = const Value.absent(),
//     this.startTimer = const Value.absent(),
//     this.orderCompleted = const Value.absent(),
//     this.isComplete = const Value.absent(),
//     this.isTakeOut = const Value.absent(),
//   });
//   TbOrdersItemCompanion.insert({
//     this.id = const Value.absent(),
//     @required String orderId,
//     @required String tableId,
//     @required String orderName,
//     @required int orderQuantity,
//     this.orderCreated = const Value.absent(),
//     this.startTimer = const Value.absent(),
//     this.orderCompleted = const Value.absent(),
//     this.isComplete = const Value.absent(),
//     this.isTakeOut = const Value.absent(),
//   })  : orderId = Value(orderId),
//         tableId = Value(tableId),
//         orderName = Value(orderName),
//         orderQuantity = Value(orderQuantity);
//   static Insertable<TbOrdersItemData> custom({
//     Expression<int> id,
//     Expression<String> orderId,
//     Expression<String> tableId,
//     Expression<String> orderName,
//     Expression<int> orderQuantity,
//     Expression<DateTime> orderCreated,
//     Expression<int> startTimer,
//     Expression<DateTime> orderCompleted,
//     Expression<bool> isComplete,
//     Expression<bool> isTakeOut,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (orderId != null) 'order_id': orderId,
//       if (tableId != null) 'table_id': tableId,
//       if (orderName != null) 'order_name': orderName,
//       if (orderQuantity != null) 'order_quantity': orderQuantity,
//       if (orderCreated != null) 'order_created': orderCreated,
//       if (startTimer != null) 'start_timer': startTimer,
//       if (orderCompleted != null) 'order_completed': orderCompleted,
//       if (isComplete != null) 'is_complete': isComplete,
//       if (isTakeOut != null) 'is_take_out': isTakeOut,
//     });
//   }
//
//   TbOrdersItemCompanion copyWith(
//       {Value<int> id,
//       Value<String> orderId,
//       Value<String> tableId,
//       Value<String> orderName,
//       Value<int> orderQuantity,
//       Value<DateTime> orderCreated,
//       Value<int> startTimer,
//       Value<DateTime> orderCompleted,
//       Value<bool> isComplete,
//       Value<bool> isTakeOut}) {
//     return TbOrdersItemCompanion(
//       id: id ?? this.id,
//       orderId: orderId ?? this.orderId,
//       tableId: tableId ?? this.tableId,
//       orderName: orderName ?? this.orderName,
//       orderQuantity: orderQuantity ?? this.orderQuantity,
//       orderCreated: orderCreated ?? this.orderCreated,
//       startTimer: startTimer ?? this.startTimer,
//       orderCompleted: orderCompleted ?? this.orderCompleted,
//       isComplete: isComplete ?? this.isComplete,
//       isTakeOut: isTakeOut ?? this.isTakeOut,
//     );
//   }
//
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (id.present) {
//       map['id'] = Variable<int>(id.value);
//     }
//     if (orderId.present) {
//       map['order_id'] = Variable<String>(orderId.value);
//     }
//     if (tableId.present) {
//       map['table_id'] = Variable<String>(tableId.value);
//     }
//     if (orderName.present) {
//       map['order_name'] = Variable<String>(orderName.value);
//     }
//     if (orderQuantity.present) {
//       map['order_quantity'] = Variable<int>(orderQuantity.value);
//     }
//     if (orderCreated.present) {
//       map['order_created'] = Variable<DateTime>(orderCreated.value);
//     }
//     if (startTimer.present) {
//       map['start_timer'] = Variable<int>(startTimer.value);
//     }
//     if (orderCompleted.present) {
//       map['order_completed'] = Variable<DateTime>(orderCompleted.value);
//     }
//     if (isComplete.present) {
//       map['is_complete'] = Variable<bool>(isComplete.value);
//     }
//     if (isTakeOut.present) {
//       map['is_take_out'] = Variable<bool>(isTakeOut.value);
//     }
//     return map;
//   }
//
//   @override
//   String toString() {
//     return (StringBuffer('TbOrdersItemCompanion(')
//           ..write('id: $id, ')
//           ..write('orderId: $orderId, ')
//           ..write('tableId: $tableId, ')
//           ..write('orderName: $orderName, ')
//           ..write('orderQuantity: $orderQuantity, ')
//           ..write('orderCreated: $orderCreated, ')
//           ..write('startTimer: $startTimer, ')
//           ..write('orderCompleted: $orderCompleted, ')
//           ..write('isComplete: $isComplete, ')
//           ..write('isTakeOut: $isTakeOut')
//           ..write(')'))
//         .toString();
//   }
// }
//
// class $TbOrdersItemTable extends TbOrdersItem
//     with TableInfo<$TbOrdersItemTable, TbOrdersItemData> {
//   final GeneratedDatabase _db;
//   final String _alias;
//   $TbOrdersItemTable(this._db, [this._alias]);
//   final VerificationMeta _idMeta = const VerificationMeta('id');
//   GeneratedIntColumn _id;
//   @override
//   GeneratedIntColumn get id => _id ??= _constructId();
//   GeneratedIntColumn _constructId() {
//     return GeneratedIntColumn('id', $tableName, false,
//         hasAutoIncrement: true, declaredAsPrimaryKey: true);
//   }
//
//   final VerificationMeta _orderIdMeta = const VerificationMeta('orderId');
//   GeneratedTextColumn _orderId;
//   @override
//   GeneratedTextColumn get orderId => _orderId ??= _constructOrderId();
//   GeneratedTextColumn _constructOrderId() {
//     return GeneratedTextColumn('order_id', $tableName, false,
//         minTextLength: 1, maxTextLength: 50);
//   }
//
//   final VerificationMeta _tableIdMeta = const VerificationMeta('tableId');
//   GeneratedTextColumn _tableId;
//   @override
//   GeneratedTextColumn get tableId => _tableId ??= _constructTableId();
//   GeneratedTextColumn _constructTableId() {
//     return GeneratedTextColumn('table_id', $tableName, false,
//         minTextLength: 1, maxTextLength: 50);
//   }
//
//   final VerificationMeta _orderNameMeta = const VerificationMeta('orderName');
//   GeneratedTextColumn _orderName;
//   @override
//   GeneratedTextColumn get orderName => _orderName ??= _constructOrderName();
//   GeneratedTextColumn _constructOrderName() {
//     return GeneratedTextColumn('order_name', $tableName, false,
//         minTextLength: 1, maxTextLength: 50);
//   }
//
//   final VerificationMeta _orderQuantityMeta =
//       const VerificationMeta('orderQuantity');
//   GeneratedIntColumn _orderQuantity;
//   @override
//   GeneratedIntColumn get orderQuantity =>
//       _orderQuantity ??= _constructOrderQuantity();
//   GeneratedIntColumn _constructOrderQuantity() {
//     return GeneratedIntColumn(
//       'order_quantity',
//       $tableName,
//       false,
//     );
//   }
//
//   final VerificationMeta _orderCreatedMeta =
//       const VerificationMeta('orderCreated');
//   GeneratedDateTimeColumn _orderCreated;
//   @override
//   GeneratedDateTimeColumn get orderCreated =>
//       _orderCreated ??= _constructOrderCreated();
//   GeneratedDateTimeColumn _constructOrderCreated() {
//     return GeneratedDateTimeColumn('order_created', $tableName, false,
//         defaultValue: Constant(DateTime.now()));
//   }
//
//   final VerificationMeta _startTimerMeta = const VerificationMeta('startTimer');
//   GeneratedIntColumn _startTimer;
//   @override
//   GeneratedIntColumn get startTimer => _startTimer ??= _constructStartTimer();
//   GeneratedIntColumn _constructStartTimer() {
//     return GeneratedIntColumn('start_timer', $tableName, false,
//         defaultValue: Constant(1));
//   }
//
//   final VerificationMeta _orderCompletedMeta =
//       const VerificationMeta('orderCompleted');
//   GeneratedDateTimeColumn _orderCompleted;
//   @override
//   GeneratedDateTimeColumn get orderCompleted =>
//       _orderCompleted ??= _constructOrderCompleted();
//   GeneratedDateTimeColumn _constructOrderCompleted() {
//     return GeneratedDateTimeColumn(
//       'order_completed',
//       $tableName,
//       true,
//     );
//   }
//
//   final VerificationMeta _isCompleteMeta = const VerificationMeta('isComplete');
//   GeneratedBoolColumn _isComplete;
//   @override
//   GeneratedBoolColumn get isComplete => _isComplete ??= _constructIsComplete();
//   GeneratedBoolColumn _constructIsComplete() {
//     return GeneratedBoolColumn('is_complete', $tableName, false,
//         defaultValue: Constant(false));
//   }
//
//   final VerificationMeta _isTakeOutMeta = const VerificationMeta('isTakeOut');
//   GeneratedBoolColumn _isTakeOut;
//   @override
//   GeneratedBoolColumn get isTakeOut => _isTakeOut ??= _constructIsTakeOut();
//   GeneratedBoolColumn _constructIsTakeOut() {
//     return GeneratedBoolColumn('is_take_out', $tableName, false,
//         defaultValue: Constant(false));
//   }
//
//   @override
//   List<GeneratedColumn> get $columns => [
//         id,
//         orderId,
//         tableId,
//         orderName,
//         orderQuantity,
//         orderCreated,
//         startTimer,
//         orderCompleted,
//         isComplete,
//         isTakeOut
//       ];
//   @override
//   $TbOrdersItemTable get asDslTable => this;
//   @override
//   String get $tableName => _alias ?? 'tb_orders_item';
//   @override
//   final String actualTableName = 'tb_orders_item';
//   @override
//   VerificationContext validateIntegrity(Insertable<TbOrdersItemData> instance,
//       {bool isInserting = false}) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('id')) {
//       context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
//     }
//     if (data.containsKey('order_id')) {
//       context.handle(_orderIdMeta,
//           orderId.isAcceptableOrUnknown(data['order_id'], _orderIdMeta));
//     } else if (isInserting) {
//       context.missing(_orderIdMeta);
//     }
//     if (data.containsKey('table_id')) {
//       context.handle(_tableIdMeta,
//           tableId.isAcceptableOrUnknown(data['table_id'], _tableIdMeta));
//     } else if (isInserting) {
//       context.missing(_tableIdMeta);
//     }
//     if (data.containsKey('order_name')) {
//       context.handle(_orderNameMeta,
//           orderName.isAcceptableOrUnknown(data['order_name'], _orderNameMeta));
//     } else if (isInserting) {
//       context.missing(_orderNameMeta);
//     }
//     if (data.containsKey('order_quantity')) {
//       context.handle(
//           _orderQuantityMeta,
//           orderQuantity.isAcceptableOrUnknown(
//               data['order_quantity'], _orderQuantityMeta));
//     } else if (isInserting) {
//       context.missing(_orderQuantityMeta);
//     }
//     if (data.containsKey('order_created')) {
//       context.handle(
//           _orderCreatedMeta,
//           orderCreated.isAcceptableOrUnknown(
//               data['order_created'], _orderCreatedMeta));
//     }
//     if (data.containsKey('start_timer')) {
//       context.handle(
//           _startTimerMeta,
//           startTimer.isAcceptableOrUnknown(
//               data['start_timer'], _startTimerMeta));
//     }
//     if (data.containsKey('order_completed')) {
//       context.handle(
//           _orderCompletedMeta,
//           orderCompleted.isAcceptableOrUnknown(
//               data['order_completed'], _orderCompletedMeta));
//     }
//     if (data.containsKey('is_complete')) {
//       context.handle(
//           _isCompleteMeta,
//           isComplete.isAcceptableOrUnknown(
//               data['is_complete'], _isCompleteMeta));
//     }
//     if (data.containsKey('is_take_out')) {
//       context.handle(_isTakeOutMeta,
//           isTakeOut.isAcceptableOrUnknown(data['is_take_out'], _isTakeOutMeta));
//     }
//     return context;
//   }
//
//   @override
//   Set<GeneratedColumn> get $primaryKey => {id};
//   @override
//   TbOrdersItemData map(Map<String, dynamic> data, {String tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
//     return TbOrdersItemData.fromData(data, _db, prefix: effectivePrefix);
//   }
//
//   @override
//   $TbOrdersItemTable createAlias(String alias) {
//     return $TbOrdersItemTable(_db, alias);
//   }
// }
//
// abstract class _$LocalDatabase extends GeneratedDatabase {
//   _$LocalDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
//   $TbOrdersByTableTable _tbOrdersByTable;
//   $TbOrdersByTableTable get tbOrdersByTable =>
//       _tbOrdersByTable ??= $TbOrdersByTableTable(this);
//   $TbOrdersItemTable _tbOrdersItem;
//   $TbOrdersItemTable get tbOrdersItem =>
//       _tbOrdersItem ??= $TbOrdersItemTable(this);
//   Selectable<TableWithOrdersResult> tableWithOrders() {
//     return customSelect(
//         'SELECT a.name, b.id, b.table_id, b.order_id, b.order_name, b.order_quantity, b.order_created, b.order_completed, b.is_complete, b.is_take_out, b.start_timer FROM tb_orders_by_table a LEFT OUTER JOIN tb_orders_item b ON a.table_id = b.table_id order by b.order_created asc',
//         variables: [],
//         readsFrom: {tbOrdersByTable, tbOrdersItem}).map((QueryRow row) {
//       return TableWithOrdersResult(
//         name: row.readString('name'),
//         id: row.readInt('id'),
//         tableId: row.readString('table_id'),
//         orderId: row.readString('order_id'),
//         orderName: row.readString('order_name'),
//         orderQuantity: row.readInt('order_quantity'),
//         orderCreated: row.readDateTime('order_created'),
//         orderCompleted: row.readDateTime('order_completed'),
//         isComplete: row.readBool('is_complete'),
//         isTakeOut: row.readBool('is_take_out'),
//         startTimer: row.readInt('start_timer'),
//       );
//     });
//   }
//
//   Future<int> updateOrderQuantityByTableIdAndOrderIdAndIsTakeOut(
//       int var1, String var2, String var3, bool var4, int var5) {
//     return customUpdate(
//       'UPDATE tb_orders_item SET order_quantity = ? WHERE table_id = ? AND order_id = ? AND is_take_out = ? AND is_complete = 0 AND id = ?',
//       variables: [
//         Variable.withInt(var1),
//         Variable.withString(var2),
//         Variable.withString(var3),
//         Variable.withBool(var4),
//         Variable.withInt(var5)
//       ],
//       updates: {tbOrdersItem},
//       updateKind: UpdateKind.update,
//     );
//   }
//
//   Selectable<int> countUnProcessOrders() {
//     return customSelect(
//             'SELECT COUNT(*) FROM tb_orders_item WHERE is_complete = 0',
//             variables: [],
//             readsFrom: {tbOrdersItem})
//         .map((QueryRow row) => row.readInt('COUNT(*)'));
//   }
//
//   @override
//   Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
//   @override
//   List<DatabaseSchemaEntity> get allSchemaEntities =>
//       [tbOrdersByTable, tbOrdersItem];
// }
//
// class TableWithOrdersResult {
//   final String name;
//   final int id;
//   final String tableId;
//   final String orderId;
//   final String orderName;
//   final int orderQuantity;
//   final DateTime orderCreated;
//   final DateTime orderCompleted;
//   final bool isComplete;
//   final bool isTakeOut;
//   final int startTimer;
//   TableWithOrdersResult({
//     this.name,
//     this.id,
//     this.tableId,
//     this.orderId,
//     this.orderName,
//     this.orderQuantity,
//     this.orderCreated,
//     this.orderCompleted,
//     this.isComplete,
//     this.isTakeOut,
//     this.startTimer,
//   });
// }
