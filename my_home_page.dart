import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqllite_demo/my_home_page_controller.dart';
import 'package:sqllite_demo/todo_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController taskController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  // List<int> items = List<int>.generate(100, (int index) => index);
  List<int> items=List.generate(20, (index) =>index);
  var homePageController=Get.put(MyHomePageController());


  final _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLITE"),
        backgroundColor:Colors.black54,
      ),
      body: Obx(()=>ListView.separated(
        itemCount: homePageController.todoList.length,
        itemBuilder: (context,index){
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.5),
                    offset: Offset(0.5,0.5),
                    blurRadius: 16,
                    // spreadRadius: 5,
                  )
                ]

            ),
            child: Dismissible(
              background: Container(
                color: Colors.green,
              ),
              secondaryBackground: Container(
                color: Colors.red,
              ),

              key: ValueKey<int>(items[index]),
              onDismissed: (DismissDirection direction) {

               homePageController.deleteTodo(id:homePageController.todoList[index].id!);

              },
              child: ListTile(
                  trailing: GestureDetector(
                    onTap: () async {
                    await  buildShowModalBottomSheet(context,isUpdate:true,id:homePageController.todoList[index].id);
                    nameController.text = homePageController.todoList[index].name!;
                    taskController.text=homePageController.todoList[index].task!;
                    descController.text=homePageController.todoList[index].desc!;
                    },
                      child: Icon(Icons.edit)),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("${homePageController.todoList[index].id}"),
                      Text("${homePageController.todoList[index].name}"),
                      Text("${homePageController.todoList[index].desc}"),
                      Text("${homePageController.todoList[index].task}"),
                    ],
                  )
              ),
            ),
          );
        }, separatorBuilder: (context,index){
        return SizedBox(height: 10,);
      }, ),),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black54,
        onPressed: () async {
         await buildShowModalBottomSheet(context,isUpdate: false);
        },
        tooltip: "floating button",
        child: Icon(Icons.add),
      ),
    );
  }

  buildShowModalBottomSheet(BuildContext context, {required bool isUpdate, String? id}) {
    return showModalBottomSheet(context: context,
          builder:( context){
            return Container(
              height: 500,
              // color: Colors.teal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            validator:(v){
                              if(v!.isEmpty){
                                return "enter name";
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: " Enter name",
                              labelText: "name",
                            ),
                          ),

                          SizedBox(height: 20,),
                          TextFormField(
                            controller: taskController,
                            validator:(v){
                              if(v!.isEmpty){
                                return "enter task";
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: " Enter Task",
                              labelText: "task",
                            ),
                          ),

                          SizedBox(height: 20,),
                          TextFormField(
                            controller: descController,
                            validator:(v){
                              if(v!.isEmpty){
                                return "enter description";
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Enter description",
                              labelText: "description",
                            ),
                          ),
                          SizedBox(height: 10,),


                          SizedBox(height: 50,),

                          ElevatedButton(

                            onPressed: (){
                              if(_formkey.currentState!.validate()){
                                if(isUpdate==false){
                                  homePageController.addData(name:nameController.text,task: taskController.text,desc:descController.text);
                                }
                                else{
                                  homePageController.updeteTodu(TodoModel(id : id!, name:nameController.text,task: taskController.text,desc:descController.text));
                                }
                                // homePageController.addData(name:nameController.text,task: taskController.text,desc:descController.text);
                                Navigator.pop(context);
                                nameController.clear();
                                taskController.clear();
                                descController.clear();
                              }
                            }, child: Text("Save",),),


                             GestureDetector(
                                 onTap: (){
                                   Navigator.pop(context);
                                   nameController.clear();
                                   taskController.clear();
                                   descController.clear();
                                 },
                                 child: Text("cancel")),

                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
  }
}
