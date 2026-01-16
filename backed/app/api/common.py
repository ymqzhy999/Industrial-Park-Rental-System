from flask import Blueprint, make_response
from app.utils import generate_captcha_image

common_bp = Blueprint('common', __name__, url_prefix='/api')


@common_bp.route('/captcha', methods=['GET'])
def get_captcha():
    """获取验证码图片接口"""
    data, uid = generate_captcha_image()
    image_data = data.read()

    response = make_response(image_data)
    response.content_type = 'image/png'

    # 将 UID 放入 Header 返回给前端
    response.headers['Captcha-ID'] = uid
    response.headers['Access-Control-Expose-Headers'] = 'Captcha-ID'

    return response