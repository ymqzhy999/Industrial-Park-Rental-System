import base64
import uuid
import time
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad
from captcha.image import ImageCaptcha
from .config import Config

# 简单的内存缓存用于存储验证码
CAPTCHA_STORE = {}


def aes_encrypt(text):
    """
    AES 加密函数
    :param text: 待加密的明文字符串
    :return: base64 编码的加密字符串
    """
    cipher = AES.new(Config.AES_KEY, AES.MODE_CBC, Config.AES_IV)
    encrypted_bytes = cipher.encrypt(pad(text.encode('utf-8'), AES.block_size))
    return base64.b64encode(encrypted_bytes).decode('utf-8')


def clean_expired_captcha():
    """清理过期的验证码"""
    current_time = time.time()
    # 使用 list 转换 keys 以避免运行时字典大小改变的错误
    for uid in list(CAPTCHA_STORE.keys()):
        if current_time > CAPTCHA_STORE[uid]['expire']:
            del CAPTCHA_STORE[uid]


def generate_captcha_image():
    """
    生成验证码图片和唯一标识(UID)
    :return: (image_data, uid)
    """
    # 配置验证码图片参数
    image = ImageCaptcha(width=200, height=50, font_sizes=(35, 40, 45))

    # 生成4位随机验证码
    code = str(uuid.uuid4().hex)[:4].upper()
    image_data = image.generate(code)

    # 生成唯一标识 UID
    uid = str(uuid.uuid4())

    # 存入缓存 (5分钟有效)
    CAPTCHA_STORE[uid] = {
        'code': code,
        'expire': time.time() + 300
    }

    # 触发一次过期清理
    clean_expired_captcha()

    return image_data, uid


def verify_captcha(uid, input_code):
    """
    校验验证码
    :param uid: 验证码唯一标识
    :param input_code: 用户输入的验证码
    :return: (bool, msg)
    """
    stored = CAPTCHA_STORE.get(uid)

    if not stored:
        return False, "验证码不存在或已过期"

    if time.time() > stored['expire']:
        del CAPTCHA_STORE[uid]
        return False, "验证码已过期"

    if stored['code'].lower() != input_code.lower():
        return False, "验证码错误"

    # 验证成功后立即删除，防止重放攻击
    del CAPTCHA_STORE[uid]
    return True, "验证通过"