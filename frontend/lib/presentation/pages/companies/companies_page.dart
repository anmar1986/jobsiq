import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../config/di/injection.dart';
import '../../../config/routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/company_entity.dart';
import '../../bloc/companies/companies_bloc.dart';
import '../../bloc/companies/companies_event.dart';
import '../../bloc/companies/companies_state.dart';

class CompaniesPage extends StatefulWidget {
  const CompaniesPage({super.key});

  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<CompaniesBloc>().state;
      if (state is CompaniesLoaded && state.hasMore) {
        context.read<CompaniesBloc>().add(
              LoadCompaniesEvent(
                search: _searchController.text,
                page: state.currentPage + 1,
              ),
            );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    context.read<CompaniesBloc>().add(LoadCompaniesEvent(
          search: query.isEmpty ? null : query,
          page: 1,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CompaniesBloc>()..add(const LoadCompaniesEvent()),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Search Header
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Companies',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search companies...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.withValues(alpha: 0.05),
                      ),
                      onChanged: (value) {
                        setState(() {});
                        if (value.isEmpty) {
                          _onSearchChanged();
                        }
                      },
                      onSubmitted: (value) => _onSearchChanged(),
                    ),
                  ],
                ),
              ),

              // Companies List
              Expanded(
                child: BlocBuilder<CompaniesBloc, CompaniesState>(
                  builder: (context, state) {
                    if (state is CompaniesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is CompaniesError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 64.sp,
                              color: Colors.red,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () {
                                context.read<CompaniesBloc>().add(
                                      const RefreshCompaniesEvent(),
                                    );
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is CompaniesEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.business_outlined,
                              size: 64.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No companies found',
                              style: TextStyle(fontSize: 18.sp),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Try adjusting your search',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is CompaniesLoaded ||
                        state is CompaniesLoadingMore) {
                      final companies = state is CompaniesLoaded
                          ? state.companies
                          : (state as CompaniesLoadingMore).companies;

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<CompaniesBloc>().add(
                                LoadCompaniesEvent(
                                  search: _searchController.text.isEmpty
                                      ? null
                                      : _searchController.text,
                                  page: 1,
                                ),
                              );
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(16.w),
                          itemCount: companies.length + 1,
                          itemBuilder: (context, index) {
                            if (index == companies.length) {
                              if (state is CompaniesLoadingMore) {
                                return Padding(
                                  padding: EdgeInsets.all(16.h),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (state is CompaniesLoaded && state.hasMore) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: EdgeInsets.all(16.h),
                                child: Center(
                                  child: Text(
                                    'No more companies',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return _buildCompanyCard(context, companies[index]);
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, CompanyEntity company) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () {
          context.push(
            AppRouter.companyDetails.replaceAll(':slug', company.slug),
            extra: company,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Company Logo
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: company.logo != null && company.logo!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: company.logoUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.business,
                            size: 32.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.business,
                        size: 32.sp,
                        color: AppColors.primary,
                      ),
              ),
              SizedBox(width: 16.w),

              // Company Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    if (company.industry != null &&
                        company.industry!.isNotEmpty) ...[
                      Text(
                        company.industry!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                    ],
                    Row(
                      children: [
                        if (company.location.isNotEmpty) ...[
                          Icon(
                            Icons.location_on_outlined,
                            size: 14.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              company.location,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${company.jobsCount} open position${company.jobsCount != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
