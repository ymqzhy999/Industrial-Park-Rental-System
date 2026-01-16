from flask import Blueprint, request, jsonify
from sqlalchemy import desc, or_
from app.models import FactoryInfo, Collection
from app.extensions import db

factory_bp = Blueprint('factory', __name__, url_prefix='/api/factory')


@factory_bp.route('/list', methods=['POST'])
def get_factory_list():
    """获取厂房列表 (支持搜索 + 分页 + 收藏状态)"""
    data = request.get_json() or {}
    page = data.get('page', 1)
    page_size = data.get('pageSize', 10)
    keyword = data.get('keyword', '')
    user_id = data.get('userId')

    query = FactoryInfo.query

    if keyword:
        rule = or_(FactoryInfo.title.contains(keyword), FactoryInfo.address.contains(keyword))
        query = query.filter(rule)

    pagination = query.order_by(desc(FactoryInfo.create_time)).paginate(page=page, per_page=page_size, error_out=False)

    my_collected_ids = set()
    if user_id:
        user_collections = Collection.query.filter_by(user_id=user_id).all()
        my_collected_ids = {c.factory_id for c in user_collections}

    res_data = []
    for f in pagination.items:
        is_collected = f.factory_id in my_collected_ids
        img_url = f.images.split(',')[0] if (f.images and ',' in f.images) else f.images

        res_data.append({
            'id': f.factory_id,
            'title': f.title,
            'price': f.price_per_month,
            'area': f.area,
            'address': f.address,
            'image': img_url,
            'tags': f.tags.split(',') if f.tags else [],
            'status': f.status,
            'floor_height': f.floor_height or 6.0,
            'power_supply': f.power_supply or '100KVA',
            'is_collected': is_collected
        })

    return jsonify({
        'code': 200,
        'data': res_data,
        'total': pagination.total
    })


@factory_bp.route('/detail/<int:id>', methods=['GET'])
def get_factory_detail(id):
    """获取厂房详情"""
    f = FactoryInfo.query.get(id)
    if not f:
        return jsonify({'code': 404, 'msg': '不存在'}), 404

    return jsonify({
        'code': 200,
        'data': {
            'id': f.factory_id,
            'title': f.title,
            'images': f.images,
            'price_per_month': f.price_per_month,
            'area': f.area,
            'address': f.address,
            'description': f.description,
            'floor_height': f.floor_height,
            'power_supply': f.power_supply,
            'floor_load': f.floor_load,
            'structure': f.structure,
            'tags': f.tags,
            'status': f.status,
            'create_time': f.create_time.strftime('%Y-%m-%d') if f.create_time else ''
        }
    })


@factory_bp.route('/collect', methods=['POST'])
def toggle_collect():
    """收藏/取消收藏"""
    data = request.get_json()
    factory_id = data.get('factory_id')
    action = data.get('action')
    user_id = data.get('user_id')

    if not all([factory_id, action, user_id]):
        return jsonify({'code': 400, 'msg': '参数不完整'}), 400

    exists = Collection.query.filter_by(user_id=user_id, factory_id=factory_id).first()

    msg = ''
    if action == 'add':
        if not exists:
            new_col = Collection(user_id=user_id, factory_id=factory_id)
            db.session.add(new_col)
            msg = '收藏成功'
        else:
            msg = '已收藏'
    elif action == 'remove':
        if exists:
            db.session.delete(exists)
            msg = '取消收藏成功'
        else:
            msg = '未收藏'

    try:
        db.session.commit()
        return jsonify({'code': 200, 'msg': msg})
    except Exception as e:
        db.session.rollback()
        return jsonify({'code': 500, 'msg': str(e)}), 500