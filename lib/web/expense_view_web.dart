import 'package:budget_app/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:budget_app/view_model.dart';
import 'package:url_launcher/url_launcher.dart';

bool isLoading = true;

class ExpenseViewWeb extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    if (isLoading == true) {
      viewModelProvider.expensesStream();
      viewModelProvider.incomeStream();
      isLoading = false;
    }

    int totalExpenses = 0;
    int totalIncome = 0;

    void calculate() {
      for (int i = 0; i < viewModelProvider.expensesAmount.length; i++) {
        totalExpenses =
            totalExpenses + int.parse(viewModelProvider.expensesAmount[i]);
      }

      for (int i = 0; i < viewModelProvider.incomesAmount.length; i++) {
        totalIncome =
            totalIncome + int.parse(viewModelProvider.incomesAmount[i]);
      }
    }

    calculate();
    int budgetLeft = totalIncome - totalExpenses;

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DrawerHeader(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.0, color: Colors.black),
                  ),
                  child: CircleAvatar(
                    radius: 180.0,
                    backgroundColor: Colors.white,
                    child: Image(
                      height: 100.0,
                      image: AssetImage('assets/logo.png'),
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              MaterialButton(
                onPressed: () async {
                  await viewModelProvider.logout();
                },
                child: OpenSans(
                  text: 'Logout',
                  size: 20.0,
                  color: Colors.white,
                ),
                color: Colors.black,
                height: 50.0,
                minWidth: 200.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 20.0,
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse('https://www.instagram.com/godla.swaran/'),
                      );
                    },
                    icon: SvgPicture.asset(
                      "assets/instagram.svg",
                      color: Colors.black,
                      width: 35.0,
                    ),
                  ),

                  IconButton(
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse(
                          'https://www.linkedin.com/in/swaran-singh-b122bb66/',
                        ),
                      );
                    },
                    icon: SvgPicture.asset(
                      "assets/twitter.svg",
                      color: Colors.black,
                      width: 35.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white, size: 35.0),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Poppins(text: 'Dashboard', size: 30.0, color: Colors.white),
          actions: [
            IconButton(
              onPressed: () async {
                ///TODO reset
                viewModelProvider.reset();
              },
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        body: ListView(
          children: [
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/login_image.png", width: deviceWidth / 1.6),
                // add income and expense
                SizedBox(
                  height: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 45.0,
                        width: 160.0,
                        child: MaterialButton(
                          onPressed: () async {
                            await viewModelProvider.addExpense(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              OpenSans(
                                text: 'AddExpense',
                                size: 17.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          splashColor: Colors.grey,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      SizedBox(
                        height: 45.0,
                        width: 160.0,
                        child: MaterialButton(
                          onPressed: () async {
                            await viewModelProvider.addIncome(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              OpenSans(
                                text: 'Add Income',
                                size: 17.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          splashColor: Colors.grey,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                // total calculation
                Container(
                  height: 300.0,
                  width: 280.0,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Poppins(
                            text: 'Budget left',
                            size: 17.0,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: 'Total expense',
                            size: 17.0,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: 'Total income',
                            size: 17.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: Divider(
                          indent: 40.0,
                          endIndent: 40.0,
                          color: Colors.grey,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Poppins(
                            text: budgetLeft.toString(),
                            size: 17.0,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: totalExpenses.toString(),
                            size: 17.0,
                            color: Colors.white,
                          ),
                          Poppins(
                            text: totalIncome.toString(),
                            size: 17.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Divider(
              indent: deviceWidth / 4,
              endIndent: deviceWidth / 4,
              thickness: 3.0,
            ),
            SizedBox(height: 50.0),
            // expences and income listes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Expences list
                Container(
                  height: 320.0,
                  width: 260.0,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Poppins(
                          text: 'Expences',
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      Divider(
                        indent: 30.0,
                        endIndent: 30.0,
                        color: Colors.white,
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 210.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          border: Border.all(width: 1.0, color: Colors.white),
                        ),
                        child: ListView.builder(
                          itemCount: viewModelProvider.expensesAmount.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Poppins(
                                  text: viewModelProvider.expensesName[index],
                                  size: 15.0,
                                  color: Colors.white,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Poppins(
                                    text:
                                        viewModelProvider.expensesAmount[index]
                                            .toString(),
                                    size: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // income list
                Container(
                  height: 320.0,
                  width: 260.0,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Poppins(
                          text: 'Income',
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      Divider(
                        indent: 30.0,
                        endIndent: 30.0,
                        color: Colors.white,
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 210.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          border: Border.all(width: 1.0, color: Colors.white),
                        ),
                        child: ListView.builder(
                          itemCount: viewModelProvider.incomesAmount.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Poppins(
                                  text: viewModelProvider.incomesName[index],
                                  size: 15.0,
                                  color: Colors.white,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Poppins(
                                    text:
                                        viewModelProvider.incomesAmount[index]
                                            .toString(),
                                    size: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
