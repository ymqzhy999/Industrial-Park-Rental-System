from flask import Blueprint, request, jsonify
from app.models import User
from app.extensions import db
from app.utils import aes_encrypt

user_bp = Blueprint('user', __name__, url_prefix='/api/user')


@user_bp.route('/info', methods=['POST'])
def get_user_info():
    """获取当前用户信息"""
    data = request.get_json()
    username = data.get('username')

    user = User.query.filter_by(username=username).first()
    if not user:
        return jsonify({'code': 404, 'msg': '用户不存在'}), 404

    return jsonify({
        'code': 200,
        'data': {
            'user_id': user.user_id,
            'username': user.username,
            'real_name': user.real_name,
            'role': user.role
        }
    })


@user_bp.route('/update_info', methods=['POST'])
def update_info():
    """修改用户基本信息 (真实姓名)"""
    data = request.get_json()
    username = data.get('username')
    new_real_name = data.get('real_name')

    user = User.query.filter_by(username=username).first()
    if not user:
        return jsonify({'code': 404, 'msg': '用户不存在'}), 404

    user.real_name = new_real_name
    db.session.commit()

    return jsonify({'code': 200, 'msg': '信息修改成功'})


@user_bp.route('/change_password', methods=['POST'])
def change_password():
    """修改密码 (用户自改)"""
    data = request.get_json()
    username = data.get('username')
    old_password = data.get('old_password')
    new_password = data.get('new_password')

    user = User.query.filter_by(username=username).first()
    if not user:
        return jsonify({'code': 404, 'msg': '用户不存在'}), 404

    # 校验旧密码
    if user.password != aes_encrypt(old_password):
        return jsonify({'code': 400, 'msg': '旧密码错误'}), 400

    user.password = aes_encrypt(new_password)
    db.session.commit()

    return jsonify({'code': 200, 'msg': '密码修改成功，请重新登录'})


@user_bp.route('/list', methods=['GET'])
def get_user_list():
    """[管理员] 获取所有用户列表"""
    users = User.query.order_by(User.user_id.desc()).all()

    data = []
    for u in users:
        data.append({
            'id': u.user_id,
            'username': u.username,
            'real_name': u.real_name,
            'role': u.role
        })
    return jsonify({'code': 200, 'data': data})


@user_bp.route('/reset_pwd', methods=['POST'])
def reset_password():
    """[管理员] 重置用户密码 (默认为 123456)"""
    data = request.get_json()
    user_id = data.get('id')

    user = User.query.get(user_id)
    if not user:
        return jsonify({'code': 404, 'msg': '用户不存在'}), 404

    user.password = aes_encrypt('123456')
    db.session.commit()

    return jsonify({'code': 200, 'msg': f'用户 {user.username} 密码已重置为 123456'})


@user_bp.route('/delete', methods=['POST'])
def delete_user():
    """[管理员] 删除用户"""
    data = request.get_json()
    user_id = data.get('id')

    user = User.query.get(user_id)
    if not user:
        return jsonify({'code': 404, 'msg': '用户不存在'}), 404

    if user.role == 0:
        return jsonify({'code': 400, 'msg': '管理员账号不能删除！'}), 400

    db.session.delete(user)
    db.session.commit()
    return jsonify({'code': 200, 'msg': '删除成功'})