import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'package:yonosbi/features/payments/quicktrasfer/presentation/pages/quick_transfer_select_bank_screen.dart';
import 'package:yonosbi/features/payments/upi/presentation/pages/scanner_screen.dart';
import 'package:yonosbi/features/payments/bank/presentation/pages/bank_account_landing_screen.dart';
import 'package:yonosbi/features/payments/fund_transfer/presentation/pages/fund_transfer_screen.dart';
import 'package:yonosbi/features/payments/scheduled_payments/presentation/pages/scheduled_payments_screen.dart';
import '../bloc/dashboard_bloc.dart';
import '../../../payments/upi/presentation/pages/contacts_screen.dart';
import '../../../payments/upi/presentation/pages/manual_upi_pay_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopTabs(),
                _buildQuickActions(),
                _buildTransactionCard(),
                _buildPaymentsAndTransfers(context, state),
                _buildSectionHeader('Deposits'),
                _buildDepositsGrid(),
                _buildSectionHeader('Loans'),
                _buildLoansGrid(),
                _buildSectionHeader('Cards'),
                _buildCardsGrid(),
                _buildSectionHeader('Investments'),
                _buildInvestmentsGrid(),
                _buildSectionHeader('Insurance'),
                _buildInsuranceGrid(),
                _buildSectionHeader('Services'),
                _buildServicesGrid(),
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNav(context, state),
          floatingActionButton: _buildScanQRButton(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Color(0xFFD81B60),
          child: Text('SK', style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ),
      title: const Text(
        'Hello Shubham!',
        style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: AppColors.textGrey)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: AppColors.textGrey)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.logout, color: AppColors.textGrey)),
      ],
    );
  }

  Widget _buildTopTabs() {
    return Container(
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _tabItem('Banking', true),
          _tabItem('Lifestyle', false),
          _tabItem('Rewards', false),
        ],
      ),
    );
  }

  Widget _tabItem(String title, bool isSelected) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.primaryPurple : AppColors.textGrey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        if (isSelected)
          Container(height: 3, width: 60, color: AppColors.primaryPurple)
        else
          const SizedBox(height: 3),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          _quickActionItem(Icons.account_balance_outlined, 'Welcome to\nYono'),
          _quickActionItem(Icons.security, 'Security'),
          _quickActionItem(Icons.explore_outlined, 'Explore'),
          _quickActionItem(Icons.local_offer_outlined, 'Offers'),
        ],
      ),
    );
  }

  Widget _quickActionItem(IconData icon, String label) {
    return Container(
      width: 85,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: Icon(icon, color: AppColors.primaryPurple, size: 24),
          ),
          const SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildTransactionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.cardGradientStart, AppColors.cardGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TRANSACTION ACCOUNTS (XX)', style: TextStyle(color: Colors.white, fontSize: 12)),
              const Icon(Icons.visibility_off_outlined, color: Colors.white, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Combined Balance', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const Text('₹ XXXX.xx', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                child: const Text('View Accounts', style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
              ),
              InkWell(
                onTap: () {},
                child: const Text('Transactions', style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPaymentsAndTransfers(BuildContext context, DashboardState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
          child: Text('Payments & Transfers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _miniTab(context, 'UPI', 0, state.paymentTabIndex == 0),
                  _miniTab(context, 'Fund Transfer', 1, state.paymentTabIndex == 1),
                  _miniTab(context, 'Bills', 2, state.paymentTabIndex == 2),
                  _miniTab(context, 'Yono Cash', 3, state.paymentTabIndex == 3),
                ],
              ),
              const Divider(),
              _buildTabContent(context, state.paymentTabIndex),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(BuildContext context, int paymentTabIndex) {
    switch (paymentTabIndex) {
      case 0:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: _buildUPIPaymentsGrid(context),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: _buildGrid([
            _gridItem(Icons.sync, 'Quick\nTransfer', subLabel: 'Upto ₹ 50,000\nTo Any A/C', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const QuickTransferSelectBankScreen()));
            }),
            _gridItem(Icons.person_add_alt_1_outlined, 'Send\nMoney', subLabel: 'To Own/Other\nAccount', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FundTransferScreen()));
            }),
            _gridItem(Icons.language, 'Send\nMoney\nAbroad'),
            _gridItem(Icons.calendar_month_outlined, 'Schedule\nPayments', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduledPaymentsScreen()));
            }),
          ], childAspectRatio: 0.75),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.description_outlined, color: AppColors.primaryPurple),
                      SizedBox(width: 8),
                      Text('Bill Payments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: AppColors.primaryPurple))),
                ],
              ),
              _buildGrid([
                _gridItem(Icons.phone_android_outlined, 'Mobile\nPrepaid'),
                _gridItem(Icons.receipt_long_outlined, 'Mobile\nPostpaid'),
                _gridItem(Icons.lightbulb_outline, 'Electricity'),
                _gridItem(Icons.directions_car_filled_outlined, 'Fastag'),
              ], childAspectRatio: 0.85),
            ],
          ),
        );
      case 3:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: _buildGrid([
            _gridItem(Icons.atm_outlined, 'Withdraw\nCash'),
            _gridItem(Icons.account_balance_outlined, 'Deposit Cash'),
            _gridItem(Icons.qr_code_2, 'UPI Cash\nWithdrawal'),
            _gridItem(Icons.history, 'Transactions'),
          ]),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _miniTab(BuildContext context, String label, int index, bool isSelected) {
    return InkWell(
      onTap: () => context.read<DashboardBloc>().add(PaymentTabChanged(index)),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: isSelected ? AppColors.primaryPurple : AppColors.textGrey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          if (isSelected)
            Container(height: 2, width: 20, color: AppColors.primaryPurple, margin: const EdgeInsets.only(top: 4))
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Text('View All', style: TextStyle(color: AppColors.primaryPurple, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildUPIPaymentsGrid(BuildContext context) {
    return _buildGrid([
      _gridItem(Icons.phone_android, 'Pay to mobile\nor contact', onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactsScreen()));
      }),
      _gridItem(Icons.qr_code, 'Pay UPI ID or\nNumber', onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ManualUpiPayScreen()));
      }),
      _gridItem(Icons.account_balance, 'Pay to Bank\nA/C', onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const BankAccountLandingScreen()));
      }),
      _gridItem(Icons.history, 'View\nTransaction'),
    ]);
  }

  Widget _buildDepositsGrid() {
    return _buildGrid([
      _gridItem(Icons.savings_outlined, 'Fixed\nDeposit'),
      _gridItem(Icons.update, 'Recurring\nDeposit'),
      _gridItem(Icons.calendar_today, 'Annuity\nDeposit'),
      _gridItem(Icons.sync_alt, 'Auto Sweep'),
    ]);
  }

  Widget _buildLoansGrid() {
    return _buildGrid([
      _gridItem(Icons.person_outline, 'Personal\nLoan'),
      _gridItem(Icons.show_chart, 'Loan Against\nMutual Fund'),
      _gridItem(Icons.toll_outlined, 'Gold Loan'),
      _gridItem(Icons.home_outlined, 'Home Loan'),
    ]);
  }

  Widget _buildCardsGrid() {
    return _buildGrid([
      _gridItem(Icons.credit_card, 'Credit\nCards'),
      _gridItem(Icons.credit_card, 'Debit Cards'),
      _gridItem(Icons.credit_card, 'Forex Cards'),
      _gridItem(Icons.contactless, 'NCMC'),
    ]);
  }

  Widget _buildInvestmentsGrid() {
    return _buildGrid([
      _gridItem(Icons.eco_outlined, 'Mutual\nFund'),
      _gridItem(Icons.analytics_outlined, 'Demat &\nSecurities'),
      _gridItem(Icons.chair_outlined, 'NPS'),
      _gridItem(Icons.savings, 'PPF'),
    ]);
  }

  Widget _buildInsuranceGrid() {
    return _buildGrid([
      _gridItem(Icons.person_outline, 'Life'),
      _gridItem(Icons.favorite_outline, 'Health'),
      _gridItem(Icons.car_crash_outlined, 'Accident'),
      _gridItem(Icons.directions_car_outlined, 'Motor'),
    ]);
  }

  Widget _buildServicesGrid() {
    return _buildGrid([
      _gridItem(Icons.account_balance_outlined, 'Account\nRelated'),
      _gridItem(Icons.description_outlined, 'Tax Related'),
      _gridItem(Icons.receipt_long_outlined, 'Cheque\nServices'),
      _gridItem(Icons.lock_outline, 'e-Secure\nLock'),
    ]);
  }

  Widget _buildGrid(List<Widget> children, {double childAspectRatio = 1.0}) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: childAspectRatio,
      children: children,
    );
  }

  Widget _gridItem(IconData icon, String label, {String? subLabel, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primaryPurple, size: 28),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.textDark, fontWeight: FontWeight.w500)),
          if (subLabel != null) ...[
            const SizedBox(height: 4),
            Text(subLabel, textAlign: TextAlign.center, style: const TextStyle(fontSize: 8, color: AppColors.textGrey)),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, DashboardState state) {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navItem(context, Icons.home, 'Home', 0, state.selectedIndex == 0),
            _navItem(context, Icons.account_balance_wallet_outlined, 'Loans', 1, state.selectedIndex == 1),
            const SizedBox(width: 40), // Space for FAB
            _navItem(context, Icons.security, 'Insurance', 2, state.selectedIndex == 2),
            _navItem(context, Icons.trending_up, 'Investments', 3, state.selectedIndex == 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, int index, bool isSelected) {
    return InkWell(
      onTap: () => context.read<DashboardBloc>().add(TabChanged(index)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? AppColors.primaryPurple : AppColors.textGrey, size: 22),
          Text(label, style: TextStyle(fontSize: 10, color: isSelected ? AppColors.primaryPurple : AppColors.textGrey)),
        ],
      ),
    );
  }

  Widget _buildScanQRButton(BuildContext context) {
    return Container(
      height: 65,
      width: 65,
      margin: const EdgeInsets.only(top: 30),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ScannerScreen()));
        },
        backgroundColor: AppColors.primaryPurple,
        elevation: 4,
        shape: const CircleBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
            const Text('Scan QR', style: TextStyle(color: Colors.white, fontSize: 8)),
          ],
        ),
      ),
    );
  }
}
