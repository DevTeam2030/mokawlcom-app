import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/add_customer_deal_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/add_customer_deal_response_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_details_response_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/contractor_deals_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_reply_to_contractor_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deals_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/initial_deal_reply_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/update_customer_deal_request_model.dart';

abstract class CustomerDealsRepo {
  Future<Either<Failure, AddCustomerDealResponseModel>> addCustomerDeal({
    required AddCustomerDealRequestModel request,
  });

  Future<Either<Failure, AddCustomerDealResponseModel>> updateCustomerDeal({
    required UpdateCustomerDealRequestModel request,
  });

  Future<Either<Failure, AddCustomerDealResponseModel>> submitInitialReply({
    required InitialDealReplyRequestModel request,
  });

  Future<Either<Failure, AddCustomerDealResponseModel>> replyToContractor({
    required CustomerReplyToContractorRequestModel request,
  });

  Future<Either<Failure, String>> deleteCustomerDeal({required int dealId});

  Future<Either<Failure, String>> deleteDealAttachment({
    required int attachmentId,
  });

  Future<Either<Failure, ContractorDealsModel>> getContractorDeals({
    required int page,
  });

  Future<Either<Failure, CustomerDealsModel>> getMyDeals({required int page});

  Future<Either<Failure, CustomerDealDetailsResponseModel>> getMyDealDetails({
    required int dealId,
  });
}
