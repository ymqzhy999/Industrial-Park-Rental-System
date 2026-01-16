import os


class Config:
    """系统配置类"""

    # 数据库连接配置 (MySQL)
    SQLALCHEMY_DATABASE_URI = os.getenv(
        'DATABASE_URL',
        'mysql+pymysql://root:root@localhost:3306/rental_db'
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    # AES 加密配置 (必须为16字节)
    AES_KEY = b'1234567890123456'
    AES_IV = b'1234567890123456'