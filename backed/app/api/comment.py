from flask import Blueprint, request, jsonify
from app.models import Comment, User
from ..extensions import db

comment_bp = Blueprint('comment', __name__, url_prefix='/api/comment')


@comment_bp.route('/add', methods=['POST'])
def add_comment():
    """发布评论"""
    data = request.get_json()
    username = data.get('username')
    factory_id = data.get('factory_id')
    content = data.get('content')
    score = data.get('score', 5)

    if not all([username, factory_id, content]):
        return jsonify({'code': 400, 'msg': '参数不全'}), 400

    user = User.query.filter_by(username=username).first()
    if not user:
        return jsonify({'code': 404, 'msg': '用户不存在'}), 404

    new_comment = Comment(
        user_id=user.user_id,
        factory_id=factory_id,
        content=content,
        score=score
    )

    db.session.add(new_comment)
    db.session.commit()

    return jsonify({'code': 200, 'msg': '评论发布成功'})


@comment_bp.route('/list/<int:factory_id>', methods=['GET'])
def get_comments(factory_id):
    """获取某厂房的评论列表"""
    comments = Comment.query.filter_by(factory_id=factory_id).order_by(Comment.create_time.desc()).all()

    res = []
    for c in comments:
        res.append({
            'id': c.comment_id,
            'user_name': c.user.real_name or c.user.username,
            'avatar': 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png',
            'content': c.content,
            'score': c.score,
            'time': c.create_time.strftime('%Y-%m-%d %H:%M')
        })

    return jsonify({'code': 200, 'data': res})