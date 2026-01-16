import base64
from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad
from flask import Blueprint, request, jsonify
from app.models import User

auth_bp = Blueprint('auth', __name__, url_prefix='/api')

# AES 配置 (必须与 init_users.py 一致)
AES_KEY = b'1234567890123456'
AES_IV = b'1234567890123456'


def decrypt_password(encrypted_b64):
    """解密 AES 密码"""
    try:
        if not encrypted_b64: return ""
        ct = base64.b64decode(encrypted_b64)
        cipher = AES.new(AES_KEY, AES.MODE_CBC, AES_IV)
        pt = unpad(cipher.decrypt(ct), AES.block_size)
        return pt.decode('utf-8')
    except Exception:
        return ""


@auth_bp.route('/login', methods=['POST'])
def login():
    """用户登录接口"""
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')  # 明文

    # 1. 查用户
    user = User.query.filter_by(username=username).first()
    if not user:
        return jsonify({'code': 400, 'msg': '用户不存在'})

    # 2. 校验密码
    db_password_plain = decrypt_password(user.password)
    if not db_password_plain:
        # 解密失败或未加密，直接比对
        db_password_plain = user.password

    if db_password_plain != password:
        return jsonify({'code': 400, 'msg': '密码错误'})

    # 3. 构建返回数据
    user_info = {
        'user_id': user.user_id,
        'username': user.username,
        'real_name': user.real_name,
        'role': user.role,  # 0管理员 1普通用户
        'phone': user.phone,
        'token': f"token-{user.user_id}-xyz"
    }

    return jsonify({
        'code': 200,
        'msg': '登录成功',
        'data': user_info
    })