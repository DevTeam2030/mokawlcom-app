import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/core/utils/safe_api_call.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/customer_deals/data/data_source/customer_deals_data_source.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/add_customer_deal_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/add_customer_deal_response_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_details_response_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/contractor_deals_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_reply_to_contractor_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deals_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/initial_deal_reply_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/update_customer_deal_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/repo/customer_deals_repo.dart';

class CustomerDealsRepoImpl implements CustomerDealsRepo {
  CustomerDealsRepoImpl({required this.customerDealsDataSource});

  final CustomerDealsDataSource customerDealsDataSource;

  @override
  Future<Either<Failure, AddCustomerDealResponseModel>> addCustomerDeal({
    required AddCustomerDealRequestModel request,
  }) async => safeApiCall<AddCustomerDealResponseModel>(
    () => customerDealsDataSource.addCustomerDeal(request: request),
  );

  @override
  Future<Either<Failure, AddCustomerDealResponseModel>> updateCustomerDeal({
    required UpdateCustomerDealRequestModel request,
  }) async => safeApiCall<AddCustomerDealResponseModel>(
    () => customerDealsDataSource.updateCustomerDeal(request: request),
  );

  @override
  Future<Either<Failure, AddCustomerDealResponseModel>> submitInitialReply({
    required InitialDealReplyRequestModel request,
  }) async => safeApiCall<AddCustomerDealResponseModel>(
    () => customerDealsDataSource.submitInitialReply(request: request),
  );

  @override
  Future<Either<Failure, AddCustomerDealResponseModel>> replyToContractor({
    required CustomerReplyToContractorRequestModel request,
  }) async => safeApiCall<AddCustomerDealResponseModel>(
    () => customerDealsDataSource.replyToContractor(request: request),
  );

  @override
  Future<Either<Failure, String>> deleteCustomerDeal({
    required int dealId,
  }) async => safeApiCall<String>(
    () => customerDealsDataSource.deleteCustomerDeal(dealId: dealId),
  );

  @override
  Future<Either<Failure, String>> deleteDealAttachment({
    required int attachmentId,
  }) async => safeApiCall<String>(
    () => customerDealsDataSource.deleteDealAttachment(
      attachmentId: attachmentId,
    ),
  );

  @override
  Future<Either<Failure, ContractorDealsModel>> getContractorDeals({
    required int page,
  }) async => safeApiCall<ContractorDealsModel>(
    () => customerDealsDataSource.getContractorDeals(page: page),
  );

  @override
  Future<Either<Failure, CustomerDealsModel>> getMyDeals({
    required int page,
  }) async => safeApiCall<CustomerDealsModel>(
    () => customerDealsDataSource.getMyDeals(page: page),
  );

  @override
  Future<Either<Failure, CustomerDealDetailsResponseModel>> getMyDealDetails({
    required int dealId,
  }) async => safeApiCall<CustomerDealDetailsResponseModel>(
    () => customerDealsDataSource.getMyDealDetails(dealId: dealId),
  );
}
