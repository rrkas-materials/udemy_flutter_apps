import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  Future<void> _refresh(ctx) async {
    await Provider.of<Orders>(ctx, listen: false).fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, x) {
          if (x.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          else if (x.error != null)
            return Center(
              child: Text('Error'),
            );
          else
            return RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: Consumer<Orders>(
                builder: (ctx, orderData, child) =>
                    orderData.getOrders.length > 0
                        ? ListView.builder(
                            itemCount: orderData.getOrders.length,
                            itemBuilder: (ctx, idx) => OrderItemWidget(
                              orderItem: orderData.getOrders[idx],
                            ),
                          )
                        : Center(
                            child: Text('No Orders Yet'),
                          ),
              ),
            );
        },
      ),
    );
  }
}
