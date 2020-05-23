import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  var initValues = {
    ProductsProvider.TITLE: '',
    ProductsProvider.DESC: '',
    ProductsProvider.PRICE: '',
    ProductsProvider.URL: ''
  };
  final formKey = GlobalKey<FormState>();

  Product product;

  var isinit = true;
  var isLoading = false;

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) setState(() {});
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isinit) {
      product = ModalRoute.of(context).settings.arguments;
      if (product != null) {
        initValues = {
          ProductsProvider.TITLE: product.title,
          ProductsProvider.DESC: product.desc,
          ProductsProvider.PRICE: product.price.toString(),
          ProductsProvider.URL: '',
        };
        _imageUrlController.text = product.imageURL;
      } else {
        product = Product(
          id: null,
          title: '',
          price: 0.0,
          desc: '',
          imageURL: '',
        );
      }
    }
    isinit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    if (!formKey.currentState.validate()) return;
    setState(() => isLoading = true);
    formKey.currentState.save();
    if (product.id == null) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProducts(product);
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error Occured!'),
            content: Text('Something went wrong!!'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(_).pop(),
                child: Text('OK'),
              )
            ],
          ),
        );
      }
//      finally {
//        setState(() => isLoading = false);
//      }
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(product);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
        title: Text('Edit Product'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: initValues[ProductsProvider.TITLE],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (val) =>
                          val.isEmpty ? 'Cannot be Empty' : null,
                      onSaved: (val) => product = Product(
                        id: product.id,
                        title: val,
                        desc: product.desc,
                        price: product.price,
                        imageURL: product.imageURL,
                        isFavourite: product.isFavourite,
                      ),
                    ),
                    TextFormField(
                      initialValue: initValues[ProductsProvider.PRICE],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      validator: (val) => val.isEmpty
                          ? 'Cannot be Empty'
                          : double.tryParse(val) == null
                              ? 'Invalid Price'
                              : double.parse(val) <= 0
                                  ? 'Enter a number Greater than ZERO!'
                                  : null,
                      onSaved: (val) => product = Product(
                          id: product.id,
                          title: product.title,
                          desc: product.desc,
                          price: double.parse(val),
                          imageURL: product.imageURL,
                          isFavourite: product.isFavourite),
                    ),
                    TextFormField(
                      initialValue: initValues[ProductsProvider.DESC],
                      decoration: InputDecoration(labelText: 'Description'),
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descFocusNode,
                      validator: (val) =>
                          val.isEmpty ? 'Cannot be Empty' : null,
                      onSaved: (val) => product = Product(
                          id: product.id,
                          title: product.title,
                          desc: val,
                          price: product.price,
                          imageURL: product.imageURL,
                          isFavourite: product.isFavourite),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter Url')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
//                      initialValue: initValues[ProductsProvider.URL],
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: (val) =>
                                val.isEmpty ? 'Cannot be Empty' : null,
                            onSaved: (val) => product = Product(
                              id: product.id,
                              title: product.title,
                              desc: product.desc,
                              price: product.price,
                              imageURL: val,
                              isFavourite: product.isFavourite,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
