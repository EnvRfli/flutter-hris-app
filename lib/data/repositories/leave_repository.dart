import '../models/leave_request.dart';
import '../models/overtime_request.dart';
import 'package:flutter/material.dart';

class LeaveRepository {
  // Fake leave requests data
  Future<List<LeaveRequest>> getUserLeaves(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();

    return [
      LeaveRequest(
        id: 'leave_1',
        userId: userId,
        type: LeaveType.annual,
        startDate: now.add(const Duration(days: 10)),
        endDate: now.add(const Duration(days: 12)),
        reason: 'Liburan keluarga',
        status: LeaveStatus.approved,
        requestDate: now.subtract(const Duration(days: 5)),
        approvedDate: now.subtract(const Duration(days: 3)),
      ),
      LeaveRequest(
        id: 'leave_2',
        userId: userId,
        type: LeaveType.sick,
        startDate: now.subtract(const Duration(days: 7)),
        endDate: now.subtract(const Duration(days: 7)),
        reason: 'Sakit demam',
        status: LeaveStatus.approved,
        requestDate: now.subtract(const Duration(days: 8)),
        approvedDate: now.subtract(const Duration(days: 7)),
      ),
      LeaveRequest(
        id: 'leave_3',
        userId: userId,
        type: LeaveType.permission,
        startDate: now.add(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 2)),
        reason: 'Keperluan keluarga',
        status: LeaveStatus.pending,
        requestDate: now,
      ),
    ];
  }

  Future<List<OvertimeRequest>> getUserOvertimes(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();

    return [
      OvertimeRequest(
        id: 'overtime_1',
        userId: userId,
        date: now.add(const Duration(days: 1)),
        startTime: const TimeOfDay(hour: 17, minute: 0),
        endTime: const TimeOfDay(hour: 20, minute: 0),
        reason: 'Menyelesaikan project deadline',
        status: OvertimeStatus.approved,
        requestDate: now.subtract(const Duration(days: 1)),
        approvedDate: now,
      ),
      OvertimeRequest(
        id: 'overtime_2',
        userId: userId,
        date: now.subtract(const Duration(days: 3)),
        startTime: const TimeOfDay(hour: 17, minute: 0),
        endTime: const TimeOfDay(hour: 19, minute: 30),
        reason: 'Meeting dengan client',
        status: OvertimeStatus.approved,
        requestDate: now.subtract(const Duration(days: 4)),
        approvedDate: now.subtract(const Duration(days: 3)),
      ),
    ];
  }

  // Submit new leave request
  Future<bool> submitLeaveRequest(LeaveRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    return true; // Simulate success
  }

  // Submit new overtime request
  Future<bool> submitOvertimeRequest(OvertimeRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    return true; // Simulate success
  }

  // Cancel leave request
  Future<bool> cancelLeaveRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // Get leave balance
  Future<Map<String, int>> getLeaveBalance(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return {
      'annual': 12, // Remaining annual leave days
      'sick': 5, // Remaining sick leave days
      'total': 12, // Total annual leave per year
    };
  }
}
