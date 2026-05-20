import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: ExpenseTrackerApp(), theme: ThemeData(primarySwatch: Colors.indigo)));

class ExpenseTrackerApp extends StatefulWidget {
  @override
  _ExpenseTrackerAppState createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  int _currentIndex = 0;
  
  // Local State: List of expenses
  List<Map<String, dynamic>> expenses = [
    {"title": "Lunch", "amount": 150, "category": "Food"},
    {"title": "Bus Fare", "amount": 50, "category": "Travel"},
  ];

  void addExpense(String title, double amount) {
    setState(() {
      expenses.add({"title": title, "amount": amount, "category": "General"});
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of Screens
    final List<Widget> screens = [
      DashboardScreen(expenses: expenses),
      AddExpenseScreen(onAdd: addExpense),
      HistoryScreen(expenses: expenses),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
      ),
    );
  }
}

// --- SCREEN 1: DASHBOARD ---
class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;
  DashboardScreen({required this.expenses});

  @override
  Widget build(BuildContext context) {
    double total = expenses.fold(0, (sum, item) => sum + item['amount']);
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(20),
            color: Colors.indigo,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(32),
              child: Column(
                children: [
                  Text("Total Spent", style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text("₹$total", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length > 3 ? 3 : expenses.length, // Show only recent 3
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.payment),
                title: Text(expenses[index]['title']),
                trailing: Text("-₹${expenses[index]['amount']}"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// --- SCREEN 2: ADD EXPENSE ---
class AddExpenseScreen extends StatelessWidget {
  final Function(String, double) onAdd;
  AddExpenseScreen({required this.onAdd});
  
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: amountController, decoration: InputDecoration(labelText: "Amount"), keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onAdd(titleController.text, double.parse(amountController.text));
                titleController.clear();
                amountController.clear();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Expense Added!")));
              },
              child: Text("Add Expense"),
            )
          ],
        ),
      ),
    );
  }
}

// --- SCREEN 3: HISTORY ---
class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;
  HistoryScreen({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Full History")),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(expenses[index]['title']),
          subtitle: Text(expenses[index]['category']),
          trailing: Text("₹${expenses[index]['amount']}", style: TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}