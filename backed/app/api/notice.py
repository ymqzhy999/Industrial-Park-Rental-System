from flask import Blueprint, request, jsonify
from app.models import Announcement
from ..extensions import db

notice_bp = Blueprint('notice', __name__, url_prefix='/api/notice')


@notice_bp.route('/list', methods=['GET'])
def get_notice_list():
    """获取公告列表"""
    notices = Announcement.query.order_by(Announcement.create_time.desc()).all()
    res = []
    for n in notices:
        res.append({
            'id': n.notice_id,
            'title': n.title,
            'content': n.content,
            'time': n.create_time.strftime('%Y-%m-%d %H:%M')
        })
    return jsonify({'code': 200, 'data': res})


@notice_bp.route('/add', methods=['POST'])
def add_notice():
    """发布公告"""
    data = request.get_json()
    title = data.get('title')
    content = data.get('content')

    if not title or not content:
        return jsonify({'code': 400, 'msg': '标题和内容不能为空'}), 400

    new_n = Announcement(title=title, content=content)
    db.session.add(new_n)
    db.session.commit()
    return jsonify({'code': 200, 'msg': '发布成功'})


@notice_bp.route('/delete', methods=['POST'])
def delete_notice():
    """删除公告"""
    data = request.get_json()
    n_id = data.get('id')

    n = Announcement.query.get(n_id)
    if n:
        db.session.delete(n)
        db.session.commit()
        return jsonify({'code': 200, 'msg': '删除成功'})
    return jsonify({'code': 404, 'msg': '公告不存在'}), 404


@notice_bp.route('/detail/<int:notice_id>', methods=['GET'])
def get_notice_detail(notice_id):
    """获取公告详情"""
    n = Announcement.query.get(notice_id)
    if not n:
        return jsonify({'code': 404, 'msg': '公告不存在'}), 404

    return jsonify({
        'code': 200,
        'data': {
            'id': n.notice_id,
            'title': n.title,
            'content': n.content,
            'time': n.create_time.strftime('%Y-%m-%d %H:%M:%S')
        }
    })