from flask import Blueprint, request, jsonify
from app.models import Contract, Payment, FactoryInfo
from app.extensions import db
import datetime

# 关键点：这里定义了 payment_bp，__init__.py 才能引用它
payment_bp = Blueprint('payment', __name__, url_prefix='/api/payment')


# 1. [租户] 模拟支付接口
@payment_bp.route('/pay', methods=['POST'])
def pay_contract():
    data = request.get_json()
    contract_id = data.get('contract_id')

    contract = Contract.query.get(contract_id)
    if not contract:
        return jsonify({'code': 404, 'msg': '合同不存在'}), 404

    if contract.status != 3:
        return jsonify({'code': 400, 'msg': '当前状态无法支付'}), 400

    # 创建支付记录
    new_pay = Payment(
        contract_id=contract.contract_id,
        amount=contract.total_price,
        pay_method='在线钱包'
    )

    # 修改合同状态为 1 (生效中)
    contract.status = 1

    # 【核心逻辑】同时修改厂房状态为 1 (已租)，防止被重复申请
    if contract.factory:
        contract.factory.status = 1

    db.session.add(new_pay)
    db.session.commit()

    return jsonify({'code': 200, 'msg': '支付成功！合同已生效'})


# 2. [管理员] 获取所有支付流水
@payment_bp.route('/admin/list', methods=['POST'])
def get_all_payments():
    data = request.get_json() or {}
    page = data.get('page', 1)
    page_size = data.get('pageSize', 10)

    # 按时间倒序
    query = Payment.query.order_by(Payment.pay_time.desc())
    pagination = query.paginate(page=page, per_page=page_size, error_out=False)

    res = []
    for p in pagination.items:
        contract_no = p.contract.contract_no if p.contract else '未知合同'
        payer_name = '未知用户'
        if p.contract:
            if p.contract.party_b:
                payer_name = p.contract.party_b
            elif p.contract.user:
                payer_name = p.contract.user.real_name

        res.append({
            'id': p.payment_id,
            'contract_no': contract_no,
            'payer': payer_name,
            'amount': p.amount,
            'pay_method': p.pay_method or '在线支付',
            'pay_time': p.pay_time.strftime('%Y-%m-%d %H:%M:%S') if p.pay_time else ''
        })

    return jsonify({
        'code': 200,
        'data': res,
        'total': pagination.total
    })