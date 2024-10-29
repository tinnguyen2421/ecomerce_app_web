import 'package:ecomerce_app_web/controllers/category_controller.dart';
import 'package:ecomerce_app_web/controllers/subcategory_controller.dart';
import 'package:ecomerce_app_web/models/category.dart';
import 'package:ecomerce_app_web/views/side_bar_screens/widgets/subcategory_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SubcatgoryScreen extends StatefulWidget {
  static const String id = 'subCategoryScreen';
  const SubcatgoryScreen({super.key});

  @override
  State<SubcatgoryScreen> createState() => _SubcatgoryScreenState();
}

class _SubcatgoryScreenState extends State<SubcatgoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SubcategoryController subcategoryController = SubcategoryController();
  late String name;
  dynamic _image;
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {});
      _image = result.files.first.bytes;
    }
  }

  late Future<List<Category>> futureCategories;
  Category? selectedCategory;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'SubCategories',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            FutureBuilder(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error:${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Np categories'),
                    );
                  } else {
                    return DropdownButton<Category>(
                        value: selectedCategory,
                        hint: const Text('Select Category'),
                        items: snapshot.data!.map((Category category) {
                          return DropdownMenuItem(
                              value: category, child: Text(category.name));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                          print(selectedCategory!.name);
                        });
                  }
                }),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: _image != null
                        ? Image.memory(_image)
                        : Text('SubCategory Image'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    child: TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return 'Please enter subcategory name';
                        }
                      },
                      decoration:
                          InputDecoration(labelText: 'Enter SubCategory Name'),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await subcategoryController.uploadSubcategory(
                          categoryId: selectedCategory!.id,
                          categoryName: selectedCategory!.name,
                          pickedImage: _image,
                          subCategoryName: name,
                          context: context);
                      setState(() {
                        _formKey.currentState!.reset();
                        _image = null;
                      });
                    }
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: Text("Pick image"),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            SubcategoryWidget(),
          ],
        ),
      ),
    );
  }
}
