import datetime
from flask import Blueprint, jsonify
from sqlalchemy import func
from app.models import User, FactoryInfo, Contract, Payment
from ..extensions import db

dashboard_bp = Blueprint('dashboard', __name__, url_prefix='/api/dashboard')


@dashboard_bp.route('/stats', methods=['GET'])
def get_dashboard_stats():
    """获取仪表盘统计数据"""
    # 1. 核心指标
    user_count = User.query.filter_by(role=1).count()
    factory_total = FactoryInfo.query.count()
    pending_contract = Contract.query.filter_by(status=0).count()

    total_income_res = db.session.query(func.sum(Payment.amount)).scalar()
    total_income = total_income_res if total_income_res else 0

    # 2. 房源状态分布 (饼图)
    status_counts = db.session.query(
        FactoryInfo.status, func.count(FactoryInfo.factory_id)
    ).group_by(FactoryInfo.status).all()

    status_map = {0: '空闲招租', 1: '已出租'}
    pie_data = [{'name': status_map.get(s, '未知'), 'value': c} for s, c in status_counts]

    # 3. 近6个月收入趋势 (折线图)
    today = datetime.datetime.now()
    six_months_ago = today - datetime.timedelta(days=180)

    # 查出近半年所有记录并在内存中聚合 (数据量大时建议用 SQL Group By)
    payments = Payment.query.filter(Payment.pay_time >= six_months_ago).all()

    monthly_data = {}
    for i in range(5, -1, -1):
        key = (today - datetime.timedelta(days=i * 30)).strftime('%Y-%m')
        monthly_data[key] = 0

    for p in payments:
        if p.pay_time:
            key = p.pay_time.strftime('%Y-%m')
            if key in monthly_data:
                monthly_data[key] += p.amount

    return jsonify({
        'code': 200,
        'data': {
            'card': {
                'users': user_count,
                'factories': factory_total,
                'contracts': pending_contract,
                'income': total_income
            },
            'pie': pie_data,
            'line': {
                'x': list(monthly_data.keys()),
                'y': list(monthly_data.values())
            }
        }
    })