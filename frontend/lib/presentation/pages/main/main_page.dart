import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../jobs/jobs_page.dart';
import '../saved_jobs/saved_jobs_page.dart';
import '../cvs/cvs_page.dart';
import '../profile/profile_page.dart';
import '../company_management/my_companies_page.dart';
import '../company_management/my_jobs_page.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';

class MainPage extends StatefulWidget {
  final int initialTab;
  final String? companyFilter;

  const MainPage({
    super.key,
    this.initialTab = 0,
    this.companyFilter,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isCompanyOwner =
            authState is Authenticated && authState.user.isCompanyOwner;

        // Different pages for company owner vs job seeker
        final List<Widget> pages = isCompanyOwner
            ? [
                JobsPage(companyFilter: widget.companyFilter),
                const MyJobsPage(), // Company owner's posted jobs
                const MyCompaniesPage(), // Company management
                const ProfilePage(),
              ]
            : [
                JobsPage(companyFilter: widget.companyFilter),
                const SavedJobsPage(),
                const CvsPage(),
                const ProfilePage(),
              ];

        // Different navigation items for company owner vs job seeker
        final List<BottomNavigationBarItem> navItems = isCompanyOwner
            ? const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.work_outline_rounded),
                  activeIcon: Icon(Icons.work_rounded),
                  label: 'Browse',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business_center_outlined),
                  activeIcon: Icon(Icons.business_center_rounded),
                  label: 'My Jobs',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business_outlined),
                  activeIcon: Icon(Icons.business_rounded),
                  label: 'Company',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ]
            : const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.work_outline_rounded),
                  activeIcon: Icon(Icons.work_rounded),
                  label: 'Jobs',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_border_rounded),
                  activeIcon: Icon(Icons.bookmark_rounded),
                  label: 'Saved',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.description_outlined),
                  activeIcon: Icon(Icons.description_rounded),
                  label: 'CV',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ];

        return Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            items: navItems,
          ),
        );
      },
    );
  }
}
