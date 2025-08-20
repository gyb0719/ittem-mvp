import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:html' as html;
import '../config/env.dart';
import '../shared/models/user_model.dart';

class PaymentService {
  static const _uuid = Uuid();
  
  // Payment Methods
  Future<PaymentResult> requestPayment({
    required String itemId,
    required String itemTitle,
    required int amount,
    required UserModel buyer,
    required UserModel seller,
    String paymentMethod = 'card',
  }) async {
    try {
      final merchantUid = 'payment_${_uuid.v4()}';
      
      if (kIsWeb) {
        return await _requestWebPayment(
          merchantUid: merchantUid,
          itemId: itemId,
          itemTitle: itemTitle,
          amount: amount,
          buyer: buyer,
          paymentMethod: paymentMethod,
        );
      } else {
        return await _requestMobilePayment(
          merchantUid: merchantUid,
          itemId: itemId,
          itemTitle: itemTitle,
          amount: amount,
          buyer: buyer,
          paymentMethod: paymentMethod,
        );
      }
    } catch (e) {
      if (Env.enableLogging) print('Payment request error: $e');
      return PaymentResult.failure('결제 요청 중 오류가 발생했습니다: $e');
    }
  }
  
  Future<PaymentResult> _requestWebPayment({
    required String merchantUid,
    required String itemId,
    required String itemTitle,
    required int amount,
    required UserModel buyer,
    required String paymentMethod,
  }) async {
    try {
      // PortOne Web SDK를 사용한 결제 요청
      final paymentData = {
        'pg': 'html5_inicis', // PG사 설정
        'pay_method': paymentMethod,
        'merchant_uid': merchantUid,
        'name': itemTitle,
        'amount': amount,
        'buyer_email': buyer.email,
        'buyer_name': buyer.name,
        'buyer_tel': buyer.phoneNumber ?? '010-0000-0000',
        'buyer_addr': buyer.location,
        'buyer_postcode': '06018',
        'm_redirect_url': '${html.window.location.origin}/payment/complete',
      };
      
      // JavaScript를 통한 PortOne 결제 호출
      final paymentScript = '''
        function requestPayment() {
          return new Promise((resolve, reject) => {
            if (typeof IMP === 'undefined') {
              reject(new Error('PortOne SDK가 로드되지 않았습니다'));
              return;
            }
            
            IMP.init('${Env.portoneApiKey}');
            
            IMP.request_pay(${json.encode(paymentData)}, function(response) {
              if (response.success) {
                resolve({
                  success: true,
                  impUid: response.imp_uid,
                  merchantUid: response.merchant_uid,
                  paidAmount: response.paid_amount,
                  payMethod: response.pay_method,
                  pgProvider: response.pg_provider,
                });
              } else {
                reject(new Error(response.error_msg || '결제가 실패했습니다'));
              }
            });
          });
        }
        
        requestPayment();
      ''';
      
      // Execute JavaScript payment
      final result = await _executeJavaScript(paymentScript);
      
      if (result['success'] == true) {
        // 결제 검증
        final verification = await _verifyPayment(
          impUid: result['impUid'],
          merchantUid: merchantUid,
          amount: amount,
        );
        
        if (verification.isSuccess) {
          return PaymentResult.success(
            impUid: result['impUid'],
            merchantUid: merchantUid,
            paidAmount: result['paidAmount'],
            payMethod: result['payMethod'],
          );
        } else {
          return PaymentResult.failure('결제 검증에 실패했습니다');
        }
      } else {
        return PaymentResult.failure(result['error'] ?? '결제가 실패했습니다');
      }
    } catch (e) {
      if (Env.enableLogging) print('Web payment error: $e');
      return PaymentResult.failure('웹 결제 처리 중 오류가 발생했습니다: $e');
    }
  }
  
  Future<PaymentResult> _requestMobilePayment({
    required String merchantUid,
    required String itemId,
    required String itemTitle,
    required int amount,
    required UserModel buyer,
    required String paymentMethod,
  }) async {
    try {
      // 모바일 결제 구현 (flutter_portone 패키지 사용)
      // 실제 구현시 portone_flutter 패키지의 API를 사용
      
      return PaymentResult.failure('모바일 결제는 아직 구현되지 않았습니다');
    } catch (e) {
      if (Env.enableLogging) print('Mobile payment error: $e');
      return PaymentResult.failure('모바일 결제 처리 중 오류가 발생했습니다: $e');
    }
  }
  
  // 결제 검증
  Future<PaymentVerification> _verifyPayment({
    required String impUid,
    required String merchantUid,
    required int amount,
  }) async {
    try {
      // PortOne REST API를 통한 결제 정보 조회 및 검증
      // 실제 구현시에는 백엔드 서버에서 검증해야 함
      
      // 임시 성공 반환 (실제로는 API 호출 필요)
      await Future.delayed(const Duration(seconds: 1));
      
      return PaymentVerification(
        isSuccess: true,
        impUid: impUid,
        merchantUid: merchantUid,
        amount: amount,
        status: 'paid',
      );
    } catch (e) {
      if (Env.enableLogging) print('Payment verification error: $e');
      return PaymentVerification(
        isSuccess: false,
        error: '결제 검증 중 오류가 발생했습니다: $e',
      );
    }
  }
  
  // JavaScript 실행 헬퍼 (웹 전용)
  Future<Map<String, dynamic>> _executeJavaScript(String script) async {
    if (!kIsWeb) {
      throw UnsupportedError('JavaScript execution is only supported on web');
    }
    
    // JavaScript 실행 및 결과 반환
    // 실제 구현시에는 dart:js_interop을 사용하거나 
    // 별도의 JavaScript 브릿지 구현 필요
    
    // 임시 성공 결과 반환
    await Future.delayed(const Duration(seconds: 2));
    return {
      'success': true,
      'impUid': 'imp_${_uuid.v4()}',
      'merchantUid': 'merchant_${_uuid.v4()}',
      'paidAmount': 25000,
      'payMethod': 'card',
      'pgProvider': 'html5_inicis',
    };
  }
  
  // 결제 취소
  Future<PaymentCancelResult> cancelPayment({
    required String impUid,
    required String reason,
    int? cancelRequestAmount,
  }) async {
    try {
      // PortOne REST API를 통한 결제 취소
      // 실제 구현시에는 백엔드 서버에서 처리해야 함
      
      await Future.delayed(const Duration(seconds: 1));
      
      return PaymentCancelResult(
        isSuccess: true,
        impUid: impUid,
        cancelAmount: cancelRequestAmount ?? 0,
        reason: reason,
      );
    } catch (e) {
      if (Env.enableLogging) print('Payment cancel error: $e');
      return PaymentCancelResult(
        isSuccess: false,
        error: '결제 취소 중 오류가 발생했습니다: $e',
      );
    }
  }
  
  // 결제 내역 조회
  Future<List<PaymentHistory>> getPaymentHistory(String userId) async {
    try {
      // 사용자의 결제 내역 조회
      // 실제로는 Supabase나 백엔드 API에서 조회
      
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        PaymentHistory(
          id: '1',
          impUid: 'imp_123456789',
          merchantUid: 'merchant_123456789',
          itemTitle: '캐논 DSLR 카메라',
          amount: 15000,
          status: 'paid',
          payMethod: 'card',
          paidAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        PaymentHistory(
          id: '2',
          impUid: 'imp_987654321',
          merchantUid: 'merchant_987654321',
          itemTitle: '캠핑 텐트',
          amount: 25000,
          status: 'paid',
          payMethod: 'trans',
          paidAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
    } catch (e) {
      if (Env.enableLogging) print('Get payment history error: $e');
      return [];
    }
  }
}

// Data Models
class PaymentResult {
  final bool isSuccess;
  final String? impUid;
  final String? merchantUid;
  final int? paidAmount;
  final String? payMethod;
  final String? error;
  
  PaymentResult._({
    required this.isSuccess,
    this.impUid,
    this.merchantUid,
    this.paidAmount,
    this.payMethod,
    this.error,
  });
  
  factory PaymentResult.success({
    required String impUid,
    required String merchantUid,
    required int paidAmount,
    required String payMethod,
  }) {
    return PaymentResult._(
      isSuccess: true,
      impUid: impUid,
      merchantUid: merchantUid,
      paidAmount: paidAmount,
      payMethod: payMethod,
    );
  }
  
  factory PaymentResult.failure(String error) {
    return PaymentResult._(
      isSuccess: false,
      error: error,
    );
  }
}

class PaymentVerification {
  final bool isSuccess;
  final String? impUid;
  final String? merchantUid;
  final int? amount;
  final String? status;
  final String? error;
  
  PaymentVerification({
    required this.isSuccess,
    this.impUid,
    this.merchantUid,
    this.amount,
    this.status,
    this.error,
  });
}

class PaymentCancelResult {
  final bool isSuccess;
  final String? impUid;
  final int? cancelAmount;
  final String? reason;
  final String? error;
  
  PaymentCancelResult({
    required this.isSuccess,
    this.impUid,
    this.cancelAmount,
    this.reason,
    this.error,
  });
}

class PaymentHistory {
  final String id;
  final String impUid;
  final String merchantUid;
  final String itemTitle;
  final int amount;
  final String status;
  final String payMethod;
  final DateTime paidAt;
  
  PaymentHistory({
    required this.id,
    required this.impUid,
    required this.merchantUid,
    required this.itemTitle,
    required this.amount,
    required this.status,
    required this.payMethod,
    required this.paidAt,
  });
}

// State Management
class PaymentState {
  final bool isProcessing;
  final PaymentResult? lastResult;
  final String? error;
  
  const PaymentState({
    this.isProcessing = false,
    this.lastResult,
    this.error,
  });
  
  PaymentState copyWith({
    bool? isProcessing,
    PaymentResult? lastResult,
    String? error,
  }) {
    return PaymentState(
      isProcessing: isProcessing ?? this.isProcessing,
      lastResult: lastResult ?? this.lastResult,
      error: error ?? this.error,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentService _paymentService;
  
  PaymentNotifier(this._paymentService) : super(const PaymentState());
  
  Future<void> processPayment({
    required String itemId,
    required String itemTitle,
    required int amount,
    required UserModel buyer,
    required UserModel seller,
    String paymentMethod = 'card',
  }) async {
    state = state.copyWith(isProcessing: true, error: null);
    
    try {
      final result = await _paymentService.requestPayment(
        itemId: itemId,
        itemTitle: itemTitle,
        amount: amount,
        buyer: buyer,
        seller: seller,
        paymentMethod: paymentMethod,
      );
      
      state = state.copyWith(
        isProcessing: false,
        lastResult: result,
        error: result.isSuccess ? null : result.error,
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

final paymentNotifierProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(ref.read(paymentServiceProvider));
});